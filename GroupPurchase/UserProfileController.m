//
//  UserProfileController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-4.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "UserProfileController.h"
#import "AppDelegate.h"
#import "ShippingAddressListController.h"
#import "ResetUserPasswordController.h"
#import "GPWSAPI.h"
#import "BindPhoneNumberController.h"
#import "RebindPhoneNumberController.h"

extern NSString *const RebindPhoneNumberSuccess;

@interface UserProfileController ()

@property (weak, nonatomic) IBOutlet UILabel *bindTelphoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindPhoneNumberButton;

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIntegralLabel;

@property (assign, nonatomic) BOOL isUserBindPhoneNumber; // YES当前登陆的用户已经绑定手机号
@end

@implementation UserProfileController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"我的详细资料";
    }
    return self;
}

- (void)viewDidUnload
{
    [self setBindTelphoneNumberLabel:nil];
    [self setBindTelphoneNumberLabel:nil];
    [self setBindPhoneNumberButton:nil];
    [self setUserHeadImageView:nil];
    [self setUserNicknameLabel:nil];
    [self setAccountBalanceLabel:nil];
    [self setUserIntegralLabel:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UserInfo *userInfo = AppDel.userInfo;
    self.userNicknameLabel.text = UserName;
    self.accountBalanceLabel.text = FLOAT_TO_STR(userInfo.userLoginedInfo.accountBalance);
    self.userIntegralLabel.text = FLOAT_TO_STR(userInfo.userLoginedInfo.accountIntegral);
    
    if(userInfo.bindPhone == nil){
        [GPWSAPI getBindPhoneNumberWithUserName:UserName success:^(NSString *number)
        {
            if([number isEqual:nil] || [number isEqualToString:@""])
            {
                self.isUserBindPhoneNumber = NO;
            }else{
                self.isUserBindPhoneNumber = YES;
                self.bindTelphoneNumberLabel.text = number;
                userInfo.bindPhone = number;
            }
        } faile:^(ErrorType errorType)
        {
            
        }];
    }else{
        self.isUserBindPhoneNumber = YES;
        self.bindTelphoneNumberLabel.text = userInfo.bindPhone;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handelRebindPhoneNumberSuccessNotification)
                                                 name:RebindPhoneNumberSuccess
                                               object:nil];
}

- (void)handelRebindPhoneNumberSuccessNotification
{
    self.bindTelphoneNumberLabel.text = UserName;
}


- (IBAction)updateBindTelphoneNumber:(id)sender
{
    if(self.isUserBindPhoneNumber)
    {
        RebindPhoneNumberController *rpnc = [[RebindPhoneNumberController alloc] initWithNibName:@"RebindPhoneNumberController" bundle:nil];
        [self.navigationController pushViewController:rpnc animated:YES];
    }else{
        BindPhoneNumberController *bpnc = [[BindPhoneNumberController alloc] initWithNibName:@"BindPhoneNumberController" bundle:nil];
        [self.navigationController pushViewController:bpnc animated:YES];
    }
}

- (IBAction)updateShippingAddress:(id)sender
{
    ShippingAddressListController *sal = [[ShippingAddressListController alloc] init];
    [self.navigationController pushViewController:sal animated:YES];
}

- (IBAction)resetUserPassword:(id)sender
{
    ResetUserPasswordController *rupc = [[ResetUserPasswordController alloc] initWithNibName:@"ResetUserPasswordController" bundle:nil];
    [self.navigationController pushViewController:rupc animated:YES];
}

@end
