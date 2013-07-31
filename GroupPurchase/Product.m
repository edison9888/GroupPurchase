//
//  Product.m
//  GroupPurchase
//
//  Created by xcode on 13-1-31.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "Product.h"
#import "NSObject+EntityHelper.h"

@implementation Product

+(Product *)productWithDictory:(NSDictionary *)dic
{
    Product *product = [[Product alloc] init];
    
    product.ID                  =  [product intWithKey:@"id" dictory:dic];
    product.infoID              =  [product intWithKey:@"Information_Id" dictory:dic];
    product.activity            =  [product intWithKey:@"Activity" dictory:dic];
    product.createDate          =  [product strWithKey:@"CreateDateStr" dictory:dic];
    product.adminUser           =  [product strWithKey:@"Admin_User" dictory:dic];
    product.cityID              =  [product intWithKey:@"Area_City_Id" dictory:dic];
    product.buyWater            =  [product intWithKey:@"BuyWater" dictory:dic];
    product.clearingPrice       =  [product floatWithKey:@"ClearingPrice" dictory:dic];
    product.description         =  [product strWithKey:@"description" dictory:dic];
    product.detail              =  [product strWithKey:@"Detail" dictory:dic];
    product.discount            =  [product intWithKey:@"Discount" dictory:dic];
    product.endDate             =  [product strWithKey:@"EndDateStr" dictory:dic];
    product.examine             =  [product intWithKey:@"Examine" dictory:dic];
    product.express             =  [product intWithKey:@"Express" dictory:dic];
    product.informationID       =  [product intWithKey:@"Information_Id" dictory:dic];
    product.integral            =  [product intWithKey:@"Integral" dictory:dic];
    product.keywords            =  [product strWithKey:@"keywords" dictory:dic];
    product.limitBuy            =  [product intWithKey:@"LimitBuy" dictory:dic];
    product.minimumBuy          =  [product intWithKey:@"MinimumBuy" dictory:dic];
    product.name                =  [product strWithKey:@"Name" dictory:dic];
    product.payMent             =  [product intWithKey:@"PayMent" dictory:dic];
    product.postMoney           =  [product floatWithKey:@"PostMoney" dictory:dic];
    product.priceGoods          =  [product floatWithKey:@"Pricegoods" dictory:dic];
    product.priceGroup          =  [product floatWithKey:@"PriceGroup" dictory:dic];
    product.priceNonMember      =  [product floatWithKey:@"PriceNonMember" dictory:dic];
    product.projectId           =  [product intWithKey:@"ProjectId" dictory:dic];
    product.sequ                =  [product intWithKey:@"Sequ" dictory:dic];
    product.smsContent          =  [product strWithKey:@"Sms_Content" dictory:dic];
    product.startDate           =  [product strWithKey:@"StartDateStr" dictory:dic];
    product.stock               =  [product intWithKey:@"Stock" dictory:dic];
    product.tImg                =  [product strWithKey:@"T_img" dictory:dic];
    product.txImg               =  [product strWithKey:@"T_x_img" dictory:dic];
    product.tips                =  [product strWithKey:@"Tips" dictory:dic];
    product.title               =  [product strWithKey:@"Title" dictory:dic];
    product.typeFatherID        =  [product intWithKey:@"Type_Father_ID" dictory:dic];
    product.verificationDate    =  [product strWithKey:@"VerificationDateStr" dictory:dic];
    product.VIPBuy              =  [product intWithKey:@"VIP_Buy" dictory:dic];
    product.cityName            =  [product strWithKey:@"CityName" dictory:dic];
    product.shopName            =  [product strWithKey:@"ShopName" dictory:dic];
    product.sumBuyQty           =  [product intWithKey:@"SumBuyQty" dictory:dic];
    product.distance            =  [product floatWithKey:@"Distance" dictory:dic];
    product.address             =  [product strWithKey:@"Address" dictory:dic];
    product.contPackage         =  [product strWithKey:@"Cont_Package" dictory:dic];
    product.buyTip              =  [product strWithKey:@"Buy_Tip" dictory:dic];
    product.phone               =  [product strWithKey:@"Phone" dictory:dic];
    product.type                =  [product intWithKey:@"Type_Father_ID" dictory:dic];
    product.latitude            =  [product floatWithKey:@"V_Coordinate" dictory:dic];
    product.longitude           =  [product floatWithKey:@"H_Coordinate" dictory:dic];
    
    return product;
}

@end
