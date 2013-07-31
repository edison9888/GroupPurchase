//
//  OrderSegementBar.m
//  GroupPurchase
//
//  Created by xcode on 13-3-12.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "OrderSegementBar.h"
#import "OrderTopBar.h"

@interface OrderSegementBar()
@property(nonatomic, strong) NSMutableArray *titleLabels;
@property(nonatomic, strong) UILabel *lastSelectedLabel;
@end


#define ItemCount (5)
#define ItemWidth (LH_SCREEN_WIDTH / ItemCount)

@implementation OrderSegementBar

+ (OrderSegementBar *) showOrderSegementBarInView:(UIView *)superView withDelegate:(id<OrderSegementBarDelegate>)delegate
{
    OrderSegementBar *osb = [OrderSegementBar share];
    osb.delegate = delegate;
    [superView addSubview:osb];
    return osb;
}

+ (OrderSegementBar *)share
{
    static OrderSegementBar *osb = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        osb = [[OrderSegementBar alloc] initWithFrame:CGRectZero];
    });
    return osb;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect f = CGRectMake(0, 0, LH_SCREEN_WIDTH, OrderSegementBarHeight);
    self = [super initWithFrame:f];
    if (self)
    {
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LH_SCREEN_WIDTH, OrderSegementBarHeight)];
        backgroundView.image = [UIImage imageNamed:@"order_segmented_bar_bg@2x"];
        [self addSubview:backgroundView];
        
        self.titleLabels = [NSMutableArray arrayWithCapacity:ItemCount];
        NSArray *tiltes  = @[@"待付款",@"未消费",@"已消费",@"退款",@"已过期"];
        
        for(int i = 0; i != ItemCount; i++)
        {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(i*ItemWidth, 0, ItemWidth, OrderSegementBarHeight)];
            l.backgroundColor = [UIColor clearColor];
            l.textColor = [UIColor lightGrayColor];
            l.textAlignment = NSTextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:15];
            l.text = tiltes[i];
            
            [self addSubview:l];
            self.titleLabels[i] = l;
        }
        
        UILabel *l = self.titleLabels[0];
        l.textColor = [UIColor orangeColor];
        self.lastSelectedLabel = l;
    }
    return self;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self.superview];
    NSUInteger itemIndex = floor(location.x/ItemWidth);
    
    UILabel *l = self.titleLabels[itemIndex];
    l.textColor = [UIColor orangeColor];
    self.lastSelectedLabel.textColor = [UIColor lightGrayColor];
    self.lastSelectedLabel = l;
    
    if(self.delegate)
    {
        [self.delegate didSelectedOrderSegementBarAtIndex:itemIndex];
    }
}
@end
