//
//  UninoPayResponse.m
//  GroupPurchase
//
//  Created by xcode on 13-3-26.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "UninoPayResponse.h"
#import "NSObject+EntityHelper.h"

@implementation UnionPayResponse

+ (UnionPayResponse *)unionPayResponseWithDictionary:(NSDictionary *)dic
{
    UnionPayResponse *upr = [[UnionPayResponse alloc] init];
    
    upr.transType           = [upr strWithKey:@"transType" dictory:dic];
    upr.merchantId          = [upr strWithKey:@"merchantId" dictory:dic];
    upr.merchantOrderId     = [upr strWithKey:@"merchantOrderId" dictory:dic];
    upr.merchantOrderTime   = [upr strWithKey:@"merchantOrderTime" dictory:dic];
    upr.merchantOrderAmt    = [upr strWithKey:@"merchantOrderAmt" dictory:dic];
    upr.sign                = [upr strWithKey:@"sign" dictory:dic];
    upr.merchantPublicCert  = [upr strWithKey:@"merchantPublicCert" dictory:dic];
    upr.queryReuslt         = [upr strWithKey:@"queryReuslt" dictory:dic];
    upr.settleDate          = [upr strWithKey:@"settleDate" dictory:dic];
    upr.setlAmt             = [upr strWithKey:@"setlAmt" dictory:dic];
    upr.setlCurrency        = [upr strWithKey:@"setlCurrency" dictory:dic];
    upr.converRate          = [upr strWithKey:@"converRate" dictory:dic];
    upr.cupsQid             = [upr strWithKey:@"cupsQid" dictory:dic];
    upr.cupsTraceNum        = [upr strWithKey:@"cupsTraceNum" dictory:dic];
    upr.cupsTraceTime       = [upr strWithKey:@"cupsTraceTime" dictory:dic];
    upr.cupsRespCode        = [upr strWithKey:@"cupsRespCode" dictory:dic];
    upr.cupsRespDesc        = [upr strWithKey:@"cupsRespDesc" dictory:dic];
    
    return upr;
}

@end
