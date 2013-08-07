//
//  GroupPurchaseController.m
//  GroupPurchase
//
//  Created by xcode on 13-1-10.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "GroupPurchaseController.h"
#import "LHModalController.h"
#import "CityListController.h"
#import "SearchProductController.h"
#import "OrderWapper.h"
#import "NetErrorViewController.h"
#import "AppDelegate.h"
#import "WelcomeViewController.h"

extern NSString *const SwitchCityNotification;
extern NSString *const PullUpRefreshNotification;
extern NSString *const LoadMoreProductsNotification;

// 定位完成通知
NSString  * const LocationCompletedNotification = @"LocationCompletedNotification";

static const NSUInteger pageSize = 50;

@implementation GroupPurchaseController
{
    NSUInteger             _pageIndex;
    UIButton               *_cityNameButton;
    ProductListView        *_productListView;
    ProductType            _productType;
    SortType               _sortType;
    NSUInteger             _cityID;
    CLLocationCoordinate2D _coordinate;
    BOOL                   _isRefreshProductList;
    CLLocationManager      *_locationManager;
    NSArray                *_curretnLocationCityInfo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tabBarItem.title = @"团购";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_bar_tuan_gou"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL aBool = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLauchApp"];
    if(aBool == NO){
        WelcomeViewController *wvc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        [AppDel.window.rootViewController presentViewController:wvc animated:NO completion:^{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLauchApp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWork];
}

- (void)initWork
{

    _pageIndex = 0;
    _productType = ProductTypeToday;
    _sortType = SortTypeRecommand;
    _isRefreshProductList = NO;
    
    // 118114团LOGO
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,80,LH_NAVIGATION_BAR_HEIGHT-24)];
    logoView.image = [UIImage imageNamed:@"logo118114"];
    
    // 显示城市名字的Button
    _cityNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityNameButton.backgroundColor = [UIColor clearColor];
    _cityNameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _cityNameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _cityNameButton.frame = CGRectMake(0, 0, LH_NAVIGATION_BAR_HEIGHT*2, LH_NAVIGATION_BAR_HEIGHT);
    [_cityNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cityNameButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [_cityNameButton addTarget:self action:@selector(showCityListController) forControlEvents:UIControlEventTouchUpInside];
    
    // 搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0,0,50,35);
    [searchButton setImage:[UIImage imageNamed:@"nav_bar_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(showSearchProductController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoViewItem, *cityButtonItem, *searchButtonItem;
    logoViewItem     = [[UIBarButtonItem alloc] initWithCustomView:logoView];
    cityButtonItem   = [[UIBarButtonItem alloc] initWithCustomView:_cityNameButton];
    searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.leftBarButtonItems = @[logoViewItem,cityButtonItem];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    ProductTypeBar *bar = [[ProductTypeBar alloc] initWithFrame:CGRectMake(0, 0, LH_SCREEN_WIDTH, 50)];
    bar.delegate = self;
    [self.view addSubview:bar];
    
    // 产品列表视图
    CGRect frame = CGRectMake(0,PRODUCT_TYPE_BAR_ITEM_HEI, LH_SCREEN_WIDTH,
                              LH_SCREEN_HEIGHT-LH_STATUS_BAR_HEIGHT-LH_NAVIGATION_BAR_HEIGHT-PRODUCT_TYPE_BAR_ITEM_HEI-LH_TAB_BAR_HEIGHT);
    _productListView = [[ProductListView alloc] initWithFrame:frame];
    _productListView.controllerType = ControllerTypeGP;
    _productListView.loadMoreProductItemDelegate = self;
    _productListView.allowPullToRefresh = YES;
    _productListView.navigationController = self.navigationController;
    [self.view addSubview:_productListView];
    
    if([CLLocationManager locationServicesEnabled])
    {
        showHudWith(self.view, @"正在定位", YES, NO);
        
        // 开始定位
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 5000;     
        [_locationManager startUpdatingLocation];
    }else{
        [self loadProductListWithCityID:_cityID ProductType:_productType SortType:_sortType lon:0 lat:0];
        Alert(@"您禁用了定位服务，我们将使用您的位置信息来给您提供商品信息，请在设置->隐私->定位服务中开启");
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelSwitchCityNotification:)
                                                 name:SwitchCityNotification object:nil];
}

// 加载产品列表
- (void)loadProductListWithCityID:(NSUInteger)cityID ProductType:(ProductType)pType SortType:(SortType)sType lon:(CGFloat)lon lat:(CGFloat)lat
{
    [OrderWapper shareInstance].cityID = INT_TO_STR(cityID);
    
   // showHudWith(self.view, @"正在载入商品", YES, NO);
    
    [GPWSAPI getProductListWithCityID:cityID typeID:pType keyWord:nil lon:lon lat:lat distance:0
                             sortType:sType pageSize:pageSize pageIndex:_pageIndex
                              success:^(NSMutableArray *productEntities)
    {
        if(_productListView.isLoading)
        {
            _productListView.moreProduct = productEntities;

            if(productEntities.count == 0){
                showHudWith(self.view, @"已全部加载", NO, YES);
            }
        }
        else{
            _productListView.productList = productEntities;

            if(productEntities.count == 0){
                showHudWith(self.view, @"暂无产品信息", NO, YES);
            }else{
                removeHudFromView(self.view)
            }
        }
       
    } faile:^(ErrorType errorType)
    {
     
        if(_productListView.isLoading)
            _productListView.moreProduct = [NSMutableArray new];
        
        if([AppDelegate appDelegateInstance].reach.isReachable == NO)
        {
            removeHudFromView(self.view);
            Alert(@"不能连接到服务器，请连接到网络。");
        }else{
              showHudWith(self.view, @"获取失败,服务器发生错误", NO, YES);
        }
    }];
}

// 显示城市列表
- (void)showCityListController
{
    CityListController *clc = [[CityListController alloc] initWithNibName:@"CityListController" bundle:nil];
    [self.navigationController pushViewController:clc animated:YES];
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        // 此通知由CityListController处理
        NSDictionary *userInfo = @{@"key":_curretnLocationCityInfo};
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationCompletedNotification object:nil userInfo:userInfo];
    });
}

// 显示搜索控制器
- (void)showSearchProductController
{
    SearchProductController *spc = [[SearchProductController alloc] initWithNibName:@"SearchProductController" bundle:nil];
    [self.navigationController pushViewController:spc animated:YES];
}

#pragma mark - ProductTypeBarDelegate,ProductSortTypeViewDelegate

// 在“今日团购”和“特惠团购”间切换
- (void)didSelectProductTypeBarAtIndex:(NSUInteger)aIndex
{
    if(aIndex == 3)
    {
        // 这里进行--aIndex操作是因为aIndex在给代理之前来进行+1操作
        CGRect frame = CGRectMake((--aIndex)*PRODUCT_TYPE_BAR_ITEM_LEN, LH_NAVIGATION_BAR_HEIGHT+PRODUCT_TYPE_BAR_ITEM_HEI, 0, 0);
        ProductSortTypeView *pstv = [ProductSortTypeView sharedWithFrame:frame];
        pstv.delegate = self;
        [LHModalController showModalView:pstv];
        return;
    }
    
    if(_productType == aIndex)
    {
        return;
    }
    
    _pageIndex = 0;
    _productType = aIndex;
    [self loadProductListWithCityID:_cityID ProductType:_productType SortType:_sortType lon:_coordinate.longitude lat:_coordinate.latitude];
}

// 排序产品列表
- (void)didSelectProductSortTypeViewAtIndex:(NSInteger)aIndex
{
    [LHModalController dismisModalView];
    
    if(_sortType == aIndex)
    {
        return;
    }
    
    _pageIndex = 0;
    _sortType = aIndex;
    [self loadProductListWithCityID:_cityID ProductType:_productType SortType:_sortType lon:_coordinate.longitude lat:_coordinate.latitude];
}


#pragma mark - 处理通知

- (void)loadMoreProduct
{
    _productListView.isLoading = YES;
    
    ++_pageIndex;
    dispatch_async(dispatch_get_global_queue(0, 0), ^
   {
       [self loadProductListWithCityID:_cityID ProductType:_productType SortType:_sortType lon:_coordinate.longitude lat:_coordinate.longitude];
   });
}

- (void)handelSwitchCityNotification:(NSNotification *)notification
{
    NSArray *userInfo = notification.userInfo[@"key"];
    NSString *cityName = userInfo[0];
    NSNumber *cityID   = userInfo[1];
    _cityID = cityID.integerValue;
    
    [_cityNameButton setTitle:[NSString stringWithFormat:@"[%@]",cityName] forState:UIControlStateNormal];
    [self loadProductListWithCityID:cityID.integerValue ProductType:_productType SortType:_sortType lon:0 lat:0];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    CLLocationDegrees lat = newLocation.coordinate.latitude;
    CLLocationDegrees lon = newLocation.coordinate.longitude;
    
    #define AreaCode @"areaCode"
    #define CityCode @"cityCode"
    
    // 设置区域代码用于用户登陆时传递给服务器
    // 青海省西宁市的经纬度范围
    if(lat >= 36.531709 && lat <= 36.734482 && lon >= 101.567016 && lon <= 102.000976)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"630000" forKey:AreaCode];
        [[NSUserDefaults standardUserDefaults] setObject:@"434" forKey:CityCode];
        
        // 重庆市经纬度范围
    }if(lat >= 29.354649 && lat <= 29.624803 && lon >= 106.435332 && lon <= 106.664672){
        [[NSUserDefaults standardUserDefaults] setObject:@"510000" forKey:AreaCode];
        [[NSUserDefaults standardUserDefaults] setObject:@"13" forKey:CityCode];

        // 广东省经纬度范围
    }if(lat >= 22.634293 && lat <= 23.342256 && lon >=112.761955 && lon <= 113.520012){
        [[NSUserDefaults standardUserDefaults] setObject:@"440000" forKey:AreaCode];
        [[NSUserDefaults standardUserDefaults] setObject:@"281" forKey:CityCode];
    }else{
        // 其余地区areaCode为null
        [[NSUserDefaults standardUserDefaults] setObject:@"null" forKey:AreaCode];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:CityCode];
    }
    
    
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
            // CLPlacemark中相应属性对应的街道地址
            // name                         thoroughfare subThoroughfare locality subLocality
            // 中国贵州省贵阳市云岩区北京路114号 北京路        114号           贵阳市     云岩区
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            cityName = placemark.locality;
            
            // 查找对应城市的ID
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
            
            // 如果没有找到对应城市的ID,默认获取贵阳市的城市ID
            if(!cityID) cityID = [NSNumber numberWithInteger:1];
            
        } // 结束:if(placemarks.count > 0 && !error)
        else
        {
            cityID = [NSNumber numberWithInteger:1];
        }
       
        
        cityName = cityName ? cityName : @"贵阳";
        _cityID = cityID.integerValue;
        _curretnLocationCityInfo = @[cityName, cityID];
        [_cityNameButton setTitle:[NSString stringWithFormat:@"[%@]",cityName] forState:UIControlStateNormal];
        
        [self loadProductListWithCityID:_cityID ProductType:_productType SortType:_sortType lon:0 lat:0];
    }];
}

// 用户不允许使用位置信息
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
        
    removeHudFromView(self.view);
    
    if([error code] == kCLErrorDenied)
    {
        Alert(@"我们将使用您的位置信息来给您提供商品信息，请在设置->隐私->定位服务中开启");
    }
    
    [self loadProductListWithCityID:_cityID ProductType:_productType SortType:_sortType lon:0 lat:0];
}

@end


NSString *cutSuffixOfCityName(NSString *cityName)
{
    NSString *lastWord, *lastTwoWord, *lastThreeWord;
    NSInteger len = cityName.length;
    
    if(len > 1) lastWord      = [cityName substringFromIndex:len - 1];
    if(len > 2) lastTwoWord   = [cityName substringFromIndex:len - 2];
    if(len > 3) lastThreeWord = [cityName substringFromIndex:len - 3];
    
    NSString *newCityName = nil;
    if(len > 3 && [lastThreeWord isEqualToString:@"自治州"])
    {
        newCityName = [cityName substringToIndex:len - 3];
    }
    else if(len > 2 && [lastTwoWord isEqualToString:@"地区"])
    {
        newCityName = [cityName substringToIndex:len - 2];
    }
    else if(len > 1 && ([lastWord isEqualToString:@"市"] || [lastWord isEqualToString:@"区"] || [lastWord isEqualToString:@"县"]))
    {
        newCityName = [cityName substringToIndex:len - 1];
    }
    
    return newCityName ? newCityName : cityName;
}

