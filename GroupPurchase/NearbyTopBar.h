//
//  NearyTopBar.h
//  GroupPurchase
//
//  Created by xcode on 13-3-11.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NearbyTopBarHeight (30)

@protocol NearbyTopBarDelegate;
@interface NearbyTopBar : UIControl

@property(nonatomic, weak) id<NearbyTopBarDelegate> delegate;

+ (NearbyTopBar *)addNearyTopBarInView:(UIView *)superView delegate:(id<NearbyTopBarDelegate>)delegate;

@end


@protocol NearbyTopBarDelegate <NSObject>
@required
- (void)didSelectedNearbyTopBarAtIndex:(NSInteger)index;
@end
