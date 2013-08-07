//
//  NSObject+EntityHelper.m
//  GroupPurchase
//
//  Created by xcode on 13-2-16.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "NSObject+EntityHelper.h"

@implementation NSObject (EntityHelper)

- (NSString *)strWithKey:(NSString *)key dictory:(NSDictionary *)dic
{
    NSObject *obj = [dic objectForKey:key];
    
    /* 当dic中存放有值为@"<null>"的对象时,将被视为一个NSNull对象,
     * 下面两行代码将引起程序崩溃(没有初始选择器,因为NSNull对象并没有isEqualToString方法).
     * NSStirng *obj = [dic objectForKey:key];
     * return [obj isEqualToStirng:@"<null">] ? @"" : obj;
     */
    
    if([[obj class] isSubclassOfClass:[NSNull class]]){
        return @"";
    }
    return (NSString *)obj;

}

- (NSUInteger)intWithKey:(NSString *)key dictory:(NSDictionary *)dic
{
    NSObject *obj = [dic objectForKey:key];
    if([[obj class] isSubclassOfClass:[NSNull class]]){
        return 0;
    }
    
    if([key isEqualToString:@"PayMent"]){
        NSLog(@"--");
        return 100;
    }
    return ((NSNumber *)obj).unsignedIntegerValue;
}

- (CGFloat)floatWithKey:(NSString *)key dictory:(NSDictionary *)dic
{
    NSObject *obj = [dic objectForKey:key];
    if([[obj class] isSubclassOfClass:[NSNull class]]){
        return 0.0;
    }
    return ((NSNumber *)obj).floatValue;

}
@end
