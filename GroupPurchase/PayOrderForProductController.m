//
//  PayOrderForProductController.m
//  GroupPurchase
//
//  Created by xcode on 13-2-25.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "PayOrderForProductController.h"
#import "MyCouponListController.h"
#import "Coupon.h"
#import "PayOrderController.h"
#import "GPWSAPI.h"

extern NSString *const UseCouponNotification;

@interface PayOrderForProductController ()
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *postageLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAccountBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mustPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTotalPriceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *sendOutTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendOutAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *couponValueLabel;

@property (weak, nonatomic) IBOutlet UIButton *unionPayButton;
@property (weak, nonatomic) IBOutlet UIButton *audioPayButton;

@property (assign, nonatomic) BOOL usingUnidoPay;

@property (weak, nonatomic) IBOutlet UILabel *songHuoShiJianLabel;
@property (weak, nonatomic) IBOutlet UILabel *songHuoDiZhiLabel;

@end

@implementation PayOrderForProductController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"订单支付";
    self.usingUnidoPay = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"product_list_cell_bg"]];
    
    self.scrollView.contentSize = CGSizeMake(LH_SCREEN_WIDTH, 650);
    self.bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelUseCouponNotification:) name:UseCouponNotification object:nil];
}

- (void)setProduct:(Product *)product
{
    _product = product;
    
    self.productNameLabel.text          = _product.shopName;
    self.productCountLabel.text         = [NSString stringWithFormat:@"%d份", _product.buyAmount];
    self.postageLabel.text              = [NSString stringWithFormat:@"%.1f元",_product.postMoney];
    self.productTotalPriceLabel.text    = [NSString stringWithFormat:@"%.1f元",(_product.priceGroup * _product.buyAmount)];
    self.productTotalPriceLabel2.text   = self.productTotalPriceLabel.text;
    
    self.songHuoDiZhiLabel.text = self.product.sadress.address;
    self.songHuoShiJianLabel.text = self.product.songHuoRiQi;
    
    UserInfo *userInfo = AppDel.userInfo;
    if(userInfo.userLoginedInfo == nil)
    {
        [GPWSAPI getLoginUserInfoWithUserName:UserName userPassword:Password success:^(UserHasLoginedInfo *userInfoObj)
        {
            userInfo.userLoginedInfo = userInfoObj;
            self.userAccountBalanceLabel.text = [NSString stringWithFormat:@"%.1f元", userInfo.userLoginedInfo.accountBalance];
        } faile:^(ErrorType errorType)
        {
            NSLog(@"获取用户余额失败");
            if(AppDel.reach.isReachable){
                //showHudWith(self.view, @"获取用户余额失败", NO, YES);
            }else{
                //showHudWith(self.view, @"获取用户余额失败", NO, YES);
            }
        }];
    }else{
        self.userAccountBalanceLabel.text = [NSString stringWithFormat:@"%f元", userInfo.userLoginedInfo.accountBalance];
    }
    
}

// 使用银联支付
- (IBAction)usingUnionPay:(UIButton *)sender
{
    self.usingUnidoPay = YES;
    [self.unionPayButton setImage:[UIImage imageNamed:@"union_pay_selected"] forState:UIControlStateNormal];
    [self.audioPayButton setImage:[UIImage imageNamed:@"audio_pay"] forState:UIControlStateNormal];
}

// 使用语音支付
- (IBAction)usingAudioPay:(id)sender
{
    self.usingUnidoPay = NO;
    [self.unionPayButton setImage:[UIImage imageNamed:@"union_pay"] forState:UIControlStateNormal];
    [self.audioPayButton setImage:[UIImage imageNamed:@"audio_pay_selected"] forState:UIControlStateNormal];
    
    UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:@"您选择了语音支付,请拨打客服电话,选择订单支付,并按语音提示进行操作。"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"呼叫118114",@"取消",nil];
    [sheet showInView:self.view];
}

// 使用优惠卷
-(IBAction)useCoupon:(id)sender
{
    MyCouponListController *mclc = [[MyCouponListController alloc] initWithStyle:UITableViewStylePlain];
    mclc.canSelect = YES;
    [self.navigationController pushViewController:mclc animated:YES];
}

// 提交支付
- (IBAction)payOrder:(id)sender
{
    if(self.usingUnidoPay == NO)
    {
        Alert(@"请选择使用银联支付");
        return;
    }
    
    OrderWapper *wapper = [OrderWapper shareInstance];
    wapper.pID = INT_TO_STR(self.product.ID);
    wapper.userID = UserName;
    wapper.recevierName = wapper.userID;
    wapper.phoneNumber = AppDel.userInfo.bindPhone;
    wapper.unitPrice = self.product.priceGroup;
    wapper.payType = 3;
    wapper.totalPrice = self.product.priceGroup * self.product.buyAmount;
    wapper.quantity = self.product.buyAmount;
    
    PayOrderController *poc = [[PayOrderController alloc] initWithNibName:@"PayOrderController" bundle:nil];
    [self.navigationController pushViewController:poc animated:YES];
    poc.orderWapper = wapper;
}

- (void)handelUseCouponNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    Coupon *coupon = userInfo[@"Coupon"];
    self.couponValueLabel.text = FLOAT_TO_STR(coupon.couponValue);
    
    CGFloat payable = 0;
    if(coupon.couponValue < self.product.payable)
    {
        payable = self.product.payable - coupon.couponValue;
        self.product.payable = payable;
    }
    self.mustPayLabel.text = [NSString stringWithFormat:@"%.1f元", self.product.payable];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        BOOL ret = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:118114"]];
        if(ret == NO){
            [self usingUnionPay:nil];
            Alert(@"你的设备不支持拨打电话!");
        }
    }
}

- (void)viewDidUnload
{
    [self setProductNameLabel:nil];
    [self setProductCountLabel:nil];
    [self setProductTotalPriceLabel:nil];
    [self setPostageLabel:nil];
    [self setUserAccountBalanceLabel:nil];
    [self setMustPayLabel:nil];
    [self setProductTotalPriceLabel2:nil];
    [self setSendOutTimeLabel:nil];
    [self setSendOutAddressLabel:nil];
    [self setBottomView:nil];
    [self setScrollView:nil];
    [self setCouponValueLabel:nil];
    [self setUnionPayButton:nil];
    [self setAudioPayButton:nil];
    [self setSongHuoShiJianLabel:nil];
    [self setSongHuoDiZhiLabel:nil];
    [super viewDidUnload];
}
@end
