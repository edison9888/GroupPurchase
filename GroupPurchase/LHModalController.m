//
//  LHModalController.h
//  LHModalController
//
//  Created by xcode on 12-12-12 贵州师范大学内.
//  Copyright (c) 2012年 LiHong(410139419@qq.com). All rights reserved.
//

#import "LHModalController.h"

@interface LHModalController()
@property(nonatomic, strong) UIView *coverView;
@property(nonatomic, strong) UIViewController *rootViewController;
@end

@implementation LHModalController
@synthesize rootViewController;
@synthesize coverView;

- (void)showModalViewContollerWithView:(UIView *)aView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    self.view.frame = applicationFrame;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.rootViewController = keyWindow.rootViewController;
    keyWindow.rootViewController = self;

    CGRect frame = applicationFrame;
    frame.origin = CGPointZero;
    self.rootViewController.view.frame= frame;
    [self.view addSubview:self.rootViewController.view];
    
    self.coverView = [[UIView alloc] initWithFrame:frame];
    self.coverView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = self.coverView.backgroundColor;
    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnCoverView)]];
    [self.view addSubview:self.coverView];
    
    [self.view addSubview:aView];
}

- (void)tapOnCoverView
{
    [self dismiss];
}

- (void)dismiss
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if([keyWindow.rootViewController isKindOfClass:[LHModalController class]])
    {
        [self.rootViewController.view removeFromSuperview];
        keyWindow.rootViewController = self.rootViewController;
    }
}

+ (void)showModalView:(UIView *)aView
{
    if(!aView) return;
    LHModalController *controller = [[LHModalController alloc] init];
    [controller showModalViewContollerWithView:aView];
}

+ (void)dismisModalView
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if([keyWindow.rootViewController isKindOfClass:[LHModalController class]])
    {
        LHModalController *mc = (LHModalController *)keyWindow.rootViewController;
        [mc dismiss];
    }
}

@end
