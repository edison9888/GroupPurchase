//
//  UserLoginController.m
//  GroupPurchase
//
//  Created by xcode on 13-2-28.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "UserLoginController.h"
#import "UserRegisterController.h"
#import "GPWSAPI.h"
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"
#import "RetakeUserPasswordController.h"

NSString *const UserLoginSuccessNotification = @"UserLoginSuccessNotification";

@interface UserLoginController ()
@property (weak, nonatomic) IBOutlet UIButton *userMemberLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *userNotMemberLoginButton;
@property (weak, nonatomic) IBOutlet UIImageView *userLoginCurrentImageView;
@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@end

@implementation UserLoginController
{
    UserLoginType _userLoginType;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"用户登陆";
        self.fromMyOrderListController = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _userLoginType = UserLoginTypeMember;
    self.navigationItem.hidesBackButton = self.fromMyOrderListController;
}

- (IBAction)userLogin:(id)sender
{
    NSString *userName, *userPassword;
    userName = self.userAccountTextField.text;
    userPassword = self.userPasswordTextField.text;
    if(userName.length == 0)
    {
        Alert(@"请输入用户名");
        return;
    }
    if(userPassword.length == 0)
    {
        Alert(@"请输入密码");
        return;
    }
    
    showHudWith(self.view, @"正在登陆", YES, NO);
    [GPWSAPI userLoginWithUserName:userName userPassword:userPassword loginType:_userLoginType success:^(BOOL aBool)
    {
        if(aBool)
        {            
            saveUserName(userName);
            saveUserName(userPassword);
                        
            // 有MoreControll处理此通知来更新界面
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccessNotification object:nil];
            
        }else
        {
            showHudWith(self.view, @"登陆失败", NO, YES);
        }
    } faile:^(ErrorType errorType)
    {
         showHudWith(self.view, @"登陆失败", NO, YES);
    }];
}

- (IBAction)userRegister:(id)sender
{
    UserRegisterController *urc = [[UserRegisterController alloc] initWithNibName:@"UserRegisterController" bundle:nil];
    [self.navigationController pushViewController:urc animated:YES];
}

- (IBAction)retakeUserPassword:(UIButton *)sender
{
    RetakeUserPasswordController *rupc = [[RetakeUserPasswordController alloc] initWithNibName:@"RetakeUserPasswordController" bundle:nil];
    [self.navigationController pushViewController:rupc animated:YES];
}

- (IBAction)switchUserLoginType:(UIButton *)sender
{
    [UIView animateWithDuration:0.0 animations:^
    {
        CGRect frame = self.userLoginCurrentImageView.frame;
        frame.origin.x = CGRectGetMinX(sender.frame);
        self.userLoginCurrentImageView.frame = frame;
    }];
    
    if([sender isEqual:self.userMemberLoginButton])
    {
        _userLoginType = UserLoginTypeMember;
        [self.userMemberLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.userNotMemberLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else
    {
        _userLoginType = UserLoginTypeNotMember;
        [self.userMemberLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.userNotMemberLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidUnload
{
    [self setUserMemberLoginButton:nil];
    [self setUserNotMemberLoginButton:nil];
    [self setUserLoginCurrentImageView:nil];
    [self setUserAccountTextField:nil];
    [self setUserPasswordTextField:nil];
    [super viewDidUnload];
}
@end
