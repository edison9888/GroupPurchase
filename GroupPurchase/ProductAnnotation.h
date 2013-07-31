//
//  ProductAnnotation.h
//  GroupPurchase
//
//  Created by xcode on 13-3-29.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ProductAnnotation : NSObject<MKAnnotation>
{
    NSNumber *latitude;
    NSNumber *longitude;
}

@property (nonatomic, assign) CLLocationCoordinate2D c2d;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *subtitleStr;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@end
