//
//  PayOrderController.h
//  GroupPurchase
//
//  Created by xcode on 13-3-25.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderWapper.h"
#import "UPOMP.h"

@interface PayOrderController : UIViewController<UPOMPDelegate>
@property(nonatomic, strong) OrderWapper *orderWapper;
@end
