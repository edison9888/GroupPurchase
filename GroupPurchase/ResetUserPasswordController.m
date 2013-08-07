//
//  ResetUserPasswordController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-14.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "ResetUserPasswordController.h"
#import "GPWSAPI.h"
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"

@interface ResetUserPasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nnewPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation ResetUserPasswordController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"修改密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)resetUserPassword:(id)sender
{
    NSString *oldPassword, *newPassword, *repeatNewPassord;
    NSString *userName, *userPassowrd;
    userName = UserName;
    userPassowrd = Password;
    
    oldPassword = self.oldPasswordTextField.text;
    newPassword = self.nnewPasswordTextField.text;
    repeatNewPassord = self.repeatNewPasswordTextField.text;
    
    if(!oldPassword.length){Alert(@"请输入旧密码"); return;}
    if(!newPassword.length){Alert(@"请输入新密码"); return;}
    if(!repeatNewPassord.length){Alert(@"请确认新密码"); return;}
    if(![newPassword isEqualToString:repeatNewPassord]){Alert(@"两次输入不一致"); return;}
    if([userPassowrd isEqualToString:oldPassword] == NO){Alert(@"旧密码和当前登陆密码不一致"); return;}

    
    [GPWSAPI resetPasswordWithUserName:userName
                              password:userPassowrd
                           oldPassword:oldPassword
                           newPassword:newPassword
                               success:^(BOOL aBool)
                                {
                                    if(aBool)
                                    {
                                        Alert(@"重置密码成功");
                                    }
                                    else
                                    {
                                        Alert(@"重置密码失败,请保证你输入了正确的旧密码!");
                                    }
                                }
                               faile:^(ErrorType errorType)
                                {
                                     Alert(@"重置密码失败");
                                }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect f = self.containerView.frame;
        f.origin.y = -50;
        self.containerView.frame =f;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect f = self.containerView.frame;
        f.origin.y = 0;
        self.containerView.frame = f;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidUnload
{
    [self setOldPasswordTextField:nil];
    [self setNnewPasswordTextField:nil];
    [self setRepeatNewPasswordTextField:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
}
@end
