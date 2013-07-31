//
//  OrderTopBar.m
//  GroupPurchase
//
//  Created by xcode on 13-3-12.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "OrderTopBar.h"

#define Margin (10)
#define ItemWidth ((LH_SCREEN_WIDTH-(2*Margin))/2)

@interface OrderTopBar()
@property(nonatomic, strong) UIImageView *backgroundView, *selectedView, *triangleView;
@end

@implementation OrderTopBar

+ (OrderTopBar *)showOrderTopBarInView:(UIView *)superView withDelegate:(id<OrderTopBarDelegate>)delegate
{
    OrderTopBar *otb = [OrderTopBar shared];
    otb.delegate = delegate;
    [superView addSubview:otb];
    return otb;
}

+ (OrderTopBar *)shared
{
    static OrderTopBar *otb;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        otb =  [[OrderTopBar alloc] initWithFrame:CGRectZero];
    });
    return otb;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect f = CGRectMake(0, 0, LH_SCREEN_WIDTH, OrderTopBarHeight);
    self = [super initWithFrame:f];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];

        f = CGRectMake(Margin, 0, LH_SCREEN_WIDTH-(2*Margin), OrderTopBarHeight);
        self.backgroundView = [[UIImageView alloc] initWithFrame:f];
        self.backgroundView.image = [UIImage imageNamed:@"order_top_bar_bg"];
        
        f = CGRectMake(Margin, 0, ItemWidth, OrderTopBarHeight);
        self.selectedView = [[UIImageView alloc] initWithFrame:f];
        self.selectedView.image = [UIImage imageNamed:@"order_top_bar_selected"];
        
        f = CGRectMake(0, 0, 11, 6);
        self.triangleView = [[UIImageView alloc] initWithFrame:f];
        self.triangleView.image = [UIImage imageNamed:@"order_top_bar_triangle"];
        self.triangleView.center = CGPointMake(Margin+ItemWidth/2, OrderTopBarHeight-3);
        
        UILabel *lable1, *lable2;
        
        lable1 = [[UILabel alloc] initWithFrame:CGRectMake(Margin, 0, ItemWidth, OrderTopBarHeight)];
        lable1.textColor = [UIColor whiteColor];
        lable1.backgroundColor = [UIColor clearColor];
        lable1.textAlignment = NSTextAlignmentCenter;
        lable1.text = @"团购单";
        
        lable2 = [[UILabel alloc] initWithFrame:CGRectMake(Margin+ItemWidth, 0, ItemWidth, OrderTopBarHeight)];
        lable2.textColor = lable1.textColor;
        lable2.backgroundColor = lable1.backgroundColor;
        lable2.textAlignment = lable1.textAlignment;
        lable2.text = @"抽奖单";
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.selectedView];
        [self addSubview:self.triangleView];
        [self addSubview:lable1];
        [self addSubview:lable2];
    }
    return self;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self.superview];
    NSUInteger itemIndex = floor(location.x/(LH_SCREEN_WIDTH/2));
    
    CGRect f = self.selectedView.frame;
    f.origin.x = Margin + itemIndex * ItemWidth;
    self.selectedView.frame = f;
    
    f = self.triangleView.frame;
    f.origin.x = Margin + itemIndex * ItemWidth + ItemWidth/2;
    self.triangleView.frame = f;
    
    if(self.delegate)
    {
        [self.delegate didSelectedOrderTopBarAtIndex:itemIndex];
    }
}

@end
