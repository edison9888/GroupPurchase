//
//  GroupPurchaseController.h
//  GroupPurchase
//
//  Created by xcode on 13-1-10.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductTypeBar.h"
#import "ProductSortTypeView.h"
#import "ProductListView.h"
#import "NetErrorViewController.h"

// 却掉城市名称后面的“市,区,自治州,地区，县”等字,比如:贵阳市，安顺市去掉后分别为贵阳，安顺.
NSString *cutSuffixOfCityName(NSString *cityName);

// 团购
@interface GroupPurchaseController : UIViewController
                                    <ProductTypeBarDelegate,ProductSortTypeViewDelegate,
                                    CLLocationManagerDelegate,ProductListViewDelegate>

@end
