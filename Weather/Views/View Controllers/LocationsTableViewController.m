//
//  LocationsTableViewController.m
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "LocationsTableViewController.h"
#import "LocationViewModel.h"
#import "WeatherViewController.h"



static NSString * const kLocationCellID = @"locationTableViewCell";



@interface LocationsTableViewController ()
<
    UISearchBarDelegate,
    UISearchControllerDelegate
>

@property (nonatomic, strong) LocationViewModel *locationVM;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end



@implementation LocationsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Locations";
    
    [self setupTableView];
    
    [self updateTableViewWithAnimation: YES];
    [self.locationVM requestDeviceLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTableView
{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    self.tableView.backgroundView  = self.activityIndicatorView;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
}


// MARK: - # update

-(void)updateTableViewWithAnimation: (BOOL)animated
{
    self.searchController.active = NO;
    self.locationVM.isSearching = NO;
    
    if (animated)
    {
        [self.activityIndicatorView startAnimating];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        [self.activityIndicatorView stopAnimating];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}


// MARK: - # getter

-(LocationViewModel *)locationVM
{
    if (!_locationVM)
    {
        weakify(self);
        _locationVM = [[LocationViewModel alloc] initWithUpdateBlock: ^{
            
            strongify(self);
            [self updateTableViewWithAnimation: NO];
            [self.tableView reloadData];
        }
                                                        errorBlock: ^(NSError * _Nonnull error) {
                                                            // TODO: handle error
                                                            
                                                            strongify(self);
                                                            [self updateTableViewWithAnimation: NO];
                                                        }];
    }
    
    return _locationVM;
}

-(UISearchController *)searchController
{
    if (!_searchController)
    {
        _searchController = [[UISearchController alloc] initWithSearchResultsController: nil];
        _searchController.searchBar.delegate                   = self;
        _searchController.delegate                             = self;
        _searchController.searchBar.placeholder                = @"Search Location";
        _searchController.obscuresBackgroundDuringPresentation = NO;
    }
    
    return _searchController;
}


// MARK: - # fetch

-(void)searchLocation: (NSString *)location
{
    [self.locationVM fetchLocationsByName: location];
}


// MARK: - # UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0)
    {
        return;
    }
    
    [self searchLocation: searchBar.text];
}


// MARK: - # UISearchControllerDelegate

-(void)willPresentSearchController:(UISearchController *)searchController
{
    self.locationVM.isSearching = YES;
    [self.tableView reloadData];
}

-(void)willDismissSearchController:(UISearchController *)searchController
{
    self.locationVM.isSearching = NO;
    [self.tableView reloadData];
}


// MARK: - # Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.locationVM.numberOfLocations;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kLocationCellID
                                                            forIndexPath: indexPath];
    
    NSInteger index = indexPath.row;
    NSString *locID = [self.locationVM locationIDAtIndex: index];
    NSString *locType = [self.locationVM locationTypeAtIndex: index];
    
    cell.textLabel.text = [self.locationVM locationNameAtIndex: index];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@, %@", locID, locType];
    
    if (self.locationVM.isSearching)
    {
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}


// MARK: - # delegate

-(void)         tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath
                             animated: YES];
    
    if (self.locationVM.isSearching)
    {
        NSString *keyword = [self.locationVM locationNameAtIndex: indexPath.row];
        [self searchLocation: keyword];
        
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main"
                                                         bundle: nil];
    WeatherViewController *weatherVC = [storyboard instantiateViewControllerWithIdentifier: @"weatherViewController"];

    weatherVC.woeid = [self.locationVM locationIDAtIndex: indexPath.row];
    
    [self.navigationController pushViewController: weatherVC
                                         animated: YES];
}



@end
