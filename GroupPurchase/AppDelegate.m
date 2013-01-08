//
//  AppDelegate.m
//  GroupPurchase
//
//  Created by xcode on 13-1-4.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "AppDelegate.h"

#define AnimationInterval (5)      // MTStatusBarOverlay的动画时间

@implementation AppDelegate

// 检测设备是否能连接上服务器
- (void)checkNetworkReachability
{
    _reach = [Reachability reachabilityWithHostname: @"www.qq.com"];
    _reach.unreachableBlock = ^(Reachability *reach){
        
        /* 当网络连接状态发生改变时Block将在后台线程被调用，所以我们必须在主线程更新UI.
         * Reachability 参考:https://github.com/tonymillion/Reachability
         * MTStatusBarOverlay 参考:https://github.com/myell0w/MTStatusBarOverlay */
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MTStatusBarOverlay *statusBarOverlay = [MTStatusBarOverlay sharedInstance];
            [statusBarOverlay postErrorMessage:@"亲，网络连接断开了，请连接到网络." duration:AnimationInterval animated:YES];
        });
    };
    
    _reach.reachableBlock = ^(Reachability *reach){
        dispatch_async(dispatch_get_main_queue(), ^{
            MTStatusBarOverlay *statusBarOverlay = [MTStatusBarOverlay sharedInstance];
            [statusBarOverlay postFinishMessage:@"设备已连接上网络，祝您购物愉快!" duration:AnimationInterval animated:YES];
        });
    };
    
    [_reach startNotifier];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
     
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self checkNetworkReachability];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
