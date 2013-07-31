//
//  RefundOperationController.m
//  GroupPurchase
//
//  Created by xcode on 13-4-2.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "RefundOperationController.h"
#import "UserInfoValidator.h"
#import "GPWSAPI.h"

@interface RefundOperationController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextView *refundReasonTextView;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

@property (copy, nonatomic) NSString *verificationCode;
@property (assign, nonatomic) NSInteger countDownNumber;

@end

@implementation RefundOperationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setPhoneNumberTextField:nil];
    [self setVerificationCodeTextField:nil];
    [self setRefundReasonTextView:nil];
    [self setGetVerificationCodeButton:nil];
    [self setContainerView:nil];
    [self setCountDownLabel:nil];
    [super viewDidUnload];
}

// 获取验证码
- (IBAction)getVerificationCode:(id)sender
{
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    if([UserInfoValidator isValidMobileNumber:phoneNumber] == NO){
        Alert(@"请输入有效的电话号码!");
        return;
    }
    
    self.getVerificationCodeButton.enabled = NO;
    
    [GPWSAPI getVerificationCodeWithUserName:UserName phoneNumber:phoneNumber success:^(NSString *verCode) {
        self.verificationCode = verCode;
        self.getVerificationCodeButton.enabled = YES;
        
    } faile:^(ErrorType errorType) {
        self.getVerificationCodeButton.enabled = YES;
        
        if(AppDel.reach.isReachable == NO){
            Alert(@"获取验证码失败,请连接到网络");
        }else{
            Alert(@"获取验证码失败");
        }
    }];
}

// 退款
- (IBAction)refund:(id)sender
{
    NSString *phoneNumber, *verificationCode, *refundReason;
    
    phoneNumber = self.phoneNumberTextField.text;
    verificationCode = self.verificationCodeTextField.text;
    refundReason = self.refundReasonTextView.text;
    
    if([phoneNumber isEqualToString:verificationCode]){
        Alert(@"输入的验证码不正确");
        return;
    }
    
    if(refundReason.length < 6){
        Alert(@"请输入退款原因,不少于6个字");
        return;
    }
    
    [GPWSAPI refundWithOrderNumber:self.order.orderNumber
                          userName:UserName
                  verificationCode:verificationCode
                            reason:refundReason
                           success:^(BOOL result){
                               if(result){
                                   Alert(@"申请退款成功");
                               }else{
                                   Alert(@"申请退款失败");
                               }
                           }
                          faile:^(ErrorType erroryType) {
                              if(AppDel.reach.isReachable == NO){
                                  Alert(@"申请退款失败,请连接到网络");
                              }else{
                                  Alert(@"申请退款失败,请稍后再试.");
                              }
                          }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect frame = self.containerView.frame;
    
    if(LH_SCREEN_HEIGHT == 480){
        frame.origin.y = -120;
    }else{
        frame.origin.y = -50;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame = frame;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect frame = self.containerView.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame = frame;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
