//
//  OrdersController.h
//  GroupPurchase
//
//  Created by xcode on 13-1-10.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTopBar.h"
#import "OrderSegementBar.h"

// 订单

@interface OrdersController : UIViewController<OrderTopBarDelegate,
                                          OrderSegementBarDelegate,
                                          UITableViewDataSource,
                                          UITableViewDelegate>
{
    
}
@end
