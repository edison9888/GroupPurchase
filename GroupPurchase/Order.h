//
//  Order.h
//  GroupPurchase
//
//  Created by xcode on 13-3-8.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPWSAPI.h"                // 导入PaymentStatus类型的定义

enum{
    PayTypeZhiFuBao  = 1,     // 支付宝
    PayTypeCaiFuTong = 2,     // 财付通
    PayTypeYinLiang  = 3      // 银联
};
typedef NSInteger PayType;    // 付款类型


// 订单
@interface Order : NSObject

@property(nonatomic, assign)    NSInteger   ID;
@property(nonatomic, copy)      NSString    *address;           // 联系地址
@property(nonatomic, copy)      NSString    *cityID;            // 城市ID
@property(nonatomic, copy)      NSString    *createTime;        // 订购时间
@property(nonatomic, copy)      NSString    *expresCode;        // 快递运单号
@property(nonatomic, copy)      NSString    *expresStype;       // 快递名称
@property(nonatomic, assign)    CGFloat     integral;           // 积分
@property(nonatomic, copy)      NSString    *mobile;            // 用户手机号码(必填)
@property(nonatomic, assign)    CGFloat     money;              // 总价格
@property(nonatomic, assign)    PayType     payType;            // 支付类型
@property(nonatomic, copy)      NSString    *orderNo;           // 订单号
@property(nonatomic, assign)    NSInteger   payStatus;          // 付款状态
@property(nonatomic, copy)      NSString    *payTime;           // 支付时间(必填)
@property(nonatomic, assign)    CGFloat     price;              // 购买价格(必填)
@property(nonatomic, assign)    NSInteger   quantity;           // 数量(必填)
@property(nonatomic, assign)    NSInteger   refund;             // 退款(0默认,1退款处理中,2退款成功,3.拒绝退款)
@property(nonatomic, copy)      NSString    *refundReson;       // 退款原因
@property(nonatomic, copy)      NSString    *smsContent;        // 送货时间备注内容
@property(nonatomic, assign)    NSInteger   *productID;         // 商品ID
@property(nonatomic, copy)      NSString    *tel;               // 联系电话
@property(nonatomic, copy)      NSString    *userID;            // 用户ID
@property(nonatomic, assign)    NSInteger   validationCode;     // 验证码
@property(nonatomic, copy)      NSString    *validationDate;    //
@property(nonatomic, assign)    NSInteger   validationNumber;   // 验证份数,和订购份一样，用于在验证时是否验证完的标志
@property(nonatomic, assign)    NSInteger   vouchers;           // 发货状态（0未发货，1已发货）
@property(nonatomic, copy)      NSString    *vouchersDate;      // 发货操作时间
@property(nonatomic, copy)      NSString    *zipcode;           // 邮政编码
@property(nonatomic, strong)    NSArray     *orderGoods;

+ (Order *)orderWithDictionary:(NSDictionary *)dic;

@end

// Fuck! I don't kown the meaning of this class!
@interface NMB : NSObject

@property(nonatomic, assign)   NSInteger        ID;
@property(nonatomic, assign)   CGFloat          addIntegral;         // 获得积分
@property(nonatomic, assign)   NSInteger        appraiseState;       // 是否评价的状态(1为已经评价,0为未评价)
@property(nonatomic, assign)   CGFloat          deleteIntegral;      // 消耗积分
@property(nonatomic, assign)   CGFloat          money;               // 价格(必填)
@property(nonatomic, assign)   NSInteger        number;              // 购买数量(必填)
@property(nonatomic, copy)     NSString         *orderNumber;        // 订单编号
@property(nonatomic, assign)   PaymentStatus    paymentStatus;       // 订单状态
@property(nonatomic, copy)     NSString         *ordersDate;         // 下单时间
@property(nonatomic, copy)     NSString         *transactionState;   // 交易状态
@property(nonatomic, copy)     NSString         *secCode;            // 验证码
@property(nonatomic, copy)     NSString         *refundReason;       // 拒绝退款原因
@property(nonatomic, assign)   NSInteger        temaID;              // 这个订单属于那个用户
@property(nonatomic, copy)     NSString         *userName;           // 这个订单属于那个用户(必填)

+ (NMB *)nmbWithDictionary:(NSDictionary *)dic;

@end


