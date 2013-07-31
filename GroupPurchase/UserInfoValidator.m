//
//  Validator.m
//  NSReg
//
//  Created by LiHong 13-3-24.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import "UserInfoValidator.h"

BOOL isValid(NSString *validateObj, NSString *regEx)
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES%@", regEx] evaluateWithObject:validateObj];
}

@implementation UserInfoValidator

+ (BOOL)isValidMobileNumber:(NSString*)mobileNum
{
    /* 手机号
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /* 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /* 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /* 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /* 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    //NSString *PHS    = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    return (   isValid(mobileNum, MOBILE)
            || isValid(mobileNum, CM)
            || isValid(mobileNum, CU)
            || isValid(mobileNum, CT));
}

+ (BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return isValid(email, emailRegEx);
}

+  (BOOL)isValidZipCode:(NSString *)zipCode
{
    NSString *zipCodeRegEx = @"[1-9]\\d{5}(?!\\d)";
    return isValid(zipCode, zipCodeRegEx);
}
@end


