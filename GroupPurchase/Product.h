//
//  Product.h
//  GroupPurchase
//
//  Created by xcode on 13-1-31.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShippingAddress.h"

// 产品实体

@interface Product : NSObject

@property(nonatomic,assign) NSUInteger      ID;
@property(nonatomic,assign) NSUInteger      dbID;                   // 此ID用于数据库中的产品标识
@property(nonatomic,assign) NSUInteger      infoID;                 // 用于获取分店
@property(nonatomic,assign) NSUInteger      activity;               // 参加活动(0=不参加，1=参加)
@property(nonatomic,copy)   NSString        *adminUser;      
@property(nonatomic,assign) NSUInteger      cityID;          
@property(nonatomic,assign) NSUInteger      buyWater;               // 购买人数注水
@property(nonatomic,assign) CGFloat         clearingPrice;          // 结算价
@property(nonatomic,copy)   NSString        *createDate;            // 商品创建时间
@property(nonatomic,copy)   NSString        *description;           // 产品描述
@property(nonatomic,copy)   NSString        *detail;                // 商品详情
@property(nonatomic,assign) CGFloat         discount;               // 折扣
@property(nonatomic,copy)   NSString        *endDate;
@property(nonatomic,assign) NSUInteger      examine;                // 审核标志（1为已审，0为未审）
@property(nonatomic,assign) NSUInteger      express;                // 是否需要快递，0为无需快递，1为需快递
@property(nonatomic,assign) NSUInteger      informationID;          // 商家信息
@property(nonatomic,assign) NSUInteger      integral;               // 积分，积分是某个产品加上积分才能购买
@property(nonatomic,copy)   NSString        *keywords;              // 产品关键字
@property(nonatomic,assign) NSUInteger      limitBuy;               // 每个ID最高限购
@property(nonatomic,assign) NSUInteger      minimumBuy;             // 每个ID最低限购
@property(nonatomic,copy)   NSString        *name;                  // 签约人
@property(nonatomic,assign) NSUInteger      payMent;                // 支付方式 (1.在线支付，2.货到付款，3.无需支付，4.到店支付)
@property(nonatomic,assign) CGFloat         postMoney;              // 邮费
@property(nonatomic,assign) CGFloat         priceGoods;             // 商品原价;
@property(nonatomic,assign) CGFloat         priceGroup;             // 会员价格
@property(nonatomic,assign) CGFloat         priceNonMember;         // 非会员价格
@property(nonatomic,assign) NSUInteger      projectId;              // 项目类别
@property(nonatomic,assign) NSUInteger      sequ;                   // 商品排序(默认为1000则，不在前15位)
@property(nonatomic,copy)   NSString        *smsContent;            // 短信内容
@property(nonatomic,copy)   NSString        *startDate;             // 发布时间
@property(nonatomic,assign) NSUInteger      stock;                  // 库存
@property(nonatomic,copy)   NSString        *tImg;                  // 商品图片
@property(nonatomic,copy)   NSString        *txImg;                 // 客户端用缩略图
@property(nonatomic,copy)   NSString        *tips;                  // 温馨提示
@property(nonatomic,copy)   NSString        *title;                 // 商品名称
@property(nonatomic,assign) NSUInteger      typeFatherID;           // 商品1级分类
@property(nonatomic,copy)   NSString        *verificationDate;      // 验证有效期
@property(nonatomic,assign) NSUInteger      VIPBuy;                 // 仅限VIP才能购买（0为默认，1为VIP才能购买）
@property(nonatomic,copy)   NSString        *cityName;              // 城市名
@property(nonatomic,copy)   NSString        *shopName;              // 店铺名
@property(nonatomic,assign) NSUInteger      sumBuyQty;              // 合计销售数量（注水+订单量）
@property(nonatomic,assign) CGFloat         distance;               // 产品所属商家里目前定位位置的距离
@property(nonatomic,copy)   NSString        *address;               // 商家地址
@property(nonatomic,copy)   NSString        *contPackage;           // 套餐内容
@property(nonatomic,copy)   NSString        *buyTip;                // 购买须知
@property(nonatomic,copy)   NSString        *phone;                 // 商家电话
@property(nonatomic,assign) NSUInteger      type;                   // 商品类别,1:商品团购,2:生活服务,3:特惠商品(当商品类处理)

@property(nonatomic,assign) NSUInteger      buyAmount;              // 购买数量(此字段来用存放客户在订单界面选择购买商品的个数，服务器端无此字段)
@property(nonatomic,assign) CGFloat         payable;                // 实际付款(实际付款等于:单价*数量-优惠卷金额)
@property(nonatomic,copy)   NSString        *songHuoRiQi;           // 送货日期
@property(nonatomic, strong) ShippingAddress *sadress;              // 默认的收货地址对象

@property(nonatomic,assign) CGFloat         latitude;               // 纬度
@property(nonatomic,assign) CGFloat         longitude;              // 经度

+ (Product *)productWithDictory:(NSDictionary *)dic;

@end
