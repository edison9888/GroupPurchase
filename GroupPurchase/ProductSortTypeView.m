//
//  ProductSortTypeView.m
//  GroupPurchase
//
//  Created by xcode on 13-2-20.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "ProductSortTypeView.h"
#import "ProductTypeBar.h"

#define ITEM_COUNT (5)
#define ITEM_HEI   (32)

@implementation ProductSortTypeView
{
    NSInteger       _lastSelectItemIndex;
    NSArray         *_titleArray;
    NSMutableArray *_itemsImageViewArray;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect f = frame;
    f.size = CGSizeMake(PRODUCT_TYPE_BAR_ITEM_LEN, ITEM_COUNT*ITEM_HEI);
    self = [super initWithFrame:f];
    
    if (self)
    {
        _lastSelectItemIndex = 0;
        _titleArray = @[@"默认排序",@"价格最低",@"价格最高",@"人气最高",@"离我最近",@"最新发布"];
        _itemsImageViewArray = [NSMutableArray arrayWithCapacity:ITEM_COUNT];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];

        CGRect frame;
        for(NSUInteger i = 0; i != ITEM_COUNT; i++)
        {
            frame = CGRectMake(0, i*ITEM_HEI,PRODUCT_TYPE_BAR_ITEM_LEN, ITEM_HEI);
            UIImageView *aView = [[UIImageView alloc] initWithFrame:frame];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:frame];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = _titleArray[i];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font = [UIFont systemFontOfSize:15];
            lable.textColor = [UIColor whiteColor];
            
            [self addSubview:aView];
            [self addSubview:lable];
            [_itemsImageViewArray addObject:aView];
            
            if(i == _lastSelectItemIndex)
            {
                aView.image = [UIImage imageNamed:@"nav_bj"];
            }
        }
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    NSInteger itemIndex = floor(location.y/ITEM_HEI);
    
    UIImageView *aView = _itemsImageViewArray[_lastSelectItemIndex];
    aView.image = nil;
    aView = (UIImageView *)_itemsImageViewArray[itemIndex];
    aView.image = [UIImage imageNamed:@"nav_bj"];
    
    _lastSelectItemIndex = itemIndex;
    
    if(self.delegate)
    {
        // 为了将选择项的索引值itemIndex与SortType的值对应起来,这里进行+1操作.
        ++itemIndex;
        [self.delegate didSelectProductSortTypeViewAtIndex:itemIndex];
    }
}

+(ProductSortTypeView *)sharedWithFrame:(CGRect)frame
{
    static ProductSortTypeView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ProductSortTypeView alloc] initWithFrame:frame];
    });
    return instance;
}

@end
