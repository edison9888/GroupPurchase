//
//  AppDelegate.h
//  GroupPurchase
//
//  Created by xcode on 13-1-4.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

/* 用于检测是否能连接到服务器.
 * -(BOOL)isReachable;        // 能连接到网络?
 * -(BOOL)isReachableViaWWAN; // 通过3G连接?
 * -(BOOL)isReachableViaWiFi; // 通过WiFi连接?
 * 参考:http://stackoverflow.com/questions/7938650/ios-detect-3g-or-wifi */
@property(readonly, strong, nonatomic) Reachability *reach;

@end
