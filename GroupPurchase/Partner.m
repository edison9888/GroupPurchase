//
//  Partner.m
//  GroupPurchase
//
//  Created by xcode on 13-2-16.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "Partner.h"
#import "PartnerBranch.h"
#import "NSObject+EntityHelper.h"

@implementation Partner

+(Partner *)partnerWithDictory:(NSDictionary *)dic;
{
    Partner *partner = [[Partner alloc] init];
    
    partner.ID          = [partner intWithKey:@"ID" dictory:dic];
    partner.cityID      = [partner intWithKey:@"City_id" dictory:dic];
    partner.homePage    = [partner strWithKey:@"Homepage" dictory:dic];
    partner.userName    = [partner strWithKey:@"Username" dictory:dic];
    partner.password    = [partner strWithKey:@"Password" dictory:dic];
    partner.title       = [partner strWithKey:@"Title" dictory:dic];
    
    NSArray *branchs  = [dic objectForKey:@"Branchs"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:branchs.count];
    for(NSDictionary *dic in branchs)
        [items addObject:[PartnerBranch partnerBranchWithDictory:dic]];
    partner.branchs = items;
    
    return partner;
}

@end
