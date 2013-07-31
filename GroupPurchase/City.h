//
//  City.h
//  GroupPurchase
//
//  Created by xcode on 13-2-4.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 城市实体

@interface City : NSObject

@property(nonatomic,assign) NSUInteger  cityID;
@property(nonatomic,copy)   NSString    *cityName;
@property(nonatomic,copy)   NSString    *citySort;
@property(nonatomic,copy)   NSString    *pinyIn;
@property(nonatomic,assign) NSUInteger  proID;
@property(nonatomic,copy)   NSString    *proName;
@property(nonatomic,copy)   NSString    *pyShort;

+ (City *)cityWithDictionary:(NSDictionary *)dic;

@end
