//
//  ProductSortTypeView.h
//  GroupPurchase
//
//  Created by xcode on 13-2-20.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductSortTypeViewDelegate <NSObject>
@required
- (void)didSelectProductSortTypeViewAtIndex:(NSInteger)aIndex;
@end

@interface ProductSortTypeView : UIControl
@property(nonatomic,weak) id<ProductSortTypeViewDelegate> delegate;

+(ProductSortTypeView *)sharedWithFrame:(CGRect)frame;

@end
