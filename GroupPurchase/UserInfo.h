//
//  UserInfo.h
//  GroupPurchase
//
//  Created by xcode on 13-3-5.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserHasLoginedInfo.h"
#import "Coupon.h"

@interface UserInfo : NSObject
@property(nonatomic, copy)      NSString           *bindPhone;       // 绑定电话
@property(nonatomic, strong)    NSArray            *shippingAdress;  // 送货地址集合(ShippingAddress对象的集合)
@property(nonatomic, strong)    UserHasLoginedInfo *userLoginedInfo; // 已登陆用户信息(账户余额,积分)
@property(nonatomic, strong)    NSArray            *myCoupons;       // 我的优惠卷(Coupons对象集合)
@end
