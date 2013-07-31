//
//  MyOrder.m
//  GroupPurchase
//
//  Created by xcode on 13-3-14.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "MyOrder.h"
#import "NSObject+EntityHelper.h"

@implementation MyOrder

+ (MyOrder *)myOrderWitchDictionary:(NSDictionary *)dic
{
    MyOrder *order = [[MyOrder alloc] init];
    
    order.orderNumber           = [order strWithKey:@"Order_goods_ID" dictory:dic];
    order.prodcutID             = [order intWithKey:@"Team_ID" dictory:dic];
    order.productName           = [order strWithKey:@"Title" dictory:dic];
    order.productCount          = [order intWithKey:@"Order_goods_Num" dictory:dic];
    order.productCostPrice      = [order floatWithKey:@"PriceGoods" dictory:dic];
    order.productVIPPrice       = [order floatWithKey:@"PriceGroup" dictory:dic];
    order.productNotVipPrice    = [order floatWithKey:@"PriceNomember" dictory:dic];
    order.outDate               = [order strWithKey:@"Order_goods_TimeStr" dictory:dic];
    order.titleImageUrl         = [order strWithKey:@"T_x_img" dictory:dic];
    order.payState              = [order intWithKey:@"Order_goods_Payment_Status" dictory:dic];
    order.verCode               = [order strWithKey:@"Order_verification_Code" dictory:dic];
    order.infoID                = [order intWithKey:@"Information_Id" dictory:dic];
    
    return order;
}

@end
