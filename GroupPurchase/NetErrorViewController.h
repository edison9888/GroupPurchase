//
//  NetErrorViewController.h
//  GroupPurchase
//
//  Created by xcode on 13-3-28.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NetErrorViewControllerDelegate;
@interface NetErrorViewController : UIViewController
@property (nonatomic, weak) id<NetErrorViewControllerDelegate> handleErrorNetDelegate;
@end


@protocol NetErrorViewControllerDelegate <NSObject>
@required
- (void)handelNetConnectonBreakError;
@end