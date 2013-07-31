//
//  ProductOrderForLifeController.m
//  GroupPurchase
//
//  Created by xcode on 13-2-25.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "ProductOrderForLifeController.h"
#import "PayOrderForLifeController.h"
#import "AppDelegate.h"
#import "BindPhoneNumberController.h"
#import "RebindPhoneNumberController.h"
#import "GPWSAPI.h"

@interface ProductOrderForLifeController ()

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productUnitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView  *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *puductTotalPriceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *userBindPhoneNumberLabel;

@property (nonatomic, assign) BOOL isBindPhoneNumber;
@end

@implementation ProductOrderForLifeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.backBarButtonItem.title = @"返回";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"提交订单";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"product_list_cell_bg"]];
    
    self.bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)setProduct:(Product *)product
{
    _product = product;
    _product.buyAmount                  = 1;

    self.productNameLabel.text          = _product.shopName;
    self.productUnitPriceLabel.text     = [NSString stringWithFormat:@"%.1f元",_product.priceGroup];
    self.productCountLabel.text         = @"1份";
    self.productTotalPriceLabel.text    = [NSString stringWithFormat:@"%.1f元",_product.priceGroup];
    self.puductTotalPriceLabel2.text    = [NSString stringWithFormat:@"%.1f元",_product.priceGroup];
    
    UserInfo *userInfo = AppDel.userInfo;
    if(userInfo.bindPhone)
    {
        self.isBindPhoneNumber = YES;
        self.userBindPhoneNumberLabel.text = userInfo.bindPhone;
    }else{
        [GPWSAPI getBindPhoneNumberWithUserName:UserName success:^(NSString *number)
        {
            self.isBindPhoneNumber = YES;
            userInfo.bindPhone = number;
            self.userBindPhoneNumberLabel.text = number;
        } faile:^(ErrorType errorType)
        {
            self.isBindPhoneNumber = NO;
        }];
    }
}

- (IBAction)setperValueChanged:(UIStepper *)sender
{
    NSUInteger i = (NSUInteger)sender.value;
    self.productCountLabel.text         = [NSString stringWithFormat:@"%d份",i];
    self.productTotalPriceLabel.text    = [NSString stringWithFormat:@"%.1f元",_product.priceGroup * i];
    self.puductTotalPriceLabel2.text    = [NSString stringWithFormat:@"%.1f元",_product.priceGroup * i];
    _product.buyAmount = i;
}

// 结算
- (IBAction)settlementOrder:(UIButton *)sender
{
    PayOrderForLifeController *pofc = [[PayOrderForLifeController alloc] initWithNibName:@"PayOrderForLifeController" bundle:nil];
    [self.navigationController pushViewController:pofc animated:YES];
    pofc.product = self.product;
}

- (IBAction)rebindPhoneNumber:(id)sender
{
    UIViewController *controller = nil;
    if(self.isBindPhoneNumber)
    {
        controller = [[RebindPhoneNumberController alloc] initWithNibName:@"RebindPhoneNumberController" bundle:nil];
    }else{
        controller = [[BindPhoneNumberController alloc] initWithNibName:@"BindPhoneNumberController" bundle:nil];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidUnload
{
    [self setProductUnitPriceLabel:nil];
    [self setProductCountLabel:nil];
    [self setProductTotalPriceLabel:nil];
    [self setBottomView:nil];
    [self setPuductTotalPriceLabel2:nil];
    [self setUserBindPhoneNumberLabel:nil];
    [super viewDidUnload];
}
@end
