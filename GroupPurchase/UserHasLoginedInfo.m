//
//  UserHasLoginedInfo.m
//  GroupPurchase
//
//  Created by xcode on 13-3-6.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "UserHasLoginedInfo.h"
#import "NSObject+EntityHelper.h"

@implementation UserHasLoginedInfo
+ (UserHasLoginedInfo *)userHasLoginedInfoWithDictionary:(NSDictionary *)dic
{
    UserHasLoginedInfo *userHasLoginedInfo = [[UserHasLoginedInfo alloc] init];
    
    userHasLoginedInfo.accountBalance  = [userHasLoginedInfo floatWithKey:@"Account_Balance" dictory:dic];
    userHasLoginedInfo.accountIntegral = [userHasLoginedInfo floatWithKey:@"Account_Integral" dictory:dic];
    userHasLoginedInfo.contactName     = [userHasLoginedInfo strWithKey:@"ContactName" dictory:dic];
    
    return userHasLoginedInfo;
}
@end
