//
//  OrderSegementBar.h
//  GroupPurchase
//
//  Created by xcode on 13-3-12.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OrderSegementBarHeight (40)

@protocol OrderSegementBarDelegate;
@interface OrderSegementBar : UIControl

@property(nonatomic, strong) id<OrderSegementBarDelegate> delegate;

+ (OrderSegementBar *)showOrderSegementBarInView:(UIView *)superView withDelegate:(id<OrderSegementBarDelegate>)delegate;

@end


@protocol OrderSegementBarDelegate <NSObject>
@required
- (void)didSelectedOrderSegementBarAtIndex:(NSInteger)index;
@end