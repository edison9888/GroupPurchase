//
//  OrderWapper.m
//  GroupPurchase
//
//  Created by xcode on 13-3-25.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "OrderWapper.h"

@implementation OrderWapper

+ (OrderWapper *)shareInstance
{
    static OrderWapper *orderWapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orderWapper = [[OrderWapper alloc] init];
    });
    return orderWapper;
}

@end
