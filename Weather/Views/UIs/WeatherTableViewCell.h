//
//  WeatherTableViewCell.h
//  Weather
//
//  Created by Jian on 6/16/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface WeatherTableViewCell : UITableViewCell

-(void)setDate: (NSString *)date;
-(void)setWeatherIcon: (NSURL *)url;
-(void)setTemperatureRanges: (NSString *)temp;

@end
