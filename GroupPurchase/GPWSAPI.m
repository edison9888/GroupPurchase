//
//  DataInterface.m
//  GroupPurchase
//
//  Created by xcode on 13-2-1.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "GPWSAPI.h"
#import "Model.h"
#import "UserHasLoginedInfo.h"
#import "Coupon.h"
#import "MyOrder.h"
#import "OrderResult.h"
#import "UninoPayResponse.h"

#define SERVER_ADDRESS        @"http://117.135.211.227:801"
#define MakeAPIAddress(p,d)   [NSString stringWithFormat:@"%@/%@/%@", SERVER_ADDRESS,p,d]


#define PRODUCT_SERVICE       @"ProDataService"
#define SYSTEM_SERVICE        @"SystemService"
#define ORDER_SERVICE         @"OrderService"

#define GET_PRODUCT_LIST      @"GetPros/%d/%d/%@/%.1f/%.1f/%d/%d/0/%d/%d"  // REF:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/2
#define GET_PRODUCT_INFO      @"GetProInfo/%d"                           // REF:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/7
#define GET_PARTNER_INFO      @"GetPartner/%d"                           // REF:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/11
#define GET_CITY_LIST         @"SearchCitys/%@"

#define USER_LOGIN          @"UserLogin"
#define USER_REGISTER       @"Register"
#define USER_RESET_PASSWORD @"SetPassword"

#define ORDER_SHIPPING_ADDRESS @"GetMyAddress/%@/1/100"
#define ORDER_NEW_ADDRESS      @"AddNewAddress"
#define ORDER_BIND_PHONE       @"BindPhone"
#define ORDER_GET_BIND_PHONE   @"GetMyBindPhone/%@"
#define ORDER_GET_COUPONS      @"GetMyCouPon/%@/%d/1/1000"                // REF:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/5
#define ORDER_GET_MY_ORDERS    @"GetMyOrdInfos/%@/%d/1/1000"              // REF:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/4
#define ORDER_REFUND           @"ReturnMoney"                             // REF:
#define ORDER_GET_VER_CODE     @"GetVerificationCode/%@/%@"
#define ORDER_SUBMIT           @"SubmitOrder"
#define ORDER_UPDATE_STATE     @"UpdateMyCouPon/%@/%@"

@implementation GPWSAPI

+ (void)getDataFromServerWithAddress:(NSString *)aURLStr
                             success:(void(^)(id jsonObj))success
                               faile:(void(^)(ErrorType errorType)) faile
{
    NSURL *url = [NSURL URLWithString:[aURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                               timeoutInterval:10];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
   
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
         {
             if(data.length > 0 && !error)
             {
                 NSError *err =nil;
                 NSJSONReadingOptions options =   NSJSONReadingMutableContainers
                 | NSJSONReadingMutableLeaves
                 | NSJSONReadingAllowFragments;
                 id JSONObj = [NSJSONSerialization JSONObjectWithData:data options:options error:&err];
                
                 if(!err)
                     success(JSONObj);
                 else
                     faile(ErrorTypeJSONParseError);
                 
             }else if(data.length == 0 && !error)
             {
                 faile(ErrorTypeCanNotGetDataFromServer);
             }
             else
             {
                  faile(ErrorTypeNetError);
             }
 
         });
    }];
}


+ (void)postDataToServerWithAddress:(NSString *)aURLStr
                            request:(NSMutableURLRequest *)urlRequest
                           jsonData:(NSData *)data
                            success:(void(^)(id jsonObj))success
                              faile:(void(^)(ErrorType errorType)) faile
{
    NSAssert(urlRequest, @"request 对象不能为NULL!");
    
    NSURL *url = [NSURL URLWithString:[aURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setURL:url];
    [urlRequest setTimeoutInterval:15];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if(data) [urlRequest setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
       dispatch_async(dispatch_get_main_queue(), ^
         {
           if(data.length > 0 && !error)
           {
               NSLog(@"余额:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
               
               NSError *err =nil;
               NSJSONReadingOptions options =   NSJSONReadingMutableContainers
               | NSJSONReadingMutableLeaves
               | NSJSONReadingAllowFragments;
               id JSONObj = [NSJSONSerialization JSONObjectWithData:data options:options error:&err];
               
               if(!err)
                   success(JSONObj);
               else
                   faile(ErrorTypeJSONParseError);
               
           }else if(data.length == 0 && !error)
           {
               faile(ErrorTypeCanNotGetDataFromServer);
           }
           else
           {
               faile(ErrorTypeNetError);
           }
       });
     }];
}


#pragma mark -
#pragma mark - Product


/* 获取产品列表
 * 接口文档参考:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/2
 * 
 * 参数:
 * cityID    : 城市ID,0全部城市.
 * typeID    : 类别ID,0全部，1近日,2特惠
 * keyWord   : 关键字，若值为空则设置为null字符串
 * lon       : 当前位置的经度,0为设置
 * lat       : 当前位置纬度,0未设置
 * distance  : 范围,0未设置
 * sortType  : 排序方式（1:推荐排序 2：价格升序 3：价格降序  4：人气最高  5：离我最近  6：最新发布）
 * pageSize  : 页大小
 * pageIndex : 当前第几页,从1开始.
 *
 * 返回:
 * 返回Product对象的数组
 *
 * 注意:
 * 此方法完成时，将异步调用success或fail Block,若需在block中执行UI相关的操作,则要获取主线程队列，然后在其中执行.
 */

+ (void)getProductListWithCityID:(NSUInteger)cityID
                          typeID:(ProductType)typeID
                         keyWord:(NSString *)keyWord
                             lon:(CGFloat)lon
                             lat:(CGFloat)lat
                        distance:(NSUInteger)distance
                        sortType:(SortType)sortType
                        pageSize:(NSUInteger)pageSize
                       pageIndex:(NSUInteger)pageIndex
                         success:(void(^)(NSMutableArray *productEntities))success
                           faile:(void(^)(ErrorType errorType)) faile;

{
    keyWord = ([keyWord isEqualToString:@""] || keyWord == nil) ? @"null" : keyWord;
    
    // 在服务器端用pageIndex==1表示获取第1页的内容,在客户端用pageIndex==0表示获取第1页的内容,所以这里进行加1操作.
    ++pageIndex;
    
    NSString *urlStr = [NSString stringWithFormat:MakeAPIAddress(PRODUCT_SERVICE, GET_PRODUCT_LIST),cityID, typeID, keyWord, lon,
                        lat, distance, sortType, pageSize, pageIndex];
    
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj)
    {
        NSMutableArray *prodcutEntityArray = [NSMutableArray new];
        NSArray *jsonObj_ = jsonObj;
        for(NSDictionary *dic in jsonObj_)
        {
            Product *product = [Product productWithDictory:dic];
            [prodcutEntityArray addObject:product];
        }
        success(prodcutEntityArray);
        
    } faile:^(ErrorType errorType)
     {
        faile(errorType);
    }];
}


/* 获取产品列表:
 * 接口文档:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/7
 */
+ (void)getProductDetailInfomationWithProductID:(NSUInteger)productID
                                        success:(void(^)(Product *product))success
                                          faile:(void(^)(ErrorType errorType))faile
{
    NSString *urlStr = [NSString stringWithFormat:MakeAPIAddress(PRODUCT_SERVICE, GET_PRODUCT_INFO), productID];
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj)
    {
        success([Product productWithDictory:jsonObj]);
    } faile:^(ErrorType errorType)
     {
        faile(errorType);
    }];
}


/* 获取分店信息
 * 接口文档:http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/11
 */
+ (void)getPartnerWithID:(NSUInteger)partnerID
                 success:(void (^)(Partner *partner))success
                   faile:(void (^)(ErrorType))faile
{
    NSString *urlStr = [NSString stringWithFormat:MakeAPIAddress(SYSTEM_SERVICE, GET_PARTNER_INFO), partnerID];
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj)
     {
        success([Partner partnerWithDictory:jsonObj]);
    } faile:^(ErrorType errorType)
    {
        faile(errorType);
    }];
}

#pragma mark -
#pragma mark - 订单,优惠卷


#pragma mark -
#pragma mark - 用户

+(void)userRegisterWithUserName:(NSString *)userName
                       password:(NSString *)password
                       nickname:(NSString *)nickname
                        success:(void (^)(BOOL, NSString *))success
                          faile:(void (^)(ErrorType))faile
{
    NSDictionary *dic =  @{@"email":userName,@"nickName":nickname,@"password":password};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [GPWSAPI postDataToServerWithAddress:MakeAPIAddress(SYSTEM_SERVICE, USER_REGISTER) request:[NSMutableURLRequest new] jsonData:data success:^(id jsonObj)
     {
         NSDictionary *dic = jsonObj;
         NSNumber *num = dic[@"Result"];
         if(num.integerValue == 1)
             success(YES,dic[@"Message"]);
         else
             success(NO,dic[@"Message"]);
         
     } faile:^(ErrorType errorType) {
         faile(errorType);
     }];
}


/* 用户登陆 
 * http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/12 */

+ (void)userLoginWithUserName:(NSString *)userName
                 userPassword:(NSString *)password
                    loginType:(UserLoginType)type
                      success:(void(^)(BOOL aBool))success
                        faile:(void(^)(ErrorType errorType))faile
{
    NSString *areaCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"areaCode"];
    NSDictionary *dic = @{@"uid":userName, @"pwd":password, @"areaCode":areaCode, @"loginType":[NSNumber numberWithInteger:type]};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [GPWSAPI postDataToServerWithAddress:MakeAPIAddress(SYSTEM_SERVICE, USER_LOGIN) request:[NSMutableURLRequest new] jsonData:data success:^(id jsonObj)
    {
        NSDictionary *dic = jsonObj;
        NSNumber *num = dic[@"Result"];
        if(num.integerValue == 1)
            success(YES);
        else
            success(NO);
        
    } faile:^(ErrorType errorType) {
        faile(errorType);
    }];
}

+ (void)getRegisterTipsOnSuccess:(void(^)(NSString *htmlText))success onFail:(void(^)(void))onFail
{
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"cityCode"];
    NSString *urlStr = [NSString stringWithFormat:@"http://117.135.211.227:801/SystemService/GetRegMethodInfo/%@", cityCode];
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj) {
        NSDictionary *dic = jsonObj;
        NSString *htmlText = dic[@"RegMethod"];
        success(htmlText);
    } faile:^(ErrorType errorType) {
        onFail();
    }];
}


/* 获取已登陆用户信息
 * http://qun.qq.com/air/#256895218/bbs/view/cd/1/td/23 */

+ (void)getLoginUserInfoWithUserName:(NSString *)userName
                        userPassword:(NSString *)password
                             success:(void(^)(UserHasLoginedInfo *userInfo))success
                               faile:(void(^)(ErrorType errorType))faile
{
    NSString *urlStr = MakeAPIAddress(SYSTEM_SERVICE, @"GetUserInfo");
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest addValue:[NSString stringWithFormat:@"%@/%@", userName, password] forHTTPHeaderField:@"Authorization"];
    [GPWSAPI postDataToServerWithAddress:urlStr request:urlRequest jsonData:nil success:^(id jsonObj)
    {
        NSDictionary *dic = (NSDictionary *)jsonObj;
        UserHasLoginedInfo *userInfo = [UserHasLoginedInfo userHasLoginedInfoWithDictionary:dic];
        success(userInfo);
    } faile:^(ErrorType errorType)
    {
        faile(errorType);
    }];
}


+ (void)resetPasswordWithUserName:(NSString *)userName
                     password:(NSString *)password
                  oldPassword:(NSString *)oldPassword
                  newPassword:(NSString *)newPassword
                      success:(void(^)(BOOL aBool))success
                        faile:(void(^)(ErrorType errorType))faile
{
    NSDictionary *dic = @{@"oldPwd":oldPassword,@"newPwd":newPassword};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request addValue:[NSString stringWithFormat:@"%@/%@",userName,password] forHTTPHeaderField:@"Authorization"];
    [GPWSAPI postDataToServerWithAddress:MakeAPIAddress(SYSTEM_SERVICE, USER_RESET_PASSWORD) request:[NSMutableURLRequest new]
                                jsonData:data success:^(id jsonObj)
     {
         NSDictionary *dic = jsonObj;
         NSNumber *num = dic[@"Result"];
         if(num.integerValue == 1)
             success(YES);
         else
             success(NO);
         
     } faile:^(ErrorType errorType) {
         faile(errorType);
     }];
}


+ (void)getShippingAddressWithUserName:(NSString *)userName
                               success:(void(^)(NSArray *))success
                                 faile:(void(^)(ErrorType errorType))faile
{
    NSString *urlStr = [NSString stringWithFormat:MakeAPIAddress(ORDER_SERVICE, ORDER_SHIPPING_ADDRESS),userName];
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj)
    {
        NSMutableArray *ShippingAddressArray = [NSMutableArray new];
        NSArray *array = (NSArray *)jsonObj;
        for(NSDictionary *dic in array)
            [ShippingAddressArray addObject:[ShippingAddress shippingAddressWithDictionary:dic]];
        success(ShippingAddressArray);
        
    } faile:^(ErrorType errorType) {
        faile(errorType);
    }];
}


+ (void)addShippingAddressWithConsigneName:(NSString *)name
                                  telphone:(NSString *)telphone
                                   address:(NSString *)address
                                   zipcode:(NSString *)zipcoe
                          isDefaultAddress:(NSNumber *)isDefault
                                  userName:(NSString *)userName
                              userPassword:(NSString *)password
                                   success:(void(^)(BOOL yesOrNo))success
                                     faile:(void(^)(ErrorType errorType))faile;
{
    NSDictionary *dic = @{@"City_Name":@"", @"Hope_Send":@"", @"Name":name,
                          @"Province_Name":@"", @"Stade":isDefault,
                          @"Transit_Address":address,@"Transit_Mobile":telphone,
                          @"Transit_zip":zipcoe,@"User_Name":userName};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request addValue:[NSString stringWithFormat:@"%@/%@",userName,password] forHTTPHeaderField:@"Authorization"];
    [GPWSAPI postDataToServerWithAddress:MakeAPIAddress(ORDER_SERVICE,ORDER_NEW_ADDRESS) request:request
                                jsonData:data success:^(id jsonObj)
     {
         NSDictionary *dic = jsonObj;
         NSNumber *num = dic[@"Result"];
         if(num.integerValue == 1)
             success(YES);
         else
             success(NO);
         
     } faile:^(ErrorType errorType) {
         faile(errorType);
     }];
}


+ (void)bindUserPhoneWithUserName:(NSString *)userName
                      phoneNumber:(NSString *)phoneNumber
                   oldPhoneNumber:(NSString *)oldPhoneNUmber
                 verificationCode:(NSString *)verCode
                          success:(void(^)(BOOL aBool))success
                            faile:(void(^)(ErrorType errorType))faile
{
    NSDictionary *dic = @{@"Mobile_Num":phoneNumber,@"User_Name":userName,@"Old_Number":oldPhoneNUmber,@"VerificationCode":verCode};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [GPWSAPI postDataToServerWithAddress:MakeAPIAddress(ORDER_SERVICE, ORDER_BIND_PHONE) request:request jsonData:data success:^(id jsonObj)
    {
        NSDictionary *dic = (NSDictionary *)jsonObj;
        NSNumber *num = dic[@"Result"];
        if(num.integerValue)
            success(YES);
        else
            success(NO);
        
    } faile:^(ErrorType errorType)
    {
        faile(errorType);
    }];
}


+ (void)getBindPhoneNumberWithUserName:(NSString *)userName
                               success:(void(^)(NSString *number))success
                                 faile:(void(^)(ErrorType errorType))faile
{
    NSString *urlStr = [NSString stringWithFormat:MakeAPIAddress(ORDER_SERVICE, ORDER_GET_BIND_PHONE), userName];
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj)
    {
        NSDictionary *dic = (NSDictionary *)jsonObj;
        success(dic[@"Mobile_Num"]);
        
    } faile:^(ErrorType errorType)
    {
        faile(errorType);
    }];
}


+ (void)getMyCouponsWithUserName:(NSString *)userName
                      couponType:(CouponType)atype
                         success:(void (^)(NSArray *))success
                           faile:(void (^)(ErrorType))faile
{
    NSString *urlStr = [NSString stringWithFormat:MakeAPIAddress(ORDER_SERVICE, ORDER_GET_COUPONS),userName,atype];
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *objs = (NSArray *)jsonObj;
        for(NSDictionary *dic in objs)
        {
            Coupon *coupon = [Coupon couponWithDictionary:dic];
            [array addObject:coupon];
        }
        
        success(array);
    } faile:^(ErrorType errorType)
    {
        faile(errorType);
    }];
}


+ (void)updateMyCouponState:(NSString *)couponNumber
                   userName:(NSString *)userName
                    success:(void(^)(BOOL))success
                      faile:(void(^)(ErrorType errorType))faile
{
    NSString *urlStr = [NSString stringWithFormat:MakeAPIAddress(ORDER_SERVICE, ORDER_UPDATE_STATE), couponNumber, userName];
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj) {
        NSLog(@"%@", jsonObj);
    } faile:^(ErrorType errorType) {
        
    }];
}


+ (void)getMyOrdersWithUserName:(NSString *)userName
                      payStatus:(PaymentStatus)status
                        success:(void (^)(NSArray *))success
                          faile:(void (^)(ErrorType))faile
{
    NSString *urlStr = [NSString stringWithFormat:MakeAPIAddress(ORDER_SERVICE, ORDER_GET_MY_ORDERS), userName, status];
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj)
    {
        NSArray *myOrders = (NSArray *)jsonObj;
        NSMutableArray *array = [NSMutableArray new];
        
        for(NSDictionary *dic in myOrders)
        {
            MyOrder *order = [MyOrder myOrderWitchDictionary:dic];
            [array addObject:order];
        }
        
        success(array);
     
    } faile:^(ErrorType errorType) {
        faile(errorType);
    }];
}

+ (void)getVerificationCodeWithUserName:(NSString *)userName
                            phoneNumber:(NSString *)phoneNumber
                                success:(void(^)(NSString *))success
                                  faile:(void(^)(ErrorType errorType))faile
{
    NSAssert(userName && phoneNumber, @"必须传入用户名和电话号");
    NSString *urlStr = [NSString stringWithFormat:MakeAPIAddress(ORDER_SERVICE, ORDER_GET_VER_CODE), userName, phoneNumber];
    
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj)
    {
        NSDictionary *dic = (NSDictionary *)jsonObj;
        success(dic[@"VerificationCode"]);
    } faile:^(ErrorType errorType)
    {
        faile(errorType);
    }];
}

+ (void)submitOrderWithAddress:(NSString *)address
                        cityID:(NSString *)cityID
                   phoneNumber:(NSString *)phoneNumber
                     unitPrice:(CGFloat)unitPrice
                       payType:(NSUInteger)payType   
                    totalPrice:(CGFloat)totalPrice
                      quantity:(NSUInteger)quantity
                        remark:(NSString *)remark   
                     productID:(NSString *)pID
                        userID:(NSString *)userID
                      receiver:(NSString *)receiver
                       zipCode:(NSString *)zipCode
                      userName:(NSString *)userName
                      password:(NSString *)password
                       success:(void(^)(OrderResult *orderResult))success
                         faile:(void(^)(ErrorType errorType))faile
{
    NSAssert(userName && password, @"提交订单需要对身份进行验证");
    
    NSDictionary *dic = @{@"Address":(address ? address : @""),
                          @"CityId":cityID,
                          @"Mobile":(phoneNumber ? phoneNumber : @""),
                          @"Money":[NSNumber numberWithFloat:unitPrice],
                          @"Online_Pay_Type":[NSNumber numberWithInt:payType],
                          @"Price":[NSNumber numberWithFloat:totalPrice],
                          @"Quantity":[NSNumber numberWithInt:quantity],
                          @"Sms_Content":(remark ? remark : @""),
                          @"TeamId":pID,
                          @"UserId":userID,
                          @"User_Name":receiver,
                          @"ZipCode":(zipCode ? zipCode : @"")};
    
     NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
     NSMutableURLRequest *request = [NSMutableURLRequest new];
     [request addValue:[NSString stringWithFormat:@"%@/%@",userName,password] forHTTPHeaderField:@"Authorization"];
    
    [GPWSAPI postDataToServerWithAddress:MakeAPIAddress(ORDER_SERVICE,ORDER_SUBMIT)
                                 request:request
                                jsonData:data
                                 success:^(id jsonObj)
    {
        success([OrderResult orderResultWithDictonary:(NSDictionary *)jsonObj]);
    } faile:^(ErrorType errorType) {
        faile(errorType);
    }];
}


+ (void)sendOrderForPhonePayWithOrderNumber:(NSString *)orderNumber
                                       date:(NSString *)orderDate
                                        amt:(NSString *)orderAmt
                                       desc:(NSString *)desc
                                    outDate:(NSString *)outDate
                                    success:(void(^)(NSString *))success
                                      faile:(void(^)(ErrorType errorType))faile
{
    //SendOrder/{orderId}/{orderTime}/{orderAmt}/{orderDesc}/{timeout}
    NSString *urlStr = [NSString stringWithFormat:@"http://117.135.211.227:8985/PhonePay/SendOrder/%@/%@/%@/%@/%@",
                        orderNumber,orderDate,orderAmt,desc,outDate];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [urlRequest setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse *rs, NSData *data, NSError *error)
     {
        dispatch_async(dispatch_get_main_queue(), ^
         {
            if(data.length > 0 && !error)
            {
                NSString *responseMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                success(responseMessage);
            }else if(data.length == 0 && !error)
            {
                faile(ErrorTypeCanNotGetDataFromServer);
            }else{
                faile(ErrorTypeNetError);
            }
        });
     }];
}

+ (void)refundWithOrderNumber:(NSString *)orderNumber
                     userName:(NSString *)userName
             verificationCode:(NSString *)verCode
                       reason:(NSString *)reasonText
                      success:(void(^)(BOOL))success
                        faile:(void(^)(ErrorType erroryType))faile
{
    NSDictionary *dic = @{@"OrderNo":verCode,@"Order_goods_ID":orderNumber,@"UserName":userName, @"Why_Pay":reasonText};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    [GPWSAPI postDataToServerWithAddress:MakeAPIAddress(ORDER_SERVICE,ORDER_SUBMIT)
                                 request:request
                                jsonData:data
                                 success:^(id jsonObj)
     {
         NSLog(@"%@", jsonObj);
     } faile:^(ErrorType errorType) {
         faile(errorType);
     }];
}

#pragma mark -
#pragma mark - 城市


// 为服务器的城市列表生成一个本地副本
+ (void)buildADuplicateForServerCityList
{
    NSString *urlStr = [NSString stringWithFormat:MakeAPIAddress(SYSTEM_SERVICE, GET_CITY_LIST), @"null"];
    
    [GPWSAPI getDataFromServerWithAddress:urlStr success:^(id jsonObj)
    {
        
        NSArray *keys = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
        NSMutableDictionary *cities = [NSMutableDictionary dictionaryWithCapacity:keys.count];
        for(NSString *key in keys)
        {
            [cities setObject:[NSMutableArray new] forKey:key];
        }
       
        NSArray *jsonObj_ = jsonObj;
        for(NSDictionary *dic in jsonObj_)
        {
            NSString *key = [dic objectForKey:@"Py_short"];            
            NSNumber *cityID = [dic objectForKey:@"CityID"];
            NSString *cityName = [dic objectForKey:@"CityName"];
            NSString *pinYin  = [dic objectForKey:@"Pinyin"];
            
            NSDictionary *cityEntity = @{@"CityID":cityID,@"CityName":cityName,@"PinYin":pinYin,@"PinYinShort":key};
            NSMutableArray *entities = [cities objectForKey:key];
            [entities addObject:cityEntity];
        }
            
         if(![cities writeToFile:[GPWSAPI dataFilePath] atomically:YES])
         {
             NSLog(@"保存程序列表失败");
         }
        
    } faile:^(ErrorType errorType)
    {
        NSLog(@"获取城市列表失败");
    }];
}


+ (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"cities.plist"];
}

@end
