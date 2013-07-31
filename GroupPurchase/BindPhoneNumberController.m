//
//  BindPhoneNumberController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-22.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "BindPhoneNumberController.h"
#import "AppDelegate.h"
#import "GPWSAPI.h"
#import "UserInfoValidator.h"

extern NSString *const RebindPhoneNumberSuccess;

@interface BindPhoneNumberController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger counter;
@property (copy, nonatomic) NSString *verificationCode;

@end

@implementation BindPhoneNumberController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"绑定手机号码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)responseTimer
{
    if(self.counter == 0){
        [self.timer invalidate];
        self.timer = nil;
        self.getVerificationCodeButton.hidden = NO;
        self.counterLabel.text = @"";
        return;
    }
    self.counterLabel.text = [NSString stringWithFormat:@"%d秒", self.counter--];
}

- (IBAction)getVerificationCode:(id)sender
{
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    if([UserInfoValidator isValidMobileNumber:phoneNumber] == NO){
        Alert(@"手机号输入有误");
        return;
    }
    
    self.counter = 120;
    self.getVerificationCodeButton.hidden = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(responseTimer) userInfo:nil repeats:YES];

    [GPWSAPI getVerificationCodeWithUserName:UserName
                                 phoneNumber:phoneNumber
                                    success:^(NSString *verCode)
                                    {
                                     self.verificationCode = verCode;
                                    } faile:^(ErrorType errorType)
                                    {
                                     Alert(@"获取验证码失败");
                                    }];
}

- (IBAction)bindPhoneNumber:(UIButton *)sender
{
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    if([UserInfoValidator isValidMobileNumber:phoneNumber] == NO){
        Alert(@"手机号输入有误");
        return;
    }
    
    [GPWSAPI bindUserPhoneWithUserName:UserName
                           phoneNumber:phoneNumber
                        oldPhoneNumber:@""
                      verificationCode:self.verificationCode
                               success:^(BOOL aBool) {
                                   if(aBool){
                                       [AppDelegate appDelegateInstance].userInfo.bindPhone = phoneNumber;
                                       [[NSNotificationCenter defaultCenter] postNotificationName:RebindPhoneNumberSuccess object:nil];
                                       Alert(@"绑定成功");
                                   }else{
                                       Alert(@"绑定失败,请检查验证码输入是否有误?");
                                   }
                               }
                                 faile:^(ErrorType errorType) {
                                     Alert(@"绑定失败");
                                 }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidUnload
{
    [self setPhoneNumberTextField:nil];
    [self setVerificationCodeTextField:nil];
    [self setGetVerificationCodeButton:nil];
    [self setCounterLabel:nil];
    [super viewDidUnload];
}
@end
