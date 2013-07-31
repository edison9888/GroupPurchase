//
//  CityListController.m
//  GroupPurchase
//
//  Created by xcode on 13-1-31.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "CityListController.h"

extern NSString *const LocationCompletedNotification;

NSString *const SwitchCityNotification = @"SwitchCityNotification";

@interface CityListController ()
@property (strong,nonatomic) NSDictionary    *cities;
@property (strong,nonatomic) NSMutableArray  *cityKeys;
@property (copy,  nonatomic) NSArray         *currentLocationCityInfo;

@property (weak,  nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CityListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
         self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLocationCompletedNotification:)
                                                 name:LocationCompletedNotification object:nil];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
    self.cities    = [NSDictionary dictionaryWithContentsOfFile:path];
    self.cityKeys  = (NSMutableArray *)[self.cities allKeys];
    self.cityKeys  = (NSMutableArray *)[self.cityKeys sortedArrayUsingSelector:@selector(compare:)];
    
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tableView)
        return self.cityKeys.count;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    
    if(tableView == self.tableView)
    {
        NSString *key = [self.cityKeys objectAtIndex:section];
        NSArray *cities = [self.cities objectForKey:key];
        return cities.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView)
    {
        static NSString *cellIdentifier = @"NormalCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        
        NSString *key = [self.cityKeys objectAtIndex:indexPath.section];
        NSArray *cities = [self.cities objectForKey:key];
        
        NSString *cityName = nil;
        if(indexPath.section == 0)
        {
            cityName = self.currentLocationCityInfo[0];
        }
        else
        {
            NSDictionary *cityEntity = [cities objectAtIndex:indexPath.row];
            cityName = [cityEntity objectForKey:@"CityName"];
        }
        
        cell.textLabel.text = cityName;
        return cell;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"定位城市";
    }
  
    return [self.cityKeys objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.cityKeys;
}


#pragma mark -
#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *userInfo = nil;
    
    if(indexPath.section != 0)
    {
        NSString *key = self.cityKeys[indexPath.section];
        NSArray *cities = self.cities[key];
        NSDictionary *city = cities[indexPath.row];
        userInfo = @[city[@"CityName"],city[@"CityID"]];
    }
    else
    {
        userInfo = self.currentLocationCityInfo;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SwitchCityNotification object:nil userInfo:@{@"key":userInfo}];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - 处理通知

- (void)handleLocationCompletedNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    self.currentLocationCityInfo =  userInfo[@"key"];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - UISearchBarDelegate


#pragma mark -
#pragma mark - Search Cities Method

- (NSArray *)searchCityWithKeyWord:(NSString *)keyWord
{
    return nil;
}

@end
