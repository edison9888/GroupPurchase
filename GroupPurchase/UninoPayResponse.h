//
//  UninoPayResponse.h
//  GroupPurchase
//
//  Created by xcode on 13-3-26.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnionPayResponse : NSObject

@property (nonatomic, copy) NSString *transType;          // 请求类型01:消费,31:消费撤销,04:退货
@property (nonatomic, copy) NSString *merchantId;         // 商户号
@property (nonatomic, copy) NSString *merchantOrderId;    // 订单号
@property (nonatomic, copy) NSString *merchantOrderTime;  // 订单时间
@property (nonatomic, copy) NSString *merchantOrderAmt;   // 金额
@property (nonatomic, copy) NSString *sign;               // 验证码
@property (nonatomic, copy) NSString *merchantPublicCert; // 公钥
@property (nonatomic, copy) NSString *queryReuslt;        // 请求结果
@property (nonatomic, copy) NSString *settleDate;
@property (nonatomic, copy) NSString *setlAmt;
@property (nonatomic, copy) NSString *setlCurrency;
@property (nonatomic, copy) NSString *converRate;
@property (nonatomic, copy) NSString *cupsQid;
@property (nonatomic, copy) NSString *cupsTraceNum;
@property (nonatomic, copy) NSString *cupsTraceTime;
@property (nonatomic, copy) NSString *cupsRespCode;
@property (nonatomic, copy) NSString *cupsRespDesc;
@property (nonatomic, copy) NSString *respCode;         // 执行结果代码 0000为成功
@property (nonatomic, copy) NSString *respDesc;         // 结果描述

+ (UnionPayResponse *)unionPayResponseWithDictionary:(NSDictionary *)dic;

@end
