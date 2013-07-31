//
//  PartnerBranch.h
//  GroupPurchase
//
//  Created by xcode on 13-2-16.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 分店实体 REF:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/10

@interface PartnerBranch : NSObject

@property(nonatomic,assign) NSUInteger ID;
@property(nonatomic,copy)   NSString   *address;
@property(nonatomic,copy)   NSString   *location;          // 交通路线
@property(nonatomic,copy)   NSString   *contact;           // 联系方式
@property(nonatomic,copy)   NSString   *phoneNumber;       // 联系电话
@property(nonatomic,copy)   NSString   *mobilePhoneNumber; // 移动电话

+ (PartnerBranch *)partnerBranchWithDictory:(NSDictionary *)dic;

@end
