//
//  RefundController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-19.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "RefundController.h"
#import "GPWSAPI.h"
#import "ProductDetailController.h"
#import "RefundOperationController.h"
#import "Product.h"
#import "Partner.h"

@interface RefundController ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *verCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelRefundButton;
@property (weak, nonatomic) IBOutlet UIButton *applicationRefundButton;
@property (weak, nonatomic) IBOutlet UIButton *buyAgainButton;

@end

@implementation RefundController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(LH_SCREEN_WIDTH, self.containerView.bounds.size.height);
    
    if(self.usingForOutDateController)
    {
        self.cancelRefundButton.hidden = YES;
    }else{
        self.applicationRefundButton.hidden = YES;
        self.buyAgainButton.hidden = YES;
    }
}

- (void)setOrder:(MyOrder *)order
{
    _order = order;
    
    // 若退款状态不是退款处理中,则隐藏取消退款按钮
    if(_order.payState != PaymentStatusRefunding)
        self.cancelRefundButton.hidden = YES;
    
    NSString *refundState;
    if(_order.payState == PaymentStatusRefunded)
        refundState = @"已经退款";
    else if (_order.payState == PaymentStatusRefunding)
        refundState = @"退款处理中";
    else if(_order.payState == PaymentStatusRefundReject)
        refundState = @"拒绝退款";
    else if(_order.payState == PaymentStatusOutDate)
        refundState = @"已过期";
    else
        refundState = @"未知状态";
    
    NSString *orderNumber = order.orderNumber;
    self.orderNumberLabel.text      = orderNumber;
    self.refundStateLabel.text      = refundState;
    self.productNameLabel.text      = order.productName;
    self.verCodeLabel.text          = order.verCode;
    self.purchaseQuantityLabel.text = INT_TO_STR(order.productCount);
    self.priceLabel.text            = FLOAT_TO_STR(order.productVIPPrice * order.productVIPPrice);
    
    [GPWSAPI getPartnerWithID:self.order.infoID success:^(Partner *partner)
    {
        NSLog(@"->%@ %d", partner.userName,partner.branchs.count);
    } faile:^(ErrorType errorType) {
        
    }];
    
}

// 取消退款
- (IBAction)cancelRefund:(id)sender
{
    
}

// 申请退款
- (IBAction)applicationRefund:(UIButton *)sender
{
    RefundOperationController *roc = [[RefundOperationController alloc] initWithNibName:@"RefundOperationController" bundle:nil];
    [self.navigationController pushViewController:roc animated:YES];
    roc.order = self.order;
}

// 重新购买
- (IBAction)buyAgainButton:(UIButton *)sender
{
    Product *prodcut = [Product new];
    prodcut.ID = self.order.prodcutID;
    
    ProductDetailController *pdc = [[ProductDetailController alloc] initWithNibName:@"ProductDetailController" bundle:nil];
    [self.navigationController pushViewController:pdc animated:YES];
    pdc.product = prodcut;
}

- (void)viewDidUnload
{
    [self setOrderNumberLabel:nil];
    [self setRefundStateLabel:nil];
    [self setProductNameLabel:nil];
    [self setVerCodeLabel:nil];
    [self setPurchaseQuantityLabel:nil];
    [self setCouponLabel:nil];
    [self setPriceLabel:nil];
    [self setMerchantLabel:nil];
    [self setAddressLabel:nil];
    [self setTelphoneLabel:nil];
    [self setOrderNumberLabel:nil];
    [self setScrollView:nil];
    [self setContainerView:nil];
    [self setCancelRefundButton:nil];
    [self setApplicationRefundButton:nil];
    [self setBuyAgainButton:nil];
    [super viewDidUnload];
}
@end
