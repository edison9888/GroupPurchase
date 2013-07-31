//
//  NSObject+EntityHelper.h
//  GroupPurchase
//
//  Created by xcode on 13-2-16.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EntityHelper)

- (NSString *)strWithKey:(NSString *)key dictory:(NSDictionary *)dic;
- (NSUInteger)intWithKey:(NSString *)key dictory:(NSDictionary *)dic;
- (CGFloat)floatWithKey:(NSString *)key dictory:(NSDictionary *)dic;

@end
