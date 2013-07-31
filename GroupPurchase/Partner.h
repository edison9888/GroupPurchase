//
//  Partner.h
//  GroupPurchase
//
//  Created by xcode on 13-2-16.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 商家实体 REF:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/10

@interface Partner : NSObject

@property(nonatomic,assign)   NSUInteger ID;
@property(nonatomic,assign)   NSUInteger cityID;
@property(nonatomic,copy)     NSString   *homePage;
@property(nonatomic,copy)     NSString   *userName;
@property(nonatomic,copy)     NSString   *password;          // 商家密码
@property(nonatomic,copy)     NSString   *title;
@property(nonatomic,strong)   NSArray    *branchs;           // 分店

+(Partner *)partnerWithDictory:(NSDictionary *)dic;

@end
