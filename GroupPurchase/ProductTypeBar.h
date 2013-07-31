//
//  ProductTypeBar.h
//  GroupPurchase
//
//  Created by xcode on 13-2-20.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PRODUCT_TYPE_BAR_ITEM_LEN (LH_SCREEN_WIDTH/3)
#define PRODUCT_TYPE_BAR_ITEM_HEI (28)

@protocol ProductTypeBarDelegate <NSObject>
@required
- (void)didSelectProductTypeBarAtIndex:(NSUInteger)aIndex;
@end

// 用于切换产品类型的控件,此控件用于"团购“栏目
@interface ProductTypeBar : UIControl
@property(nonatomic,weak) id<ProductTypeBarDelegate> delegate;
@end
