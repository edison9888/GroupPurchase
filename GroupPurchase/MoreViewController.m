//
//  MoreViewController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-4.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "MoreViewController.h"
#import "UserLoginController.h"
#import "UserRegisterController.h"
#import "UserProfileController.h"
#import "MyCouponListController.h"
#import "AppDelegate.h"
#import "MyFavoriteProductController.h"
#import "HelpController.h"

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *userRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *userLogoutButton;
@property (strong, nonatomic) IBOutlet UIView *call118114View;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@end

@implementation MoreViewController
{
    BOOL _isUserLogin;
    NSArray *_dataSourceForUserLogin, *_dataSourceForUserNotLogin;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"更多";
        self.tabBarItem.title = @"更多";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_bar_more"];
    }
    return self;
}

- (void)viewDidUnload
{
    [self setUserIconImageView:nil];
    [self setUserNicknameLabel:nil];
    [self setUserLoginButton:nil];
    [self setUserRegisterButton:nil];
    [self setUserLogoutButton:nil];
    [self setTableView:nil];
    [self setCall118114View:nil];
    [self setHeaderView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LH_SCREEN_WIDTH, LH_SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    self.tableView.backgroundView = bgView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSBundle mainBundle] loadNibNamed:@"MoreController" owner:self options:nil];
    
    NSArray *a,*b;
    a = @[
          @[
            @{@"icon":@"ziLiao",@"text":@"我的详细资料"},
            @{@"icon":@"youHuiJuan",@"text":@"现金抵用卷"}
           ],
          
          @[
            @{@"icon":@"shouChang",@"text":@"我的收藏"},
            @{@"icon":@"bangZhu",@"text":@"帮助"},
            @{@"icon":@"pingFen",@"text":@"推荐评分"}
           ]
        ];
    
    b = @[
          @{@"icon":@"bangZhu",@"text":@"帮助"},
          @{@"icon":@"pingFen",@"text":@"推荐评分"}
         ];
    
    _dataSourceForUserLogin = a;
    _dataSourceForUserNotLogin = b;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:UserLoginSuccessNotification object:nil];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.call118114View;
    [self refreshUI];
}

- (void)refreshUI
{
    NSString *userName = [[AppDelegate appDelegateInstance].keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    self.userNicknameLabel.text = userName;
    
    if([userName isEqualToString:@""] || [userName isEqual:nil])
    {
        _isUserLogin = NO;
        self.userIconImageView.image = [UIImage imageNamed:@"user_not_login_icon@2x"];
        [self.userLoginButton setImage:[UIImage imageNamed:@"user_more_login_button@2x"] forState:UIControlStateNormal];
        [self.userRegisterButton setImage:[UIImage imageNamed:@"user_more_register_button@2x"] forState:UIControlStateNormal];
        self.userLoginButton.hidden = NO;
        self.userRegisterButton.hidden = NO;
        self.userLogoutButton.hidden = YES;
        
    }else
    {
        _isUserLogin = YES;
        self.userIconImageView.image = [UIImage imageNamed:@"user_login_icon@2x"];
        [self.userLogoutButton setImage:[UIImage imageNamed:@"user_logout_button@2x"] forState:UIControlStateNormal];
        self.userLoginButton.hidden = YES;
        self.userRegisterButton.hidden = YES;
        self.userLogoutButton.hidden = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - Action

- (IBAction)userLogin:(id)sender
{
    UserLoginController *ulc = [[UserLoginController alloc] initWithNibName:@"UserLoginController" bundle:nil];
    [self.navigationController pushViewController:ulc animated:YES];
}

- (IBAction)userRegister:(id)sender
{
    UserRegisterController *urc = [[UserRegisterController alloc] initWithNibName:@"UserRegisterController" bundle:nil];
    [self.navigationController pushViewController:urc animated:YES];
}

- (IBAction)userLogout:(id)sender
{
    [[AppDelegate appDelegateInstance].keychain resetKeychainItem];
    [self refreshUI];
}

- (IBAction)call118114:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"tel:118114"];
    if([[UIApplication sharedApplication] canOpenURL:url] == NO)
    {
        Alert(@"你的设备不支持打电话功能");
        return;
    }
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark -
#pragma mark UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isUserLogin ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isUserLogin)
        return [_dataSourceForUserLogin[section] count];
    else
        return [_dataSourceForUserNotLogin[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellIndetifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dic;
    if(_isUserLogin)
        dic = _dataSourceForUserLogin[indexPath.section][indexPath.row];
    else
        dic = _dataSourceForUserNotLogin[indexPath.row];
    cell.textLabel.text = dic[@"text"];
    cell.imageView.image = [UIImage imageNamed:dic[@"icon"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     
     if(_isUserLogin)
     {
         switch(indexPath.section)
         {
             case 0:
             {
                 switch(indexPath.row)
                 {
                     case 0:
                     {
                         UserProfileController *upc = [[UserProfileController alloc] initWithNibName:@"UserProfileController" bundle:nil];
                         [self.navigationController pushViewController:upc animated:YES];
                         break;
                     }
                     case 1:
                     {
                         MyCouponListController *mclc = [[MyCouponListController alloc] initWithStyle:UITableViewStylePlain];
                         [self.navigationController pushViewController:mclc animated:YES];
                         break;
                     }
                     default:break;
                 }
                 break;
             }   // Section 0
             
             case 1:
             {
                 switch(indexPath.row)
                 {
                     case 0:
                     {
                         MyFavoriteProductController *mfpc = [[MyFavoriteProductController alloc]
                                                              initWithNibName:@"MyFavoriteProductController" bundle:nil];
                         [self.navigationController pushViewController:mfpc animated:YES];
                         break;
                     }
                     case 1:
                     {
                         HelpController *hc = [[HelpController alloc] initWithNibName:@"HelpController" bundle:nil];
                         [self.navigationController pushViewController:hc animated:YES];
                         break;
                     }
                     case 2:
                         //
                     break;
                     default:break;
                 }
                 break;
             } // Section 1
         }
     } // User has Logined
     else
     {
         switch(indexPath.row)
         {
            case 0:
             {
                 HelpController *hc = [[HelpController alloc] initWithNibName:@"HelpController" bundle:nil];
                 [self.navigationController pushViewController:hc animated:YES];
                 break;
             }
                 
             case 1:
                 //
                 break;
            
           default:break;
         }
     }
}
@end
