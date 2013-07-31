//
//  ProductOrderForProductController.m
//  GroupPurchase
//
//  Created by xcode on 13-2-25.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "ProductOrderForProductController.h"
#import "PayOrderForProductController.h"
#import "ShippingAddress.h"
#import "AppDelegate.h"
#import "ShippingAddressListController.h"
#import "GPWSAPI.h"

#define Y LH_SCREEN_HEIGHT - LH_STATUS_BAR_HEIGHT - LH_NAVIGATION_BAR_HEIGHT
#define H 170

extern NSString *const ChangeShippingAddressNotification;

@interface ProductOrderForProductController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView  *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productUnitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPostageLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendOutTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendOutNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTotalPriceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *consigneeNameLabel;           
@property (weak, nonatomic) IBOutlet UILabel *consigneePhoneNumberLabel;    
@property (weak, nonatomic) IBOutlet UILabel *consigneeAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *pickerDataSource;
@end

@implementation ProductOrderForProductController

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
   
    self.title = @"提交订单";
    self.pickerDataSource = @[@"时间不限",@"周一至周五送货",@"周六日及公众假期"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"product_list_cell_bg"]];

    self.scrollView.contentSize = CGSizeMake(LH_SCREEN_WIDTH, 490);
    self.bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Y, LH_SCREEN_WIDTH, H)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:self.pickerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleChangeShippingAddressNotification:)
                                                 name:ChangeShippingAddressNotification
                                               object:nil];
}

- (void)setProduct:(Product *)product
{
    _product = product;
    _product.buyAmount = 1;
    
    self.productNameLabel.text          = _product.shopName;
    self.productUnitPriceLabel.text     = [NSString stringWithFormat:@"%.1f元",_product.priceGroup];
    self.productCountLabel.text         = @"1份";
    self.productPostageLabel.text       = [NSString stringWithFormat:@"%.f元",_product.postMoney];
    self.productTotalPriceLabel.text    = [NSString stringWithFormat:@"%.1f元",_product.priceGroup];
    self.productTotalPriceLabel2.text   = [NSString stringWithFormat:@"%.1f元",_product.priceGroup];
    
    UserInfo *userInfo = AppDel.userInfo;
    if(userInfo.shippingAdress == nil)
    {
        [GPWSAPI getShippingAddressWithUserName:UserName success:^(NSArray *jsonObj)
        {
            userInfo.shippingAdress = jsonObj;
            [self updateShippingAddressUI:jsonObj];
        } faile:^(ErrorType errorType)
        {
            if(AppDel.reach.isReachable){
                showHudWith(self.view, @"获取收货地址信息失败，请连接到网络。", NO, YES);
            }else{
                showHudWith(self.view, @"获取收货地址信息失败", NO, YES);
            }
        }];
    }else{
        [self updateShippingAddressUI:userInfo.shippingAdress];
    }
}

// 更新收货地址相关的UI
- (void)updateShippingAddressUI:(NSArray *)addressArray
{
    ShippingAddress *shippingAddress = nil;

    for(ShippingAddress *sa in addressArray)
    {
        if(sa.flag == 1)
        {
            shippingAddress = sa;
            break;
        }
    }
    
    self.consigneeNameLabel.text = shippingAddress.consigneeName;
    self.consigneeAddressLabel.text = shippingAddress.address;
    self.zipCodeLabel.text = shippingAddress.zipCode;
    self.consigneePhoneNumberLabel.text = shippingAddress.moblieNumber;
    
    // 将默认的收货地址对象保存到product中传递给下一个控制器使用
    self.product.sadress = shippingAddress;
    self.product.songHuoRiQi = self.pickerDataSource[0];
}

- (IBAction)setperValueChanged:(UIStepper *)sender
{
    NSUInteger i = (NSUInteger)sender.value;
    self.productCountLabel.text         = [NSString stringWithFormat:@"%d份",i];
    self.productTotalPriceLabel.text    = [NSString stringWithFormat:@"%.1f元",_product.priceGroup * i];
    self.productTotalPriceLabel2.text    = [NSString stringWithFormat:@"%.1f元",_product.priceGroup * i];
    self.product.buyAmount = i;
}

- (IBAction)settlementOrder:(id)sender
{
    PayOrderForProductController *popc = [[PayOrderForProductController alloc] initWithNibName:@"PayOrderForProductController" bundle:nil];
    [self.navigationController pushViewController:popc animated:YES];
    popc.product = self.product;
}

// 改变收货地址
- (IBAction)changeShippingAddress:(id)sender
{
    ShippingAddressListController *sal = [[ShippingAddressListController alloc]
                                          initWithNibName:@"ShippingAddressListController" bundle:nil];
    [self.navigationController pushViewController:sal animated:YES];
}

// 选择收货时间
- (IBAction)rewriteRemark:(id)sender
{
    [self showorHidePickerView];
}

- (void)showorHidePickerView
{
    BOOL static isShow = NO;
    
    CGRect f = self.pickerView.frame;
    if(!isShow)
    {
        f.origin.y = Y - H;
    }else{
        f.origin.y = Y;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.frame = f;
    } completion:^(BOOL finished) {
        isShow = !isShow;
    }];
}

#pragma mark - PickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark - PickerView Delegate


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerDataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 将收货时间保存到product对象传递给下一个控制器
    self.product.songHuoRiQi = self.remarkLabel.text;
    self.remarkLabel.text = self.pickerDataSource[row];
    [self showorHidePickerView];
}


#pragma mark - 处理通知

- (void)handleChangeShippingAddressNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    ShippingAddress *sa = userInfo[@"key"];
    self.consigneeAddressLabel.text = sa.address;
    self.consigneeNameLabel.text = sa.consigneeName;
    self.consigneeAddressLabel.text = sa.address;
    self.zipCodeLabel.text = sa.zipCode;
    self.consigneePhoneNumberLabel.text = sa.moblieNumber;
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setBottomView:nil];
    [self setProductNameLabel:nil];
    [self setProductUnitPriceLabel:nil];
    [self setProductCountLabel:nil];
    [self setProductPostageLabel:nil];
    [self setProductTotalPriceLabel:nil];
    [self setCustomerNameLabel:nil];
    [self setCustomerPhoneLabel:nil];
    [self setCustomerAddressLabel:nil];
    [self setSendOutTimeLabel:nil];
    [self setSendOutNoteLabel:nil];
    [self setProductTotalPriceLabel2:nil];
    [self setConsigneeNameLabel:nil];
    [self setConsigneePhoneNumberLabel:nil];
    [self setConsigneeAddressLabel:nil];
    [self setZipCodeLabel:nil];
    [self setRemarkLabel:nil];
    [super viewDidUnload];
}
@end
