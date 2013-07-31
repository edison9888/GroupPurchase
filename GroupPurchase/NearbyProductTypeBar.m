//
//  NearbyProductTypeBar.m
//  GroupPurchase
//
//  Created by xcode on 13-3-12.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "NearbyProductTypeBar.h"

#define RightMargin (10)
#define IconSize    (13)
#define ItemHeight  (30)
#define SplitLineHeight (1)

@implementation NearbyProductTypeBar

+ (NearbyProductTypeBar *)shareWithFrame:(CGRect )frame delegate:(id<NearbyProductTypeBarDelegate>) delegate
{
    static NearbyProductTypeBar *nptb = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nptb = [[NearbyProductTypeBar alloc] initWithFrame:frame];
        nptb.delegate = delegate;
    });
    return nptb;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect f = frame;
    f.size.height = 2*ItemHeight+1;
    self = [super initWithFrame:f];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];

        UIImageView *jinRiIcon, *teHuiIcon;
        
        jinRiIcon = [[UIImageView alloc] initWithFrame:CGRectMake(RightMargin, RightMargin, IconSize, IconSize)];
        jinRiIcon.image = [UIImage imageNamed:@"NearbyProductTypeBarJinRi"];
        
        teHuiIcon = [[UIImageView alloc] initWithFrame:CGRectMake(RightMargin, RightMargin+ItemHeight+1, IconSize, IconSize)];
        teHuiIcon.image = [UIImage imageNamed:@"NearbyProductTypeBarTeHui"];
        
        CGFloat len = frame.size.width;
        
        _jinRiLable = [[UILabel alloc] initWithFrame:CGRectMake(RightMargin*2 + IconSize, 0, len - RightMargin*2+IconSize,ItemHeight)];
        _jinRiLable.textColor = [UIColor whiteColor];
        _jinRiLable.textAlignment = NSTextAlignmentLeft;
        _jinRiLable.backgroundColor = [UIColor clearColor];
        _jinRiLable.text = @"今日团购";
        
        _teHuiLable = [[UILabel alloc] initWithFrame:CGRectMake(RightMargin*2 + IconSize, ItemHeight+1, len - RightMargin*2+IconSize,ItemHeight)];
        _teHuiLable.textColor = _jinRiLable.textColor;
        _teHuiLable.textAlignment = _jinRiLable.textAlignment;
        _teHuiLable.backgroundColor = _jinRiLable.backgroundColor;
        _teHuiLable.text = @"特惠团购";
        
        UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, ItemHeight, frame.size.width, 1)];
        splitLine.backgroundColor = [UIColor grayColor];
        
        [self addSubview:jinRiIcon];
        [self addSubview:teHuiIcon];
        [self addSubview:self.jinRiLable];
        [self addSubview:self.teHuiLable];
        [self addSubview:splitLine];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    NSInteger itemIndex = floor(location.y/ItemHeight);
    
    if(self.delegate)
    {
        [self.delegate didSelectedNearbyProductTypeBarAtIndex:itemIndex];
    }
}

@end
