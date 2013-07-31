//
//  UserLoginController.h
//  GroupPurchase
//
//  Created by xcode on 13-2-28.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserLoginController : UIViewController

// YES 表示控制器是从OrdersController推入的。从OrdersController推入用户登陆界面时，我们不希望在
// 导航栏上显示后退按钮
@property(assign, nonatomic) BOOL fromMyOrderListController;
@end
