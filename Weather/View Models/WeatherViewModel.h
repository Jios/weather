//
//  WeatherViewModel.h
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks.h"
#import "SelfMacros.h"
#import "Dispatch.h"



@interface WeatherViewModel : NSObject

-(instancetype _Nonnull)initWithUpdateBlock: (VoidBlock _Nonnull)updateBlock
                                 errorBlock: (ErrorBlock _Nonnull)errorBlock;

-(void)fetchByWOEID: (NSString *)woeid;

-(NSString *)locationName;
-(NSURL *)weatherIcon;

-(NSInteger)numberOfForecasts;
-(NSString *)forecastStateAtIndex: (NSInteger)index;
-(NSURL *)forecastIconAtIndex: (NSInteger)index;
-(NSString *)tempAtIndex: (NSInteger)index;
-(NSString *)dateAtIndex: (NSInteger)index;
-(NSString *)othersAtIndex: (NSInteger)index;

@end
