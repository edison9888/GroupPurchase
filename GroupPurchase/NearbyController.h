//
//  NearbyController.h
//  GroupPurchase
//
//  Created by xcode on 13-1-10.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyTopBar.h"
#import "NearbyProductTypeBar.h"
#import "ProductListView.h"

// 附近

@interface NearbyController : UIViewController<NearbyTopBarDelegate,
                                          CLLocationManagerDelegate,
                                       NearbyProductTypeBarDelegate,
                                          ProductListViewDelegate>

@end
