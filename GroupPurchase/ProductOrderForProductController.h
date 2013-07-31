//
//  ProductOrderForProductController.h
//  GroupPurchase
//
//  Created by xcode on 13-2-25.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

// 商品类订单
@interface ProductOrderForProductController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong) Product *product;
@end
