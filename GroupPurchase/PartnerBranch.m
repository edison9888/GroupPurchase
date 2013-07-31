//
//  PartnerBranch.m
//  GroupPurchase
//
//  Created by xcode on 13-2-16.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "PartnerBranch.h"
#import "NSObject+EntityHelper.h"

@implementation PartnerBranch

+ (PartnerBranch *)partnerBranchWithDictory:(NSDictionary *)dic
{
    PartnerBranch *partnerBranch = [[PartnerBranch alloc] init];
    
    partnerBranch.ID                = [partnerBranch intWithKey:@"ID" dictory:dic];
    partnerBranch.address           = [partnerBranch strWithKey:@"Address" dictory:dic];
    partnerBranch.location          = [partnerBranch strWithKey:@"Location" dictory:dic];
    partnerBranch.contact           = [partnerBranch strWithKey:@"Contact" dictory:dic];
    partnerBranch.phoneNumber       = [partnerBranch strWithKey:@"Phone" dictory:dic];
    partnerBranch.mobilePhoneNumber = [partnerBranch strWithKey:@"Mobile" dictory:dic];
    
    return partnerBranch;
}

@end
