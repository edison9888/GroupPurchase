//
//  RebindPhoneNumberController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-22.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "RebindPhoneNumberController.h"
#import "GPWSAPI.h"
#import "UserInfoValidator.h"
#import "AppDelegate.h"

NSString *const RebindPhoneNumberSuccess = @"RebindPhoneNumberSuccess";

@interface RebindPhoneNumberController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *newsPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;

@property(nonatomic,copy) NSString *verificationCode;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) NSInteger counter;
@property (weak, nonatomic) IBOutlet UILabel *verificationLabel;

@end

@implementation RebindPhoneNumberController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"重新绑定手机号码";
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
        self.verificationLabel.text = @"";
        return;
    }
    self.verificationLabel.text = [NSString stringWithFormat:@"%d秒", self.counter--];
}


- (IBAction)getVerificationCode:(UIButton *)sender
{
    
    NSString *phoneNumber = self.newsPhoneNumberTextField.text;

    if([UserInfoValidator isValidMobileNumber:phoneNumber] == NO){
        Alert(@"手机号输入有误");
        return;
    }
    
    self.getVerificationCodeButton.hidden = YES;
    self.counter = 120;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(responseTimer) userInfo:nil repeats:YES];
    
    [GPWSAPI getVerificationCodeWithUserName:UserName
                                 phoneNumber:phoneNumber
                                     success:^(NSString *verCode)
                                    {
                                        self.verificationCode = verCode;
                                    } faile:^(ErrorType errorType) {
                                        Alert(@"获取验证码失败");
                                    }];
}

- (IBAction)rebindPhoneNumber:(id)sender
{
    NSString *newPhoneNumber, *oldPhoneNumber, *verificationCode;
    
    newPhoneNumber = self.newsPhoneNumberTextField.text;
    oldPhoneNumber = self.oldPhoneNumberTextField.text;
    verificationCode = self.verificationCodeTextField.text;
    
    if([UserInfoValidator isValidMobileNumber:oldPhoneNumber] == NO){
        Alert(@"旧手机号输入有误");
        return;
    }
    if([UserInfoValidator isValidMobileNumber:newPhoneNumber] == NO){
        Alert(@"新手机号输入有误");
        return;
    }
    if(verificationCode.length == 0){
        Alert(@"请输入验证码");
        return;
    }
    
   [GPWSAPI bindUserPhoneWithUserName:UserName
                          phoneNumber:newPhoneNumber
                       oldPhoneNumber:oldPhoneNumber
                     verificationCode:self.verificationCode
                              success:^(BOOL aBool) {
                                  if(aBool){
                                      [AppDelegate appDelegateInstance].userInfo.bindPhone = newPhoneNumber;
                                      [[NSNotificationCenter defaultCenter] postNotificationName:RebindPhoneNumberSuccess object:nil];
                                      Alert(@"绑定成功");
                                  }else{
                                      Alert(@"绑定失败,请检查验证码是否输入有误?");
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
    [self setOldPhoneNumberTextField:nil];
    [self setNewsPhoneNumberTextField:nil];
    [self setVerificationCodeTextField:nil];
    [self setGetVerificationCodeButton:nil];
    [self setVerificationLabel:nil];
    [super viewDidUnload];
}
@end
