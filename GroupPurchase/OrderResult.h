//
//  OrderResult.h
//  GroupPurchase
//
//  Created by xcode on 13-3-26.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderResult : NSObject

@property(nonatomic, copy) NSString *orderNumber;   // 订单号
@property(nonatomic, copy) NSString *orderDate;     // 获取此属性值时需要YYMMDDHHMMSS格式
@property(nonatomic, copy) NSString *outDate;       // 过去时间
@property(nonatomic, copy) NSString *price;         // 价格为12位字符串，单位为分. 如:000000000001代表2分钱
@property(nonatomic, copy) NSString *desc;          // 描述

+ (OrderResult *)orderResultWithDictonary:(NSDictionary *)dic;

@end
