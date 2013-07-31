//
//  ShippingAddress.m
//  GroupPurchase
//
//  Created by xcode on 13-3-4.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "ShippingAddress.h"
#import "NSObject+EntityHelper.h"

@implementation ShippingAddress
+ (ShippingAddress *)shippingAddressWithDictionary:(NSDictionary *)dic
{
    ShippingAddress *sa = [[ShippingAddress alloc] init];
    
    sa.deliveryHits     = [sa strWithKey:@"Hope_Send" dictory:dic];
    sa.consigneeName    = [sa strWithKey:@"Name" dictory:dic];
    sa.flag             = [sa intWithKey:@"Stade" dictory:dic];
    sa.address          = [sa strWithKey:@"Transit_Address" dictory:dic];
    sa.moblieNumber     = [sa strWithKey:@"Transit_Mobile" dictory:dic];
    sa.zipCode          = [sa strWithKey:@"Transit_zip" dictory:dic];
    sa.userName         = [sa strWithKey:@"User_Name" dictory:dic];
    
    return sa;
}

@end
