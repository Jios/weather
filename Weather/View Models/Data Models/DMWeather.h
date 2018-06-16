//
//  DMWeather.h
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DMWeather : NSObject

@property (nonatomic, readonly) NSString *stateName;
@property (nonatomic, readonly) NSString *stateAbbr;
@property (nonatomic, readonly) NSString *dateString;

@property (nonatomic, readonly) float minTemp;
@property (nonatomic, readonly) float maxTemp;
@property (nonatomic, readonly) float windSpeed;
@property (nonatomic, readonly) float windDirection;

@property (nonatomic, readonly) NSInteger humidity;
@property (nonatomic, readonly) float visibility;
@property (nonatomic, readonly) NSInteger predictability;


+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict;


@end
