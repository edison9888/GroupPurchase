//
//  DataInterface.h
//  GroupPurchase
//
//  Created by xcode on 13-2-1.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, ErrorType) {
    ErrorTypeJSONParseError = 0,            // JSON解析错误
    ErrorTypeCanNotGetDataFromServer,       // 服务器没有返回数据
    ErrorTypeNetError                       // 网络错误
};


enum{
    ProductTypeAll          = 0,  // 全部
    ProductTypeToday        = 1,  // 今日
    ProductTypePreferential = 2  //  特惠
};
typedef NSUInteger ProductType;


enum{
    SortTypeRecommand = 1,      // 推荐
    SortTypePriceAac  = 2,      // 价格从低到高
    SortTypePriceDes  = 3,      // 价格从高到低
    SortTypeMostLike  = 4,      // 人气最高
    SortTypeNear      = 5,      // 离我最近
    SortTypeNew       = 6       // 最新发布
};
typedef NSUInteger SortType;


enum{
    UserLoginTypeNotMember = 1, // 非会员用户
    UserLoginTypeMember    = 2, // 会员用户
};
typedef  NSUInteger UserLoginType;


enum{
    CouponTypeUnuse     = 1,    // 未使用
    CouponTypeUsed      = 2,    // 已使用
    CouponTypeOverdue   = 3     // 过期的
};
typedef NSUInteger CouponType;


enum{
    PaymentStatusNotUse         = 1,    // 未使用 未使用=未消费
    PaymentStatusused           = 2,    // 已使用
    PaymentStatusOutDate        = 3,    // 已过期
    PaymentStatusNotPay         = 4,    // 未付款
    PaymentStatusRefunded       = 5,    // 已退款
    PaymentStatusRefunding      = 6,    // 退款处理中
    PaymentStatusRefundReject   = 7     // 拒绝退款
};
typedef NSInteger PaymentStatus;    // 订单支付状态


@class Product;
@class Partner;
@class UserHasLoginedInfo;
@class OrderResult;
@class UnionPayResponse;

@interface GPWSAPI : NSObject

/* 注意:
 * GPWSAPI类的所有带有success和faile回调方法都是[异步执行]的，
 * 当方法执行完毕后将在[主线程中]回调用success和faile方法.
 */

// 获取商品列表
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

// 获取商品详细信息
+ (void)getProductDetailInfomationWithProductID:(NSUInteger)productID
                                        success:(void(^)(Product *product))success
                                          faile:(void(^)(ErrorType errorType))faile;



// 获取分店信息
+ (void)getPartnerWithID:(NSUInteger)partnerID
                 success:(void(^)(Partner *partner))success
                   faile:(void(^)(ErrorType errorType))faile;


// 用户注册
+ (void)userRegisterWithUserName:(NSString *)userName
                        password:(NSString *)password
                        nickname:(NSString *)nickname
                         success:(void(^)(BOOL aBool, NSString *message))success
                           faile:(void(^)(ErrorType errorType))faile;


// 用户登陆
+ (void)userLoginWithUserName:(NSString *)userName
                 userPassword:(NSString *)password
                    loginType:(UserLoginType)type
                      success:(void(^)(BOOL aBool))success
                        faile:(void(^)(ErrorType errorType))faile;


+ (void)getRegisterTipsOnSuccess:(void(^)(NSString *htmlText))success onFail:(void(^)(void))onFail;

// 获取已登陆用户的信息
+ (void)getLoginUserInfoWithUserName:(NSString *)userName
                        userPassword:(NSString *)password
                             success:(void(^)(UserHasLoginedInfo *userInfo))success
                               faile:(void(^)(ErrorType errorType))faile;


/* 重置用户密码
 * 注:userName 是已登陆的用户账户,password 是已登陆的用户密码
 */
+ (void)resetPasswordWithUserName:(NSString *)userName
                         password:(NSString *)password
                      oldPassword:(NSString *)oldPassword
                      newPassword:(NSString *)newPassword
                          success:(void(^)(BOOL aBool))success
                            faile:(void(^)(ErrorType errorType))faile;


// 获取收货地址
+ (void)getShippingAddressWithUserName:(NSString *)userName
                               success:(void(^)(NSArray *))success
                                 faile:(void(^)(ErrorType errorType))faile;


// 添加收货地址
+ (void)addShippingAddressWithConsigneName:(NSString *)name
                                  telphone:(NSString *)telphone
                                   address:(NSString *)address
                                   zipcode:(NSString *)zipcoe
                          isDefaultAddress:(NSNumber *)isDefault
                                  userName:(NSString *)userName
                              userPassword:(NSString *)password
                                   success:(void(^)(BOOL yesOrNo))success
                                     faile:(void(^)(ErrorType errorType))faile;


// 绑定用户手机
+ (void)bindUserPhoneWithUserName:(NSString *)userName
                      phoneNumber:(NSString *)phoneNumber
                   oldPhoneNumber:(NSString *)oldPhoneNUmber
                 verificationCode:(NSString *)verCode
                          success:(void(^)(BOOL aBool))success
                            faile:(void(^)(ErrorType errorType))faile;


// 获取用户绑定的手机号
+ (void)getBindPhoneNumberWithUserName:(NSString *)userName
                               success:(void(^)(NSString *number))success
                                 faile:(void(^)(ErrorType errorType))faile;


// 获取我的优惠卷
+ (void)getMyCouponsWithUserName:(NSString *)userName
                      couponType:(CouponType )atype
                         success:(void(^)(NSArray *array))success
                           faile:(void(^)(ErrorType errorType))faile;


// 更新优惠卷状态到已使用
+ (void)updateMyCouponState:(NSString *)couponNumber
                   userName:(NSString *)userName
                    success:(void(^)(BOOL))success
                      faile:(void(^)(ErrorType errorType))faile;


// 获取我的订单
+ (void)getMyOrdersWithUserName:(NSString *)userName
                      payStatus:(PaymentStatus)status
                        success:(void(^)(NSArray *array))success
                          faile:(void(^)(ErrorType errorType))faile;


// 获取用于手机报绑定的验证码
+ (void)getVerificationCodeWithUserName:(NSString *)userName
                            phoneNumber:(NSString *)phoneNumber
                                success:(void(^)(NSString *))success
                                  faile:(void(^)(ErrorType errorType))faile;


// 提交订单到服务器
+ (void)submitOrderWithAddress:(NSString *)address
                       cityID:(NSString *)cityID
                  phoneNumber:(NSString *)phoneNumber
                    unitPrice:(CGFloat)unitPrice
                      payType:(NSUInteger)payType   // 支付类型(1=支付宝，2=财付通，3=银联)
                   totalPrice:(CGFloat)totalPrice
                     quantity:(NSUInteger)quantity
                       remark:(NSString *)remark   // 备注,如:只在工作日送货（双休日、假日不用送)
                    productID:(NSString *)pID
                       userID:(NSString *)userID
                     receiver:(NSString *)receiver
                      zipCode:(NSString *)zipCode
                      userName:(NSString *)userName
                      password:(NSString *)password
                      success:(void(^)(OrderResult *))success
                        faile:(void(^)(ErrorType errorType))faile;


/* 发送订单,用于获取用于银联手机支付所需要的报文信息
 * @OrderNumber 订单号,由..接口获取
 * @date 订单日期,格式为:YYYYMMDDHHMMSS
 * @amt 金额12位字符串，单位为:分 如:000000000001代表2分钱
 * @desc 订单描述
 * @outDate 商品过期时间yyyyMMddHHmmss
 *
 * @returen (JSON格式)
 * {transType：请求类型01:消费,31:消费撤销,04:退货,
 *  merchantId：商户号,
 *  merchantOrderId：订单号,
 *  merchantOrderTime：订单时间,
 *  merchantOrderAmt：金额,
 *  sign：验证码,
 *  merchantPublicCert：公钥,
 *  queryResult：请求结果,
 *  settleDate：,
 *  setlAmt：,
 *  setlCurrency：,
 *  converRate：,
 *  cupsQid：,
 *  cupsTraceNum：}
 */
+ (void)sendOrderForPhonePayWithOrderNumber:(NSString *)orderNumber
                                       date:(NSString *)orderDate
                                        amt:(NSString *)orderAmt
                                       desc:(NSString *)desc
                                    outDate:(NSString *)outDate
                                    success:(void(^)(NSString *))success
                                      faile:(void(^)(ErrorType errorType))faile;


// 申请退款
+ (void)refundWithOrderNumber:(NSString *)orderNumber
                     userName:(NSString *)userName
             verificationCode:(NSString *)verCode
                       reason:(NSString *)reasonText
                      success:(void(^)(BOOL))success
                        faile:(void(^)(ErrorType erroryType))faile;
@end
