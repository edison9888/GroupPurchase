//
//  ClientToServerAPI.h
//  GroupPurchase
//
//  Created by xcode on 13-1-8.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 商品类别
typedef enum : NSUInteger{
    GoodsTypeToday,        // 今日团购
    GoodsTypeLief,         // 生活服务
    GoodsTypeGoods,        // 商品团购
    GoodsTypeFavorable     // 特惠活动
}GoodsType;

// 一次加载的商品个数
static const NSUInteger pageSize = 20;

@interface ClientToServerAPI : NSObject

- (NSArray *)getGoodsList:(GoodsType)type pageSize:(NSUInteger)size offsetIndex:(NSUInteger)index;
- (NSArray *)getNearGoodsList:(CLLocationCoordinate2D)coordinate;

@end
