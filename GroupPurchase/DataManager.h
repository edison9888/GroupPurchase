//
//  DataManager.h
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-3-15.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Product.h"

@interface DataManager : NSObject

/* 收藏商品
 * @product Product实体
 * @result 在收藏完成时调用,收藏成功参数rect值为YES,失败为NO(NO视为已经收藏).
 * 注:此方法异步执行操作，在操作完成时会在主线程中调用回调方法result.
 */
+ (void)collectProdcut:(Product *)product result:(void(^)(BOOL rect))result;

/* 从产品收藏表中移除一个商品
 * @pid 商品在表中的唯一标识
 */
+ (void)removeCollectedProduct:(NSInteger)pid;

// 获取收藏的商品
+ (void)getAllCollectedProduct:(void(^)(NSMutableArray *))result;

@end
