//
//  WeatherTableViewCell.m
//  Weather
//
//  Created by Jian on 6/16/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "WeatherTableViewCell.h"
#import "UIImageView+NWHttps.h"



@interface WeatherTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end



@implementation WeatherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDate: (NSString *)date
{
    self.dateLabel.text = date;
}

-(void)setWeatherIcon: (NSURL *)url
{
    [self.weatherImageView setImageURL: url
                       withPlaceholder: [UIImage imageNamed: @"weather"]];
}

-(void)setTemperatureRanges: (NSString *)temp
{
    self.tempLabel.text = temp;
}

@end
