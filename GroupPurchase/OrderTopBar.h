//
//  OrderTopBar.h
//  GroupPurchase
//
//  Created by xcode on 13-3-12.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OrderTopBarHeight (28)

@protocol OrderTopBarDelegate;
@interface OrderTopBar : UIControl

@property(nonatomic, strong) id<OrderTopBarDelegate> delegate;

+ (OrderTopBar *)showOrderTopBarInView:(UIView *)superView withDelegate:(id<OrderTopBarDelegate>)delegate;

@end


@protocol OrderTopBarDelegate <NSObject>
@required
- (void)didSelectedOrderTopBarAtIndex:(NSInteger)index;
@end