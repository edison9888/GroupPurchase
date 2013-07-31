//
//  OrderWapper.h
//  GroupPurchase
//
//  Created by xcode on 13-3-25.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 包装订单数据,用于最后提交给服务器 REF:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/15
@interface OrderWapper : NSObject

@property(nonatomic, copy)    NSString *address;       // 收获地址
@property(nonatomic, copy)    NSString *cityID;        // 城市编号
@property(nonatomic, copy)    NSString *phoneNumber;   // 收货人手机号
@property(nonatomic, assign)  CGFloat   unitPrice;     // 单价
@property(nonatomic, assign)  NSInteger payType;       // 支付类型
@property(nonatomic, assign)  CGFloat   totalPrice;    // 总价
@property(nonatomic, assign)  CGFloat   quantity;      // 数量
@property(nonatomic, copy)    NSString  *remark;       // 备注
@property(nonatomic, copy)    NSString  *pID;          // 商品ID
@property(nonatomic, copy)    NSString  *userID;       // 用户ID
@property(nonatomic, copy)    NSString  *recevierName; // 收货人姓名
@property(nonatomic, copy)    NSString  *zipCode;      // 邮政编码

+ (OrderWapper *)shareInstance;

@end
