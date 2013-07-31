//
//  MyCouponListController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-6.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "MyCouponListController.h"
#import "AppDelegate.h"
#import "GPWSAPI.h"
#import "MyCoupanListCell.h"

NSString *const UseCouponNotification = @"UseCouponNotification";

@interface MyCouponListController ()
@property(nonatomic, strong) NSArray *dataSource;
@end

@implementation MyCouponListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的优惠卷";
    
    self.tableView.rowHeight = 63;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCoupanListCell" bundle:nil] forCellReuseIdentifier:@"MyCoupanListCell"];
    
    UserInfo *userInfo = AppDel.userInfo;
    if(userInfo.myCoupons == nil)
    {
        showHudWith(self.view, @"正在获取优惠卷", YES, NO);
        
        [GPWSAPI getMyCouponsWithUserName:UserName couponType:CouponTypeUnuse success:^(NSArray *array) {
            removeHudFromView(self.view);
            
            userInfo.myCoupons = array;
            self.dataSource = array;
            [self.tableView reloadData];
            
        } faile:^(ErrorType errorType) {
            
            userInfo.myCoupons = nil;
            
            if(AppDel.reach.isReachable)
            {
                showHudWith(self.view, @"获取优惠卷失败", NO, YES);
            }else{
                showHudWith(self.view, @"获取优惠卷失败,请连接到网络", NO, YES);
            }
        }];
    }else{
        self.dataSource = userInfo.myCoupons; 
    }
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.dataSource.count == 0 ? 1 : self.dataSource.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCoupanListCell *cell = (MyCoupanListCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCoupanListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if(self.dataSource.count == 0){
        cell.textLabel.text = @"您没有优惠卷";
        return cell;
    }
    
    Coupon *coupon = self.dataSource[indexPath.row];
    cell.coupanNumberLabel.text    = coupon.couponNum;
    cell.coupanPriceLabel.text     = FLOAT_TO_STR(coupon.couponValue);
    cell.coupanStartDateLabel.text = coupon.effectiveDate;
    cell.coupanEndDateLabel.text   = coupon.invalidDate;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.canSelect || !self.dataSource.count)
        return;
    
    NSDictionary *userInfo = @{@"Coupon":self.dataSource[indexPath.row]};
    [[NSNotificationCenter defaultCenter] postNotificationName:UseCouponNotification object:nil userInfo:userInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
