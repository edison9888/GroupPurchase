//
//  OrdersController.m
//  GroupPurchase
//
//  Created by xcode on 13-1-10.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "OrdersController.h"
#import "MyOrderListCell.h"
#import "GPWSAPI.h"
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"
#import "MyOrder.h"
#import "UserLoginController.h"
#import "PayOrderForLifeController.h"
#import "Product.h"
#import "RefundController.h"

extern NSString *const UserLoginSuccessNotification;

@interface OrdersController ()
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, assign) PaymentStatus ps;
@end

@implementation OrdersController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订单";
        self.tabBarItem.title = @"订单";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_bar_order"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[OrderTopBar showOrderTopBarInView:self.view withDelegate:self];
    [OrderSegementBar showOrderSegementBarInView:self.view withDelegate:self];
    
    CGFloat y = LH_SCREEN_HEIGHT-LH_STATUS_BAR_HEIGHT-LH_NAVIGATION_BAR_HEIGHT-LH_TAB_BAR_HEIGHT-OrderSegementBarHeight;
    CGRect f = CGRectMake(0, OrderSegementBarHeight, LH_SCREEN_WIDTH, y);
    self.tableView = [[UITableView alloc] initWithFrame:f style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 104;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderListCell" bundle:nil] forCellReuseIdentifier:@"MyOrderListCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handelUserLoginSuccessNotification)
                                                 name:UserLoginSuccessNotification
                                               object:nil];

    self.ps = PaymentStatusNotPay;
    [self getMyOrderWithPayState:self.ps];
}

- (void)getMyOrderWithPayState:(PaymentStatus)ps
{
    NSString *userName = [[AppDelegate appDelegateInstance].keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    if([userName isEqualToString:@""] || [userName isEqual:nil])
    {
        UserLoginController *ulc = [[UserLoginController alloc] initWithNibName:@"UserLoginController" bundle:nil];
        ulc.fromMyOrderListController = YES;
        [self.navigationController pushViewController:ulc animated:YES];
        return;
    }
        
    [GPWSAPI getMyOrdersWithUserName:userName payStatus:ps success:^(NSArray *array) {
        self.dataSource = array;
        [self.tableView reloadData];
    } faile:^(ErrorType errorType) {
        NSLog(@"获取我的订单失败:%d", errorType);
        showHudWith(self.view, @"获取订单失败", NO, YES);
    }];
}

- (void)handelUserLoginSuccessNotification
{
    [self getMyOrderWithPayState:self.ps];
}

- (void)didSelectedOrderTopBarAtIndex:(NSInteger)index
{
   
}

- (void)didSelectedOrderSegementBarAtIndex:(NSInteger)index
{
    switch(index)
    {
        case 1: self.ps = PaymentStatusNotUse;   break;
        case 2: self.ps = PaymentStatusused;     break;
        case 3: self.ps = PaymentStatusRefunded; break;
        case 4: self.ps = PaymentStatusOutDate;  break;
        default:
            self.ps = PaymentStatusNotPay;       break;
    }
    
    [self getMyOrderWithPayState:self.ps];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderListCell"];
    
    MyOrder *order = self.dataSource[indexPath.row];
    cell.productNameLabel.text = order.productName;
    cell.productCountLabel.text = [NSString stringWithFormat:@"%d份",order.productCount];
    cell.productTotalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",order.productCount*order.productVIPPrice];
    cell.dateLabel.text = [NSString stringWithFormat:@"过期日期:%@",order.outDate];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MyOrder *order = self.dataSource[indexPath.row];
   PayOrderForLifeController *poflc = [[PayOrderForLifeController alloc] initWithNibName:@"PayOrderForLifeController" bundle:nil];

    switch(self.ps)
    {
        case PaymentStatusNotPay:
        case PaymentStatusNotUse:
        case PaymentStatusused:
        {
            Product *product = [[Product alloc] init];
            product.shopName = order.productName;
            product.buyAmount = order.productCount;
            product.priceGroup = order.productVIPPrice;
            
            [self.navigationController pushViewController:poflc animated:YES];
            poflc.product = product;
            
            break;
        }
        case PaymentStatusRefunded:
        {
            RefundController *rc = [[RefundController alloc] initWithNibName:@"RefundController" bundle:nil];
            [self.navigationController pushViewController:rc animated:YES];
            rc.order = self.dataSource[indexPath.row];

            break;
        }
        case PaymentStatusOutDate:
        {
            RefundController *rc = [[RefundController alloc] initWithNibName:@"RefundController" bundle:nil];
            rc.usingForOutDateController = YES;
            [self.navigationController pushViewController:rc animated:YES];
            rc.order = self.dataSource[indexPath.row];
            break;
        }
        default:break;
    }
}

@end
