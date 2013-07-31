//
//  PayOrderController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-25.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "PayOrderController.h"
#import "GPWSAPI.h"
#import "AppDelegate.h"
#import "OrderResult.h"
#import "UninoPayResponse.h"
#import "UPOMP_KaMD5.h"
#import "UPOMP_KaRSA.h"
#import "UPOMP_KaBase64.h"
#import "NSDictionary+XMLWriter.h"
#import "XMLDictionary.h"

@interface PayOrderController ()
@property (nonatomic, strong) UPOMP *upompController;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *paySuccesssContainerView;
@property (strong, nonatomic) IBOutlet UIView *payFaileContinaerView;
@property (weak, nonatomic) IBOutlet UILabel *paySuccessOrderIDLabel;

@property (weak, nonatomic) IBOutlet UILabel *payFailResonDesLabel;

@end

@implementation PayOrderController

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
    self.upompController = [UPOMP new];
    self.upompController.viewDelegate = self;
}

- (void)setOrderWapper:(OrderWapper *)orderWapper
{
    _orderWapper = orderWapper;
    
    self.paySuccesssContainerView.hidden = YES;
    self.payFaileContinaerView.hidden = YES;
    self.containerView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    
    [GPWSAPI submitOrderWithAddress:_orderWapper.address
                             cityID:_orderWapper.cityID
                        phoneNumber:_orderWapper.phoneNumber
                          unitPrice:_orderWapper.unitPrice
                            payType:_orderWapper.payType
                         totalPrice:_orderWapper.totalPrice
                           quantity:_orderWapper.quantity
                             remark:_orderWapper.remark
                          productID:_orderWapper.pID
                             userID:_orderWapper.userID
                           receiver:_orderWapper.recevierName
                            zipCode:_orderWapper.zipCode
                           userName:UserName
                           password:Password
                            success:^(OrderResult *orderResult)
                            {
                                [GPWSAPI sendOrderForPhonePayWithOrderNumber:orderResult.orderNumber
                                                                        date:orderResult.orderDate
                                                                         amt:orderResult.price
                                                                        desc:orderResult.desc
                                                                     outDate:orderResult.outDate
                                     success:^(NSString *message)
                                     {
                                         [self.activityIndicatorView stopAnimating];
                                         self.containerView.hidden = YES;
                                         
                                         [[[UIApplication sharedApplication] keyWindow] addSubview:self.upompController.view];
                                         [self.upompController setXmlData:[message dataUsingEncoding:NSUTF8StringEncoding]];
                                         
                                     } faile:^(ErrorType errorType)
                                     {
                                         [self.activityIndicatorView stopAnimating];
                                         self.containerView.hidden = YES;
                                         
                                         if([AppDelegate appDelegateInstance].reach.isReachable == NO)
                                         {
                                             Alert(@"网络连接断开,发送订单失败。");
                                         }else{
                                             Alert(@"服务器发生错误,发送订单失败。");
                                         }
                                     }];
                               
                            } faile:^(ErrorType errorType) {
                                
                                [self.activityIndicatorView stopAnimating];
                                self.containerView.hidden = YES;
                                
                                if([AppDelegate appDelegateInstance].reach.isReachable == NO)
                                {
                                    Alert(@"网络连接断开,提交失败。");
                                }else{
                                    Alert(@"服务器发生错误,提交失败。");
                                }
                            }];
}

-(void)viewClose:(NSData*)data
{
    NSDictionary *dic = [NSDictionary dictionaryWithXMLData:data];
        
    NSString *resCode = dic[@"respCode"];
    NSString *respDesc = dic[@"respDesc"];
    
    if([resCode isEqualToString:@"0000"])
    {
        self.paySuccesssContainerView.hidden = NO;
        self.paySuccessOrderIDLabel.text = [NSString stringWithFormat:@"订单号:%@", dic[@"merchantOrderId"]];
    }else{
        self.payFaileContinaerView.hidden = NO;
        self.payFailResonDesLabel.text = [NSString stringWithFormat:@"失败原因: %@", respDesc];
    }
}

- (IBAction)goBackProductListView:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)payAgain:(id)sender
{
    [self setOrderWapper:self.orderWapper];
}

- (void)viewDidUnload
{
    [self setActivityIndicatorView:nil];
    [self setContainerView:nil];
    [self setPaySuccesssContainerView:nil];
    [self setPayFaileContinaerView:nil];
    [self setPaySuccessOrderIDLabel:nil];
    [self setPayFailResonDesLabel:nil];
    [super viewDidUnload];
}
@end
