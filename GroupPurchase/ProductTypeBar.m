//
//  ProductTypeBar.m
//  GroupPurchase
//
//  Created by xcode on 13-2-20.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "ProductTypeBar.h"

@implementation ProductTypeBar
{
    UIImageView *_backgroundView, *_overlayView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect f = frame;
        f.size = CGSizeMake(LH_SCREEN_WIDTH, PRODUCT_TYPE_BAR_ITEM_HEI);
        f.origin = CGPointZero;
        _backgroundView = [[UIImageView alloc] initWithFrame:f];
        _backgroundView.image = [UIImage imageNamed:@"product_type_bar_bg"];
        
        f = CGRectMake(0, 0, PRODUCT_TYPE_BAR_ITEM_LEN, 3);
        _overlayView = [[UIImageView alloc] initWithFrame:f];
        _overlayView.image = [UIImage imageNamed:@"product_type_bar_overlay"];
        _overlayView.center = CGPointMake(PRODUCT_TYPE_BAR_ITEM_LEN/2.0, PRODUCT_TYPE_BAR_ITEM_HEI-1.5);
        
        [self addSubview:_backgroundView];
        [self addSubview:_overlayView];
    }
    return self;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self.superview];
    NSUInteger itemIndex = floor(location.x/PRODUCT_TYPE_BAR_ITEM_LEN);
    if(itemIndex != 2)
    {
        [UIView animateWithDuration:0.2 animations:^{
            _overlayView.center = CGPointMake(itemIndex*PRODUCT_TYPE_BAR_ITEM_LEN + PRODUCT_TYPE_BAR_ITEM_LEN/2.0, PRODUCT_TYPE_BAR_ITEM_HEI-1.5);
        }];
    }
    // 进行++操作,将itemIndex的值与ProductType枚举的含义对应.
    ++itemIndex;
    if(self.delegate)
    {
        [self.delegate didSelectProductTypeBarAtIndex:itemIndex];
    }
}

@end
