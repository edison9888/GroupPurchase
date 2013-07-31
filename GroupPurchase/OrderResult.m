//
//  OrderResult.m
//  GroupPurchase
//
//  Created by xcode on 13-3-26.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "OrderResult.h"
#import "NSObject+EntityHelper.h"

@implementation OrderResult

+ (OrderResult *)orderResultWithDictonary:(NSDictionary *)dic
{
    OrderResult *or = [[OrderResult alloc] init];
    or.orderNumber  = [or strWithKey:@"OrderNo" dictory:dic];
    or.orderDate    = [or strWithKey:@"CreateTimeStr" dictory:dic];
    or.outDate      = [or strWithKey:@"Validation_DateStr" dictory:dic];
    or.price        = [or strWithKey:@"Price" dictory:dic];
    return or;
}

- (NSString *)orderDate
{
    NSString *replaceStr = [_orderDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return  replaceStr;
}

- (NSString *)outDate
{
    NSString *replaceStr = [_outDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return  replaceStr;
}

- (NSString *)price
{
    NSString *priceStr = [NSString stringWithFormat:@"%lld", (long long int)(_price.floatValue * 100)];
    NSInteger len = priceStr.length;
    NSString *str = @"000000000000";
    return [str stringByReplacingCharactersInRange:NSMakeRange(str.length-len, len) withString:priceStr];
}

- (NSString *)desc
{
    if(!_desc)
        return @"describe for order";
    return _desc;
}

@end
