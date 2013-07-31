//
//  ShippingAddressListController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-13.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "ShippingAddressListController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "GPWSAPI.h"
#import "KeychainItemWrapper.h"
#import "ShippingAddress.h"
#import "ShippingAddressCell.h"
#import "NewShippingAddressController.h"

NSString *const ChangeShippingAddressNotification = @"ChangeShippingAddressNotification";

@interface ShippingAddressListController ()
@property(nonatomic, strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSIndexPath *checkmarkIndexPath;
@end

@implementation ShippingAddressListController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"收货地址";
    [self.tableView registerNib:[UINib nibWithNibName:@"ShippingAddressCell" bundle:nil] forCellReuseIdentifier:@"ShippingAddressCell"];
    
    UserInfo *userInfo = [AppDelegate appDelegateInstance].userInfo;
    self.dataSource = userInfo.shippingAdress;
    
    if(!self.dataSource)
    {
        KeychainItemWrapper *keychain = [AppDelegate appDelegateInstance].keychain;
        NSString *userAccount = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
        
        [GPWSAPI getShippingAddressWithUserName:userAccount success:^(NSArray *array)
        {
            self.dataSource = array;
            [self.tableView reloadData];
        } faile:^(ErrorType errorType)
        {
            NSLog(@"获取收货地址失败");
        }];
    }
    else
    {
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShippingAddressCell *cell = (ShippingAddressCell *)[tableView dequeueReusableCellWithIdentifier:@"ShippingAddressCell"];
  
    ShippingAddress *sa = self.dataSource[indexPath.row];
    cell.userNameLabel.text = sa.consigneeName;
    cell.addressLabel.text = sa.address;
    cell.accessoryType = (sa.flag == 1 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    
    if(sa.flag) self.checkmarkIndexPath = indexPath;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShippingAddress *sa = self.dataSource[indexPath.row];
    CGSize size = [sa.address sizeWithFont:[UIFont systemFontOfSize:13]
                         constrainedToSize:CGSizeMake(LH_SCREEN_WIDTH, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByCharWrapping];
    return size.height+44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.checkmarkIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.checkmarkIndexPath = indexPath;
    
    ShippingAddress *sa = self.dataSource[indexPath.row];
    sa.flag = 1;
    NSDictionary *userInfo = @{@"key":sa};
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeShippingAddressNotification object:nil userInfo:userInfo];
    
    // 将被选择中之外的收货地址设置为非默认收货地址
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        ShippingAddress *sa = obj;
        if(idx != indexPath.row) sa.flag = 0;
    }];
    
    // 将修改的数据同步到UserInfo
    UserInfo *userInfo1 = [AppDelegate appDelegateInstance].userInfo;
    userInfo1.shippingAdress = self.dataSource;
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)newShippingAddress:(id)sender
{
    NewShippingAddressController *nsa = [[NewShippingAddressController alloc] initWithNibName:@"NewShippingAddressController" bundle:nil];
    [self.navigationController pushViewController:nsa animated:YES];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
