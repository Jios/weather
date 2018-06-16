//
//  DMLocation.m
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "DMLocation.h"
#import "Keys.h"



@interface DMLocation ()

@property (nonatomic, assign) NSInteger woeid;  // Where On Earth ID
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *locationType;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lon;
@property (nonatomic, assign) LocationType type;

@end



@implementation DMLocation

+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict
{
    DMLocation *loc = [DMLocation new];
    [loc updateWithDictionary: dict];
    return loc;
}

-(void)updateWithDictionary: (NSDictionary * _Nonnull)dict
{
    self.woeid        = [dict[kWoeid] integerValue];
    self.title        = dict[kTitle];
    self.locationType = dict[kLocationType];
    
    [self parseLattLong: dict[kLattLong]];
    [self parseLocationType: dict[kLocationType]];
}

-(void)parseLattLong: (NSString *)lattLong
{
    NSArray *arrTmp = [lattLong componentsSeparatedByString: @","];
    self.lat = [arrTmp.firstObject floatValue];
    self.lon = [arrTmp.lastObject  floatValue];
}

-(void)parseLocationType: (NSString *)locType
{
    LocationType locationType = locNone;
    
    if ([locType isEqualToString: @"City"])
    {
        locationType = locCity;
    }
    else if ([locType isEqualToString: @"Region"])
    {
        locationType = locRegion;
    }
    else if ([locType isEqualToString: @"State"])
    {
        locationType = locState;
    }
    else if ([locType isEqualToString: @"Province"])
    {
        locationType = locProvince;
    }
    else if ([locType isEqualToString: @"Country"])
    {
        locationType = locCountry;
    }
    else if ([locType isEqualToString: @"Continent"])
    {
        locationType = locContinent;
    }
    
    self.type = locationType;
}

@end
