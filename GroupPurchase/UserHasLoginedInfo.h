//
//  UserHasLoginedInfo.h
//  GroupPurchase
//
//  Created by xcode on 13-3-6.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHasLoginedInfo : NSObject
@property (nonatomic, assign)  CGFloat  accountBalance;  // 余额
@property (nonatomic, assign)  CGFloat  accountIntegral; // 积分
@property (nonatomic, copy)    NSString *contactName;

+(UserHasLoginedInfo *)userHasLoginedInfoWithDictionary:(NSDictionary *)dic;

@end
