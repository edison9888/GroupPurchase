//
//  UserRegisterController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-1.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "UserRegisterController.h"
#import "GPWSAPI.h"
#import "KeychainItemWrapper.h"
#import "AppDelegate.h"

#define RestContentViewPostion()                \
[UIView animateWithDuration:0.3 animations:^    \
{                                               \
    CGRect frame = self.contentView.frame;      \
    frame.origin.y = 0;                         \
    self.contentView.frame = frame;             \
}]

@interface UserRegisterController ()
@property (weak, nonatomic) IBOutlet UIImageView *userLoginCurrentImageView;
@property (weak, nonatomic) IBOutlet UIButton *userResiterMemberButton;
@property (weak, nonatomic) IBOutlet UIButton *userRegisterNotMemberButton;
@property (weak, nonatomic) IBOutlet UIImageView *registerMemberHitsImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *registerNotMemberFormView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation UserRegisterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"用户注册";
    }
    return self;
}

- (void)viewDidUnload
{
    [self setUserLoginCurrentImageView:nil];
    [self setUserResiterMemberButton:nil];
    [self setUserRegisterNotMemberButton:nil];
    [self setRegisterMemberHitsImageView:nil];
    [self setScrollView:nil];
    [self setContentView:nil];
    [self setEmailTextField:nil];
    [self setNicknameTextField:nil];
    [self setPasswordTextField:nil];
    [self setRepeatPasswordTextField:nil];
    [self setRegisterNotMemberFormView:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.registerMemberHitsImageView.userInteractionEnabled = NO;
    self.scrollView.contentSize = CGSizeMake(LH_SCREEN_WIDTH, 550);
    
    [GPWSAPI getRegisterTipsOnSuccess:^(NSString *htmlText) {
        [self.webView loadHTMLString:htmlText baseURL:nil];
    } onFail:^{
        Alert(@"获取注册方法信息失败");
    }];
}

- (IBAction)tapOnScrollView:(id)sender
{
    RestContentViewPostion();
    [self.view endEditing:YES];
}

- (IBAction)switchUserReisterType:(UIButton *)sender
{
    CGFloat duration = 0.0;
    [UIView animateWithDuration:duration animations:^
     {
         CGRect frame = self.userLoginCurrentImageView.frame;
         frame.origin.x = CGRectGetMinX(sender.frame);
         self.userLoginCurrentImageView.frame = frame;
     }];
    
    if([sender isEqual:self.userResiterMemberButton])
    {
        [self.view endEditing:YES];
        [self.userResiterMemberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.userRegisterNotMemberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
        
        [UIView animateWithDuration:duration animations:^
        {
            CGRect frame1, frame2;
            
            frame1 = self.registerMemberHitsImageView.frame;
            frame1.origin.x = 10;
            self.registerMemberHitsImageView.frame = frame1;
            self.webView.frame = frame1;
            
            frame2 = self.registerNotMemberFormView.frame;
            frame2.origin.x = -330;
            self.registerNotMemberFormView.frame = frame2;
        }];
    }
    else
    {
        //[self.emailTextField becomeFirstResponder];
        [self.userResiterMemberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.userRegisterNotMemberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //self.scrollView.contentSize = CGSizeMake(LH_SCREEN_WIDTH, LH_SCREEN_HEIGHT-LH_STATUS_BAR_HEIGHT-LH_NAVIGATION_BAR_HEIGHT-LH_TAB_BAR_HEIGHT);
        
        [UIView animateWithDuration:duration animations:^
        {
            CGRect frame1, frame2;
            frame1 = self.registerMemberHitsImageView.frame;
            frame1.origin.x = 330;
            self.registerMemberHitsImageView.frame = frame1;
            self.webView.frame = frame1;
            
            frame2 = self.registerNotMemberFormView.frame;
            frame2.origin.x = 10;
            self.registerNotMemberFormView.frame = frame2;
        }];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;         
{
}

- (IBAction)userReigister:(id)sender
{
    RestContentViewPostion();
    [self.view endEditing:YES];
    
    NSString *email, *nickname, *password, *repeatPassword;
    email = self.emailTextField.text;
    nickname = self.nicknameTextField.text;
    password = self.passwordTextField.text;
    repeatPassword = self.repeatPasswordTextField.text;
    
    if(!email.length)
    {
        Alert(@"请输入用户名");
        return;
    }
        
    if(!nickname.length)
    {
        Alert(@"请输入昵称");
        return;
    }
    
    if(password.length < 6)
    {
        Alert(@"至少输入6位密码");
        return;
    }
    
    if(repeatPassword.length < 6)
    {
        Alert(@"至少输入6位密码");
        return;
    }
    
    if(![password isEqualToString:repeatPassword])
    {
        Alert(@"两次密码输入不一致");
        return;
    }
    
    [GPWSAPI userRegisterWithUserName:email password:password nickname:nickname success:^(BOOL aBool, NSString *message)
     {
        if(aBool)
        {            
            saveUserName(email);
            saveUserPassword(password);
            
            // 由MoreControll处理此通知来更新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccessNotification object:nil];
            Alert(@"注册成功");
        }else
        {
            Alert(@"注册失败");
        }
    } faile:^(ErrorType errorType)
    {
        Alert(@"注册失败");
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    RestContentViewPostion();
}

@end
