//
//  WeatherViewModel.m
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "WeatherViewModel.h"
#import "DMLocation.h"
#import "DMWeather.h"
#import "NWHttps.h"
#import "Keys.h"



static NSString * const kWeatherAPI = @"https://www.metaweather.com/api/location";
static NSString * const kWeatherIconAPI = @"https://www.metaweather.com/static/img/weather/png";


@interface WeatherViewModel ()

@property (nonatomic, strong) DMLocation *location;
@property (nonatomic, strong) NSMutableArray <DMWeather *> *arrWeathers;

@property (nonatomic, copy) VoidBlock updateBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;

@end



@implementation WeatherViewModel

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

-(void)updateWeathersWithArray: (NSArray *)arr
{
    [Dispatch dispatchAsyncToGlobalQueue: ^{
        
        for (NSDictionary *dict in arr)
        {
            DMWeather *weather = [DMWeather parseDictionary: dict];
            [self.arrWeathers addObject: weather];
        }
    }
                        asyncToMainQueue: ^{
                            
                            self.updateBlock();
                        }];
}


// MARK: - # getter

-(NSMutableArray<DMWeather *> *)arrWeathers
{
    if (!_arrWeathers)
    {
        _arrWeathers = [NSMutableArray new];
    }
    
    return _arrWeathers;
}


// MARK: - # fetch

-(void)fetchByWOEID: (NSString *)woeid
{
    NSString *urlString = [NSString stringWithFormat: @"%@/%@/", kWeatherAPI, woeid];
    NSURL    *url       = [NSURL URLWithString: urlString];
    
    weakify(self);
    [NWHttps getURL: url
      responseBlock: ^(NSDictionary * _Nonnull dictionary) {
          
          strongify(self);
          self.location = [DMLocation parseDictionary: dictionary];
          [self updateWeathersWithArray: dictionary[kWeathers]];
      }
         errorBlock: self.errorBlock];
}

-(DMWeather *)weatherAtIndex: (NSInteger)index
{
    return self.arrWeathers[index];
}

-(NSString *)locationName
{
    return self.location.title;
}

-(NSURL *)weatherIcon
{
    DMWeather *weather = [self weatherAtIndex: 0];
    NSString *urlString = [NSString stringWithFormat: @"%@/%@.png", kWeatherIconAPI, weather.stateAbbr];
    return [NSURL URLWithString: urlString];
}

-(NSInteger)numberOfForecasts
{
    return self.arrWeathers.count;
}

-(NSString *)forecastStateAtIndex: (NSInteger)index
{
    DMWeather *weather = [self weatherAtIndex: index];
    
    return weather.stateName;
}

-(NSURL *)forecastIconAtIndex: (NSInteger)index
{
    DMWeather *weather = [self weatherAtIndex: index];
    NSString *urlString = [NSString stringWithFormat: @"%@/64/%@.png", kWeatherIconAPI, weather.stateAbbr];
    return [NSURL URLWithString: urlString];
}

-(NSString *)tempAtIndex: (NSInteger)index
{
    DMWeather *weather = [self weatherAtIndex: index];
    return [NSString stringWithFormat: @"%0.0fC to %0.0fC", weather.minTemp, weather.maxTemp];
}

-(NSString *)dateAtIndex: (NSInteger)index
{
    DMWeather *weather = [self weatherAtIndex: index];
    return weather.dateString;
}

-(NSString *)othersAtIndex: (NSInteger)index
{
    DMWeather *weather = [self weatherAtIndex: index];
    return [NSString stringWithFormat: @"Humidity: %ld%%, Visibility: %0.2f, Predictability: %ld%%", weather.humidity, weather.visibility, weather.predictability];
}



@end
