//
//  NearyTopBar.m
//  GroupPurchase
//
//  Created by xcode on 13-3-11.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "NearbyTopBar.h"

@interface NearbyTopBar()
@property(nonatomic, strong)  UIImageView *overlyView;
@end

@implementation NearbyTopBar

+ (NearbyTopBar *)shared
{
    static NearbyTopBar *topBar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        topBar = [[NearbyTopBar alloc] initWithFrame:CGRectZero];
    });
    return topBar;
}

+ (NearbyTopBar *)addNearyTopBarInView:(UIView *)superView delegate:(id<NearbyTopBarDelegate>)delegate
{
    NearbyTopBar *topBar = [NearbyTopBar shared];
    topBar.delegate = delegate;
    [superView addSubview:topBar];
    return topBar;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect f = CGRectMake(0, 0, LH_SCREEN_WIDTH, NearbyTopBarHeight);
    self = [super initWithFrame:f];
    
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *currentLocationLable, *typeLable;
        currentLocationLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LH_SCREEN_WIDTH/2, NearbyTopBarHeight)];
        currentLocationLable.backgroundColor = [UIColor clearColor];
        currentLocationLable.textColor = [UIColor whiteColor];
        currentLocationLable.textAlignment = NSTextAlignmentCenter;
        currentLocationLable.text = @"当前位置";
        
        typeLable = [[UILabel alloc] initWithFrame:CGRectMake(LH_SCREEN_WIDTH/2, 0, LH_SCREEN_WIDTH/2, NearbyTopBarHeight)];
        typeLable.backgroundColor = currentLocationLable.backgroundColor;
        typeLable.textColor = currentLocationLable.textColor;
        typeLable.textAlignment = currentLocationLable.textAlignment;
        typeLable.text = @"分类";
        
        self.overlyView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NearbyTopBarHeight-2, LH_SCREEN_WIDTH/2, 2)];
        self.overlyView.image = [UIImage imageNamed:@"product_type_bar_overlay"];
        
        [self addSubview:self.overlyView];
        [self addSubview:currentLocationLable];
        [self addSubview:typeLable];
    }
    return self;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self.superview];
    NSUInteger itemIndex = floor(location.x/(LH_SCREEN_WIDTH/2));
    
    CGRect frame = self.overlyView.frame;
    frame.origin.x = itemIndex * (LH_SCREEN_WIDTH/2);
    self.overlyView.frame = frame;
    
    if(self.delegate)
    {
        [self.delegate didSelectedNearbyTopBarAtIndex:itemIndex];
    }
}
@end
