//
//  LocationViewModel.m
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "LocationViewModel.h"
#import "DMLocation.h"
#import "NWHttps.h"
#import "Keys.h"

@import CoreLocation;



// https://www.metaweather.com/api/location/search/?query=london
// https://www.metaweather.com/api/location/search/?lattlong=36.96,-122.02
static NSString * const kSearchAPI = @"https://www.metaweather.com/api/location/search/";



@interface LocationViewModel ()
<
    CLLocationManagerDelegate
>

@property (nonatomic, strong) NSMutableArray<DMLocation *> *arrLocations;
@property (nonatomic, strong) NSMutableArray<NSString *> *arrSearchHistories;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;

@property (nonatomic, copy) VoidBlock updateBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;

@end



@implementation LocationViewModel

-(instancetype _Nonnull)initWithUpdateBlock: (VoidBlock _Nonnull)updateBlock
                                 errorBlock: (ErrorBlock _Nonnull)errorBlock
{
    self = [super init];
    
    if (self)
    {
        self.updateBlock = updateBlock;
        self.errorBlock  = errorBlock;
    }
    
    return self;
}

-(void)updateLocationsWithArray: (NSArray *)arr
{
    [Dispatch dispatchAsyncToGlobalQueue: ^{
        
        [self.arrLocations removeAllObjects];
        
        for (NSDictionary *dict in arr)
        {
            DMLocation *loc = [DMLocation parseDictionary: dict];
            [self.arrLocations addObject: loc];
        }
    }
                        asyncToMainQueue: ^{
                            
                            self.updateBlock();
                        }];
}


// MARK: - # getter

-(NSMutableArray *)arrLocations
{
    if (!_arrLocations)
    {
        _arrLocations = [[NSMutableArray alloc] init];
    }
    
    return _arrLocations;
}

-(NSMutableArray<NSString *> *)arrSearchHistories
{
    if (!_arrSearchHistories)
    {
        _arrSearchHistories = [NSMutableArray new];
    }
    
    return _arrSearchHistories;
}

-(CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    return _locationManager;
}


// MARK: - # helper

-(DMLocation *)locationAtIndex: (NSInteger)index
{
    DMLocation *loc = self.arrLocations[index];
    return loc;
}


// MARK: - # CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    self.errorBlock(error);
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = locations.firstObject;
    self.currentLocation = loc.coordinate;
    
    [self fetchLocationsByLat: self.currentLocation.latitude
                          lon: self.currentLocation.longitude];
}


// MARK: - #

-(void)requestDeviceLocation
{
    [self.locationManager requestLocation];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            // disabled
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            // enabled
            break;
    }
}


// MARK: - # fetch

-(void)fetchLocationsWithQuery: (NSString *)query
{
    NSString *urlString = [NSString stringWithFormat: @"%@?%@", kSearchAPI, query];
    NSURL    *url       = [NSURL URLWithString: urlString];
    
    weakify(self);
    [NWHttps getURL: url
      responseBlock: ^(NSDictionary * _Nonnull dictionary) {
          
          strongify(self);
          [self updateLocationsWithArray: dictionary[kResults]];
      }
         errorBlock: self.errorBlock];
}

-(void)fetchLocationsByLat: (float)lat
                       lon: (float)lon
{
    NSString *query = [NSString stringWithFormat: @"lattlong=%f,%f", lat, lon];
    [self fetchLocationsWithQuery: query];
}

-(void)fetchLocationsByName: (NSString *)name
{
    if (![self.arrSearchHistories containsObject: name])
    {
        [self.arrSearchHistories addObject: name];
    }
    
    name = [name stringByReplacingOccurrencesOfString: @" "
                                           withString: @"%20"];

    NSString *query = [NSString stringWithFormat: @"query=%@", name];
    [self fetchLocationsWithQuery: query];
}


// MARK: - #

-(NSInteger)numberOfLocations
{
    if (self.isSearching)
    {
        return self.arrSearchHistories.count;
    }
    
    return self.arrLocations.count;
}

-(NSString *)locationNameAtIndex: (NSInteger)index
{
    if (self.isSearching)
    {
        return self.arrSearchHistories[index];
    }
    
    DMLocation *loc = [self locationAtIndex: index];
    return loc.title;
}

-(NSString *)locationIDAtIndex: (NSInteger)index
{
    if (self.isSearching)
    {
        return nil;
    }
    
    DMLocation *loc = [self locationAtIndex: index];
    return [NSString stringWithFormat: @"%ld", (long)loc.woeid];
}

-(NSString *)locationTypeAtIndex: (NSInteger)index
{
    if (self.isSearching)
    {
        return nil;
    }
    
    DMLocation *loc = [self locationAtIndex: index];
    return loc.locationType;
}

@end
