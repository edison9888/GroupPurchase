//
//  MyOrder.h
//  GroupPurchase
//
//  Created by xcode on 13-3-14.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPWSAPI.h" // For PaymentStatus

// 我的订单
@interface MyOrder : NSObject

@property(nonatomic,   copy) NSString       *orderNumber;         // 订单ID
@property(nonatomic, assign) NSInteger      prodcutID;            // 商品ID
@property(nonatomic,   copy) NSString       *productName;         // 产品名称
@property(nonatomic, assign) NSInteger      productCount;         // 产品数量
@property(nonatomic, assign) CGFloat        productCostPrice;     // 产品原价
@property(nonatomic, assign) CGFloat        productVIPPrice;      // 产品会员价
@property(nonatomic, assign) CGFloat        productNotVipPrice;   // 非会员价
@property(nonatomic,   copy) NSString       *outDate;             // 过期日期
@property(nonatomic,   copy) NSString       *titleImageUrl;       // 标题图片URL
@property(nonatomic, assign) PaymentStatus  payState;             // 退款状态
@property(nonatomic, copy)    NSString      *verCode;             // 消费验证码
@property(nonatomic, assign) NSUInteger     infoID;               // 用于获取商户信息

+ (MyOrder *)myOrderWitchDictionary:(NSDictionary *)dic;

@end
