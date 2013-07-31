//
//  MapViewController.h
//  GroupPurchase
//
//  Created by xcode on 13-3-28.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Product.h"

@interface MapViewController : UIViewController<MKMapViewDelegate>
- (void)showProductLocation:(Product *)product;
@end
