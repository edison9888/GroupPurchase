//
//  ProductDetailController.m
//  GroupPurchase
//
//  Created by xcode on 13-1-31.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "ProductDetailController.h"
#import "Product.h"
#import "UIImageView+WebCache.h"
#import "ProductOrderForLifeController.h"
#import "ProductOrderForProductController.h"
#import "UserLoginController.h"
#import "StrikeThroughLabel.h"
#import "SVPullToRefresh.h"
#import "AppDelegate.h"
#import "GPWSAPI.h"
#import "KeychainItemWrapper.h"
#import "SubbranchListController.h"
#import "PartnerBranch.h"
#import "DataManager.h"
#import "MBProgressHUD.h"
#import "MapViewController.h"

extern NSString *const LookSubbrachDetailNotification;
extern NSString *const UserLoginSuccessNotification;

@interface ProductDetailController ()

@property (weak,    nonatomic)   IBOutlet UIScrollView          *scrollView;
@property (weak,    nonatomic)   IBOutlet UIImageView           *productTitleImageView;
@property (weak,    nonatomic)   IBOutlet StrikeThroughLabel    *productCostPriceLable;
@property (weak,    nonatomic)   IBOutlet UILabel               *productNotVIPPriceLabel;
@property (weak,    nonatomic)   IBOutlet UILabel               *productVIPPriceLabel;
@property (weak,    nonatomic)   IBOutlet UILabel               *userAmountLabel;
@property (weak,    nonatomic)   IBOutlet UILabel               *countDownLabel;
@property (weak,    nonatomic)   IBOutlet UILabel               *productDescribe;
@property (strong,  nonatomic)   IBOutlet UIView                *merchantInformationView;
@property (weak,    nonatomic)   IBOutlet UILabel               *merchanAreaLabel;
@property (weak,    nonatomic)   IBOutlet UILabel               *merchantAddressLabel;
@property (weak,    nonatomic)   IBOutlet UILabel               *merchantTelphoneLabel;
@property (strong,  nonatomic)   IBOutlet UIView                *mealPackageView;
@property (weak,    nonatomic)   IBOutlet UIWebView             *mealPackageWebView;
@property (strong,  nonatomic)   IBOutlet UIView                *buyTipsView;
@property (weak,    nonatomic)   IBOutlet UIWebView             *buyTipsWebView;
@property (strong,  nonatomic)   IBOutlet UIButton              *buyNowBigButton;
@property (strong,  nonatomic) UIButton *favoriteButton;

@end


@implementation ProductDetailController
{
    NSDate *_lastRefreshProductListDate;
    CGFloat leftMargin, yOffset, yOffsetIncrement;
    CGRect frame;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"商品详情";
         self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showFavoriteButton = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"product_list_cell_bg"]];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"product_list_cell_bg"]];
    
    _lastRefreshProductListDate = [NSDate date];
    
    self.mealPackageWebView.scrollView.bounces = NO;
    self.buyTipsWebView.scrollView.bounces = NO;
    
    // 收藏,分享
    UIButton *sharedButton;
    _favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sharedButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect    =CGRectMake(0, 0, 40, 40);
    _favoriteButton.frame = rect;
    sharedButton.frame   = rect;
    [_favoriteButton setImage:[UIImage imageNamed:@"mylove_default"] forState:UIControlStateNormal];
    [_favoriteButton setImage:[UIImage imageNamed:@"mylove_pressed"] forState:UIControlStateHighlighted];
    [_favoriteButton addTarget:self action:@selector(collectProduct) forControlEvents:UIControlEventTouchUpInside];
    [sharedButton setImage:[UIImage imageNamed:@"nav_bar_product_shared"] forState:UIControlStateNormal];
    UIBarButtonItem *favoriteItem, *sharedItem;
    favoriteItem = [[UIBarButtonItem alloc] initWithCustomView:_favoriteButton];
    sharedItem   = [[UIBarButtonItem alloc] initWithCustomView:sharedButton];
    self.navigationItem.rightBarButtonItems = @[favoriteItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handelLookSubbrachDetailNotification:)
                                                 name:LookSubbrachDetailNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handelUserLoginSuccessNotification)
                                                 name:UserLoginSuccessNotification
                                               object:nil];
    
    [self.scrollView addPullToRefreshWithActionHandler:^{
        [self refresh];
    }];
    [self.scrollView.pullToRefreshView setTitle:@"下拉即可刷新..." forState:SVPullToRefreshStateStopped];
    [self.scrollView.pullToRefreshView setTitle:@"刷新中..." forState:SVPullToRefreshStateLoading];
    [self.scrollView.pullToRefreshView setTitle:@"松开即可刷新..." forState:SVPullToRefreshStateTriggered];
}

- (void)updateUI:(Product *)product
{
    [self.scrollView addSubview:self.merchantInformationView];

    [self.productTitleImageView setImageWithURL:[NSURL URLWithString:product.tImg]
                               placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
    {
        
    }];
    
    self.productCostPriceLable.text     = FLOAT_TO_STR(product.priceGoods);
    self.productNotVIPPriceLabel.text   = FLOAT_TO_STR(product.priceNonMember);
    self.productVIPPriceLabel.text      = FLOAT_TO_STR(product.priceGroup);
    self.userAmountLabel.text           = [NSString stringWithFormat:@"%d人已购买",product.sumBuyQty];
    self.countDownLabel.text            = product.endDate;
    self.merchanAreaLabel.text          = product.shopName;
    self.merchantAddressLabel.text      = [NSString stringWithFormat:@"地址:%@",product.address];
    self.merchantTelphoneLabel.text     = [NSString stringWithFormat:@"电话:%@",([product.phone isEqualToString:@""] ? @"暂无" : product.phone)];
    self.productDescribe.text           = product.description;
    
    [self.mealPackageWebView loadHTMLString:product.contPackage baseURL:nil];
    [self.buyTipsWebView     loadHTMLString:product.buyTip      baseURL:nil];
    
    // 调整UI位置
    
    frame = self.productDescribe.frame;
    frame.size.height = [self heightForString:product.description fontSize:15 andWidth:frame.size.width];
    self.productDescribe.frame = frame;
    
    leftMargin = 5, yOffset = 0.0, yOffsetIncrement = 30;

    yOffset = frame.origin.y + frame.size.height + yOffsetIncrement-15;
    frame = self.merchantInformationView.frame;
    frame.origin.y = yOffset;
    frame.origin.x = leftMargin;
    self.merchantInformationView.frame = frame;
}

/* 调整UI的位置.
   因为我们需要使用WebView中内容的高度来调整UI位置(Y轴的偏移),
   然而要在UIWebView将内容加载完成后才能知道WebView中内容的高度,
   所以我们在此方法中调整UI的位置.
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    static NSInteger count = 0;
    count++;
    
    // 等待两个UIWebView(分别用于呈现套餐内容和购买提示)都加载完成才重新调整UI的位置
    if(count == 1) return;  
    count = 0;
    
    UIScrollView *scrollView = self.mealPackageWebView.scrollView;
    yOffset = frame.origin.y + frame.size.height + yOffsetIncrement*2;
    frame = self.mealPackageView.frame;
    frame.size.height = scrollView.contentSize.height;
    frame.origin.y = yOffset;
    frame.origin.x = leftMargin;
    self.mealPackageView.frame = frame;
    
    CGRect webFrame = self.mealPackageWebView.frame;
    webFrame.size.height = scrollView.contentSize.height;
    self.mealPackageWebView.frame = webFrame;
    
    scrollView = self.buyTipsWebView.scrollView;
    yOffset = frame.origin.y + frame.size.height + yOffsetIncrement*2.5;
    frame = self.buyTipsView.frame;
    frame.size.height = scrollView.contentSize.height;
    frame.origin.y = yOffset;
    frame.origin.x = leftMargin;
    self.buyTipsView.frame = frame;
    
    webFrame = self.buyTipsWebView.frame;
    webFrame.size.height = scrollView.contentSize.height;
    self.buyTipsWebView.frame = webFrame;
    
    yOffset = frame.origin.y + frame.size.height + yOffsetIncrement*2.5;
    frame = self.buyNowBigButton.frame;
    frame.origin.y = yOffset;
    frame.origin.x = leftMargin;
    self.buyNowBigButton.frame = frame;
    
    self.scrollView.contentSize = CGSizeMake(LH_SCREEN_WIDTH, frame.origin.y+frame.size.height+yOffsetIncrement);
}

- (void)setProduct:(Product *)product
{
    _product = product;
    [self getProductDetailWithProductID:self.product.ID];
}

- (void)getProductDetailWithProductID:(NSInteger)priductID
{
    showHudWith(self.view, @"正在加载", YES, NO);
    
    [GPWSAPI getProductDetailInfomationWithProductID:_product.ID success:^(Product *pro)
     {
         removeHudFromView(self.view);
         [self updateUI:pro];
         
     } faile:^(ErrorType errorType)
     {
         if([AppDelegate appDelegateInstance].reach.isReachable == NO)
         {
             showHudWith(self.view, @"网络连接断开", NO, YES);
         }else{
             showHudWith(self.view, @"加载失败,服务器出错", NO, YES);
         }
     }];
}

- (void)handelNetConnectonBreakError
{
    [self getProductDetailWithProductID:self.product.ID];
}

- (void)setShowFavoriteButton:(BOOL)showFavoriteButton
{
    _showFavoriteButton = showFavoriteButton;
    if(_showFavoriteButton == NO)
        self.navigationItem.rightBarButtonItems = @[];
}

- (void)refresh
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *date = [formatter stringFromDate:_lastRefreshProductListDate];
    date = [NSString stringWithFormat:@"上次更新 %@",date];
    [self.scrollView.pullToRefreshView setSubtitle:date forState:SVPullToRefreshStateLoading];
    _lastRefreshProductListDate = [NSDate date];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.scrollView.pullToRefreshView stopAnimating];
    });
}

- (CGFloat) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return sizeToFit.height;
}

#pragma mark - Action

// 立即购买
- (IBAction)buyNow:(id)sender
{
    BOOL isUserLogin;
    NSString *userName = UserName;
    
    if([userName isEqualToString:@""] || [userName isEqual:nil]){
        isUserLogin = NO;
    }else{
        isUserLogin = YES;
    }
    
    if(isUserLogin)
    {
        UserLoginType t = getUserLoginType();
        if(t == UserLoginTypeNotMember){
            self.product.priceGroup = self.product.priceNonMember;
        }
        
        // 根据商品的不同类型进入不同的订单界面
        if(self.product.type == 2)
        {
            ProductOrderForLifeController *polc;
            polc = [[ProductOrderForLifeController alloc] initWithNibName:@"ProductOrderForLifeController" bundle:nil];
            [self.navigationController pushViewController:polc animated:YES];
            polc.product = self.product;
        }
        // 商品(包括特惠)
        else
        {
            ProductOrderForProductController *popc;
            popc = [[ProductOrderForProductController alloc] initWithNibName:@"ProductOrderForProductController" bundle:nil];
            [self.navigationController pushViewController:popc animated:YES];
            popc.product = self.product;
        }
        
    }
    // 提示用户注册或登陆
    else
    {
        UserLoginController *ulc = [[UserLoginController alloc] initWithNibName:@"UserLoginController" bundle:nil];
        [self.navigationController pushViewController:ulc animated:YES];
    }
}

// 查看分店
- (IBAction)viewSubbranch:(id)sender
{
    SubbranchListController *slc = [[SubbranchListController alloc] initWithNibName:@"SubbranchListController" bundle:nil];
    [self.navigationController pushViewController:slc animated:YES];
    slc.product = self.product;
}

- (void)collectProduct
{
   [DataManager collectProdcut:self.product result:^(BOOL rect) {
       NSString *text = rect ? @"收藏成功" : @"已经收藏";
       showHudWith(self.view, text, NO,YES);
       
   }];
}

- (IBAction)viewMap:(id)sender
{
    MapViewController *mvc = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    [self.navigationController pushViewController:mvc animated:YES];
    [mvc showProductLocation:self.product];
}

#pragma mark - 处理通知

- (void)handelLookSubbrachDetailNotification:(NSNotification *)notification
{
     [self.scrollView scrollRectToVisible:CGRectMake(0, 0, LH_SCREEN_WIDTH,
                                                    LH_SCREEN_HEIGHT-LH_STATUS_BAR_HEIGHT-LH_NAVIGATION_BAR_HEIGHT) animated:YES];
    
    PartnerBranch *pb = notification.userInfo[@"key"];
    [GPWSAPI getProductDetailInfomationWithProductID:pb.ID success:^(Product *pro)
     {
        [self updateUI:pro];
     } faile:^(ErrorType errorType)
     {
         NSLog(@"Get product detail information failed! Please check your network connection!");
     }];
}

- (void)handelUserLoginSuccessNotification
{
    [self buyNow:nil];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setProductCostPriceLable:nil];
    [self setProductNotVIPPriceLabel:nil];
    [self setProductVIPPriceLabel:nil];
    [self setUserAmountLabel:nil];
    [self setCountDownLabel:nil];
    [self setProductDescribe:nil];
    [self setProductTitleImageView:nil];
    [self setMerchantInformationView:nil];
    [self setMerchanAreaLabel:nil];
    [self setMerchantAddressLabel:nil];
    [self setMerchantTelphoneLabel:nil];
    [self setMealPackageView:nil];
    [self setBuyTipsView:nil];
    [self setBuyTipsWebView:nil];
    [self setMealPackageWebView:nil];
    [self setBuyNowBigButton:nil];
    [super viewDidUnload];
}

@end
