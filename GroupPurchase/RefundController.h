//
//  RefundController.h
//  GroupPurchase
//
//  Created by xcode on 13-3-19.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrder.h"

// 订单-退款-退款详细界面
@interface RefundController : UIViewController
@property(nonatomic, retain) MyOrder *order;

@property(nonatomic, assign) BOOL usingForOutDateController;
@end
