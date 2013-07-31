//
//  PayOrderForLifeController.h
//  GroupPurchase
//
//  Created by xcode on 13-2-25.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

// 生活服务类订单支付
@interface PayOrderForLifeController : UIViewController<UIActionSheetDelegate>
@property(nonatomic,strong) Product *product;
@end
