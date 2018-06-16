//
//  DMWeather.m
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "DMWeather.h"
#import "Keys.h"



@interface DMWeather ()

@property (nonatomic, assign) NSInteger weatherID;
@property (nonatomic, strong) NSString *stateName;
@property (nonatomic, strong) NSString *stateAbbr;
@property (nonatomic, strong) NSString *dateString;

@property (nonatomic, assign) float minTemp;
@property (nonatomic, assign) float maxTemp;
@property (nonatomic, assign) float windSpeed;
@property (nonatomic, assign) float windDirection;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, assign) float visibility;
@property (nonatomic, assign) NSInteger predictability;

@end



@implementation DMWeather

+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict
{
    DMWeather *weather = [DMWeather new];
    [weather updateWithDictionary: dict];
    return weather;
}

-(void)updateWithDictionary: (NSDictionary * _Nonnull)dict
{
    self.weatherID      = [dict[kID] integerValue];
    self.stateName      = dict[kWeatherState];
    self.stateAbbr      = dict[kWeatherStateAbbr];
    self.dateString     = dict[kApplicableDate];
    self.minTemp        = [dict[kMinTemp] floatValue];
    self.maxTemp        = [dict[kMaxTemp] floatValue];
    self.windSpeed      = [dict[kWindSpeed] floatValue];
    self.windDirection  = [dict[kWindDirection] floatValue];
    self.humidity       = [dict[kHumidity] integerValue];
    self.visibility     = [dict[kVisibility] floatValue];
    self.predictability = [dict[kPredictability] integerValue];
}


@end
