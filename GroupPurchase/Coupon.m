//
//  Coupon.m
//  GroupPurchase
//
//  Created by xcode on 13-3-6.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "Coupon.h"
#import "NSObject+EntityHelper.h"

@implementation Coupon

+ (Coupon *)couponWithDictionary:(NSDictionary *)dic
{
    Coupon *coupon = [[Coupon alloc] init];
    
    coupon.couponID      = [coupon intWithKey:@"Coupon_ID" dictory:dic];
    coupon.couponNum     = [coupon strWithKey:@"Coupon_Num" dictory:dic];
    coupon.couponState   = [coupon intWithKey:@"Coupon_State" dictory:dic];
    coupon.couponValue   = [coupon floatWithKey:@"Coupon_Vaule" dictory:dic];
    coupon.effectiveDate = [coupon strWithKey:@"Coupon_StartTimeStr" dictory:dic];
    coupon.invalidDate   = [coupon strWithKey:@"Validation_DateStr" dictory:dic];
    
    return coupon;
}

@end
