//
//  WeatherViewController.m
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherViewModel.h"
#import "WeatherTableViewCell.h"
#import "UIImageView+NWHttps.h"



static NSString * const kWeatherCellID = @"weatherCell";



@interface WeatherViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *othersLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) WeatherViewModel *weatherVM;

@end



@implementation WeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    
    [self.weatherVM fetchByWOEID: self.woeid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
}


// MARK: - # getter

-(WeatherViewModel *)weatherVM
{
    if (!_weatherVM)
    {
        weakify(self);
        _weatherVM = [[WeatherViewModel alloc] initWithUpdateBlock: ^{
            
            strongify(self);
            [self updateWeathers];
        }
                                                        errorBlock: ^(NSError * _Nonnull error) {
                                                            // TODO: handle error
                                                        }];
    }
    
    return _weatherVM;
}

-(void)updateWeathers
{
    self.navigationItem.title = self.weatherVM.locationName;
    
    [self.weatherIcon setImageURL: [self.weatherVM weatherIcon]
                  withPlaceholder: [UIImage imageNamed: @"weather"]];
    self.tempLabel.text = [self.weatherVM tempAtIndex: 0];
    self.othersLabel.text = [self.weatherVM othersAtIndex: 0];
    
    [self.tableView reloadData];
}


// MARK: - # UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return self.weatherVM.numberOfForecasts-1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherTableViewCell *cell = (WeatherTableViewCell *)[tableView dequeueReusableCellWithIdentifier: kWeatherCellID
                                                                                         forIndexPath: indexPath];
    
    NSInteger index = indexPath.row + 1;

    [cell setDate: [self.weatherVM dateAtIndex: index]];
    [cell setWeatherIcon: [self.weatherVM forecastIconAtIndex: index]];
    [cell setTemperatureRanges: [self.weatherVM tempAtIndex: index]];
    
    return cell;
}


// MARK: - # UITableViewDataSource

-(void)         tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath
                             animated: YES];
}


@end
