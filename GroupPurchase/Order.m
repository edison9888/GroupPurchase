//
//  Order.m
//  GroupPurchase
//
//  Created by xcode on 13-3-8.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "Order.h"
#import "NSObject+EntityHelper.h"

@implementation Order

+ (Order *)orderWithDictionary:(NSDictionary *)dic
{
    Order *order = [[Order alloc] init];
    
    order.ID        = [order intWithKey:@"Id" dictory:dic];
    
    return order;
}

@end


@implementation NMB

+ (NMB *)nmbWithDictionary:(NSDictionary *)dic
{
    NMB *nmb = [[NMB alloc] init];
    
    
    
    return nmb;
}

@end