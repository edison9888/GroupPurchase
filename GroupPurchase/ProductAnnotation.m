//
//  ProductAnnotation.m
//  GroupPurchase
//
//  Created by xcode on 13-3-29.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "ProductAnnotation.h"

@implementation ProductAnnotation

- (CLLocationCoordinate2D)coordinate;
{
    return self.c2d;
}

- (NSString *)title
{
    return self.titleStr;
}

- (NSString *)subtitle
{
    return self.subtitleStr;
}
@end
