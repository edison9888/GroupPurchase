//
//  Coupon.h
//  GroupPurchase
//
//  Created by xcode on 13-3-6.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 优惠卷
@interface Coupon : NSObject
@property(nonatomic, assign)  NSInteger couponID;
@property(nonatomic, strong)  NSString  *couponNum;     // 优惠券验证号
@property(nonatomic, assign)  NSInteger couponState;    // 使用状态(1为已经使用0为未使用)
@property(nonatomic, assign)  CGFloat   couponValue;    // 优惠券值
@property(nonatomic, copy)    NSString  *effectiveDate; // 有效日期
@property(nonatomic, copy)    NSString  *invalidDate;   // 无效日期

+ (Coupon *)couponWithDictionary:(NSDictionary *)dic;

@end
