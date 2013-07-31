//
//  NearbyController.m
//  GroupPurchase
//
//  Created by xcode on 13-1-10.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "NearbyController.h"
#import "ProductListView.h"
#import "LHModalController.h"
#import "LHHUDView.h"

extern NSString *cutSuffixOfCityName(NSString *);

@interface NearbyController ()
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) ProductListView *productListView;
@property(nonatomic, strong) CLLocation *location;
@property(nonatomic, strong) CLPlacemark *placemark;
@property(nonatomic, assign) NSInteger cityID;
@property(nonatomic, assign) ProductType productType;
@property(nonatomic, assign) NSUInteger  pageIndex;
@end

@implementation NearbyController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"周边商品";
        self.tabBarItem.title = @"周边";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_bar_nearby"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageIndex = 0;
    self.productType = ProductTypeToday;
    
    [NearbyTopBar addNearyTopBarInView:self.view delegate:self];
    
    CGFloat h = LH_SCREEN_HEIGHT - LH_STATUS_BAR_HEIGHT - LH_NAVIGATION_BAR_HEIGHT - NearbyTopBarHeight - LH_TAB_BAR_HEIGHT;
    self.productListView = [[ProductListView alloc] initWithFrame:CGRectMake(0, NearbyTopBarHeight, LH_SCREEN_WIDTH, h)];
    self.productListView.navigationController = self.navigationController;
    self.productListView.loadMoreProductItemDelegate = self;
    self.productListView.allowPullToRefresh = YES;
    [self.view addSubview:self.productListView];
    
    [self startLocation];
}

- (void)startLocation
{
    if([CLLocationManager locationServicesEnabled])
    {
        showHudWith(self.view, @"正在定位", YES, NO);
        
        self.locationManager = nil;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 5000;
        [self.locationManager startUpdatingLocation];
    }else{
        Alert(@"您禁用了定位服务，我们将使用您的位置信息来给您提周边商品信息，请在设置->隐私->定位服务中开启");
    }
}

- (void)didSelectedNearbyTopBarAtIndex:(NSInteger)index
{
    if(index == 1)
    {
        CGRect f = CGRectMake(LH_SCREEN_WIDTH/2, LH_STATUS_BAR_HEIGHT+LH_NAVIGATION_BAR_HEIGHT+10, LH_SCREEN_WIDTH/2, 100);
        [LHModalController showModalView:[NearbyProductTypeBar shareWithFrame:f delegate:self]];
    }else
    {
        self.pageIndex = 0;
        [self startLocation];
    }
}

- (void)loadProduct
{
    showHudWith(self.view, @"正在载入商品", YES, NO);
    [GPWSAPI getProductListWithCityID:self.cityID
                               typeID:self.productType
                              keyWord:nil
                                  lon:self.location.coordinate.longitude
                                  lat:self.location.coordinate.latitude
                             distance:5000
                             sortType:SortTypeNear
                             pageSize:50
                            pageIndex:self.pageIndex
                              success:^(NSMutableArray *productEntities)
                              {
                                  removeHudFromView(self.view);
                                  
                                  if(self.productListView.isLoading)
                                  {
                                      if(productEntities.count == 0)
                                      {
                                          showHudWith(self.view, @"已全部加载", NO, YES);
                                      }
                                      self.productListView.moreProduct = productEntities;
                                  }
                                  else
                                  {
                                      if(productEntities.count == 0)
                                      {
                                          showHudWith(self.view, @"没有商品数据", NO, YES);
                                      }
                                      self.productListView.productList = productEntities;
                                  }
                                  
                              } faile:^(ErrorType errorType)
                              {
                                  showHudWith(self.view, @"获取商品失败", NO, YES);
                              }];
}


- (void)didSelectedNearbyProductTypeBarAtIndex:(NSInteger)index
{
    [LHModalController dismisModalView];
    
    self.pageIndex = 0;
    self.productType = (index == 0 ? ProductTypeToday : ProductTypePreferential);
    [self loadProduct];
}


-(void)loadMoreProduct
{
    self.productListView.isLoading = YES;
    ++(self.pageIndex);
    [self loadProduct];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    manager = nil;
    self.location = newLocation;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSNumber *cityID = nil;
         NSString *cityName = nil;
         NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
         NSDictionary *cities    = [NSDictionary dictionaryWithContentsOfFile:path];
         NSArray      *cityKeys  = [cities allKeys];
         
         if(placemarks.count > 0 && !error)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             cityName = placemark.locality;
             self.placemark = placemark;
             
             for(NSString *key in cityKeys)
             {
                 NSDictionary *array = cities[key];
                 for(NSDictionary *dic in array)
                 {
                     NSString *cName = dic[@"CityName"];
                     NSString *cityName1 = nil, *cityName2 = nil;
                     cityName1 = cutSuffixOfCityName(cityName);
                     cityName2 = cutSuffixOfCityName(cName);
                     
                     if([cityName1 isEqualToString:cityName2])
                     {
                         cityID = dic[@"CityID"];
                         goto GoHereXXXXOOOO;
                     }
                 }
             }
             
            GoHereXXXXOOOO:
             
            if(!cityID) cityID = [NSNumber numberWithInteger:1];
             
         } 
         else
         {
             cityID = [NSNumber numberWithInteger:1];
         }
         
         self.cityID = cityID.integerValue;
         [self loadProduct];
     }];
}

// 用户不允许使用位置信息
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    
    removeHudFromView(self.view);
    
    if([error code] != kCLErrorDenied)
    {
        Alert(@"定位失败");
    }else{   
        Alert(@"我们将使用您的位置信息来给您提供周边商品信息，请在设置->隐私->定位服务中开启");
    }
}

@end
