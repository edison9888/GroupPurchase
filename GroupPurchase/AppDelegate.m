//
//  AppDelegate.m
//  GroupPurchase
//
//  Created by xcode on 13-1-4.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "AppDelegate.h"
#import "GPController.h"
#import "UserLoginController.h"
#import "MBProgressHUD.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self checkNetworkReachability];
    [self customizeAppearance];
    
    _keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserAccount" accessGroup:nil];
    _userInfo = [[UserInfo alloc] init];
    
    GroupPurchaseController *gpc = nil;
    NearbyController        *nc  = nil;
    OrdersController        *oc  = nil;
    MoreViewController      *mc  = nil;
    
    gpc = [[GroupPurchaseController alloc] initWithNibName:@"GroupPurchaseController" bundle:nil];
    nc  = [[NearbyController alloc] initWithNibName:@"NearbyController" bundle:nil];
    oc  = [[OrdersController alloc] initWithNibName:@"OrdersController" bundle:nil];
    mc  = [[MoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *nav1, *nav2, *nav3, *nav4;
    nav1 = [[UINavigationController alloc] initWithRootViewController:gpc];
    nav2 = [[UINavigationController alloc] initWithRootViewController:nc];
    nav3 = [[UINavigationController alloc] initWithRootViewController:oc];
    nav4 = [[UINavigationController alloc] initWithRootViewController:mc];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[nav1,nav2,nav3,nav4];
    tabBarController.tabBar.selectedImageTintColor = [UIColor orangeColor];
    tabBarController.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor yellowColor];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

    //18984325559 密码18984325559
    
    return YES;
}


#pragma mark- UITabbarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nc = (UINavigationController *)viewController;
    
    // 如果用户切换到"订单“栏目,那么需要检测用户是否登陆，如果没登陆就弹出登陆界面.
    if([nc.topViewController isKindOfClass:[OrdersController class]] ||
       [nc.topViewController isKindOfClass:[UserLoginController class]])
    {
        NSString *userName = [self.keychain objectForKey:(__bridge id)(kSecAttrAccount)];
        if([userName isEqualToString:@""] || [userName isEqual:nil])
        {
            UserLoginController *ulc = [[UserLoginController alloc] initWithNibName:@"UserLoginController" bundle:nil];
            ulc.fromMyOrderListController = YES;
            [nc pushViewController:ulc animated:NO];
        }else{
            [nc popToRootViewControllerAnimated:NO];
        }
    }
}

+ (AppDelegate *)appDelegateInstance
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)checkNetworkReachability
{
    _reach = [Reachability reachabilityWithHostname: @"www.baidu.com"];
    _reach.unreachableBlock = ^(Reachability *reach){};
    [_reach startNotifier];
}

- (void)customizeAppearance
{
    UIImage *navBarBackground  = [UIImage imageNamed:@"nav_bar_bg"];
    [[UINavigationBar appearance] setBackgroundImage:navBarBackground forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"nav_back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 15, 4, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                      forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *tabBarBackground      = [UIImage imageNamed:@"tab_bar_bg"];
    UIImage *tabBarSelectIndicator = [UIImage imageNamed:@"tab_bar_select_indicator"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:tabBarSelectIndicator];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

@end
