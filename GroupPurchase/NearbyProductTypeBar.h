//
//  NearbyProductTypeBar.h
//  GroupPurchase
//
//  Created by xcode on 13-3-12.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NearbyProductTypeBarDelegate;

@interface NearbyProductTypeBar : UIControl

@property(nonatomic, strong) id<NearbyProductTypeBarDelegate> delegate;
@property(nonatomic, readonly, strong) UILabel *jinRiLable;
@property(nonatomic, readonly, strong) UILabel *teHuiLable;

+ (NearbyProductTypeBar *)shareWithFrame:(CGRect )frame delegate:(id<NearbyProductTypeBarDelegate>)delegate;

@end


@protocol NearbyProductTypeBarDelegate <NSObject>
@required
- (void)didSelectedNearbyProductTypeBarAtIndex:(NSInteger)index;
@end