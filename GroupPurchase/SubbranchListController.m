//
//  SubbranchListController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-5.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "SubbranchListController.h"
#import "SubbranchListCell.h"
#import "GPWSAPI.h"
#import "Partner.h"
#import "PartnerBranch.h"


NSString *const cellID = @"subbranchListCell.";

NSString *const LookSubbrachDetailNotification = @"LookSubbrachDetailNotification";

@interface SubbranchListController ()
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) NSString *subbrachName;
@end

@implementation SubbranchListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight =  70;
    [self.tableView registerNib:[UINib nibWithNibName:@"SubbranchListCell" bundle:nil] forCellReuseIdentifier:cellID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubbranchListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell.callPhoneButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    
    PartnerBranch *pb = self.dataSource[indexPath.row];
    cell.merchantLabel.text = self.subbrachName;
    cell.merchantDescLabel.text = pb.address;
    cell.distanceLabel.text = pb.phoneNumber;
    cell.callPhoneButton.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController popViewControllerAnimated:NO];
    
    NSDictionary *userInfo = @{@"key":self.dataSource[indexPath.row]};
    [[NSNotificationCenter defaultCenter] postNotificationName:LookSubbrachDetailNotification object:nil userInfo:userInfo];
}

- (void)setProduct:(Product *)product
{
    _product = product;
    
    [GPWSAPI getPartnerWithID:product.infoID success:^(Partner *partner)
    {
        self.subbrachName = partner.title;
        self.dataSource = partner.branchs;
        [self.tableView reloadData];
        
    } faile:^(ErrorType errorType)
    {
        if(AppDel.reach.isReachable){
            Alert(@"获取分店信息失败");
        }else{
            Alert(@"获取分店信息失败，请连接到网络。");
        }
    }];
}

- (void)call:(UIButton *)sender
{
    PartnerBranch *pb = self.dataSource[sender.tag];
    NSString *phoneNumber = nil;
    if(pb.phoneNumber && ![pb.phoneNumber isEqualToString:@""])
    {
        phoneNumber = pb.phoneNumber;
    }
    else if(pb.mobilePhoneNumber && ![pb.mobilePhoneNumber isEqualToString:@""])
    {
        phoneNumber = pb.mobilePhoneNumber;
    }else
    {
        Alert(@"此商家暂时无电话联系方式!");
        return;
    }
    
    BOOL aBool = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]];
    if(!aBool)
    {
        Alert(@"你的设备不支持电话功能");
    }
}
@end
