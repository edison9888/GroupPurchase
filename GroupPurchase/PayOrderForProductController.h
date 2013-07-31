//
//  PayOrderForProductController.h
//  GroupPurchase
//
//  Created by xcode on 13-2-25.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface PayOrderForProductController : UIViewController<UIActionSheetDelegate>
@property(nonatomic,strong) Product *product;
@end
