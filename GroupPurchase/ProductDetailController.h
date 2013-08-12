//
//  ProductDetailController.h
//  GroupPurchase
//
//  Created by xcode on 13-1-31.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetErrorViewController.h"

// 产品详情
@class Product;
@interface ProductDetailController : UIViewController<NetErrorViewControllerDelegate>
@property(nonatomic,copy) Product *product;
@property(nonatomic, assign) BOOL showFavoriteButton;  // YES为显示收藏按钮,默认为YES.

- (IBAction)buyNow:(id)sender;
- (IBAction)viewSubbranch:(id)sender;


@end
