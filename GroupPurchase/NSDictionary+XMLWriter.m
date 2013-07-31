//
//  NSDictionary+XMLWriter.m
//  GroupPurchase
//
//  Created by xcode on 13-3-27.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "NSDictionary+XMLWriter.h"

@implementation NSDictionary (XMLWriter)
- (NSString *)xmlString
{
    NSArray *allKeys = [self allKeys];
    NSAssert(allKeys.count, @"字典不能为空");
    
    NSString *xmlStr = @"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><upomp application=\"LanchPay.Req\">";
    
    for(NSString *key in allKeys)
    {
        NSString *value = [self objectForKey:key];
        NSString *string = [NSString stringWithFormat:@"<%@>%@</%@>", key, value, key];
        xmlStr = [xmlStr stringByAppendingString:string];
    }
    
    return [xmlStr stringByAppendingString:@"</upomp>"];
}
@end
