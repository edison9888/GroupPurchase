//
//  ShippingAddress.h
//  GroupPurchase
//
//  Created by xcode on 13-3-4.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 收货地址
@interface ShippingAddress : NSObject
@property(nonatomic, copy)   NSString  *deliveryHits;   // 发货备注(工作日双休日与假日均可送货)
@property(nonatomic, copy)   NSString  *consigneeName;  // 收货人姓名
@property(nonatomic, assign) NSInteger flag;            // 1表示位默认收货地址
@property(nonatomic, copy)   NSString  *address;        // 收货地址
@property(nonatomic, copy)   NSString  *moblieNumber;   // 手机号
@property(nonatomic, copy)   NSString  *zipCode;        // 邮编
@property(nonatomic, copy)   NSString  *userName;       // 从属那个用户

+ (ShippingAddress *)shippingAddressWithDictionary:(NSDictionary *)dic;

@end
