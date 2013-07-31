//
//  AppDelegate.h
//  GroupPurchase
//
//  Created by xcode on 13-1-4.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "Reachability.h"
#import "KeychainItemWrapper.h"

@class BMKMapManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate,
                                      UITabBarControllerDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(readonly, strong, nonatomic) Reachability *reach;
@property(readonly, strong, nonatomic) KeychainItemWrapper *keychain;
@property(readonly, strong, nonatomic) UserInfo *userInfo;

+ (AppDelegate *)appDelegateInstance;

@end
