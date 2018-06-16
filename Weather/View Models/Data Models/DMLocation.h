//
//  DMLocation.h
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, LocationType)
{
    locNone,
    locCity,
    locRegion,
    locState,
    locProvince,
    locCountry,
    locContinent
};



@interface DMLocation : NSObject

@property (nonatomic, readonly) NSInteger woeid;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) LocationType type;
@property (nonatomic, readonly) float lat;
@property (nonatomic, readonly) float lon;
@property (nonatomic, readonly) NSString *locationType;


+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict;

@end
