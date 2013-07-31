//
//  HelpController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-22.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "HelpController.h"
#import "HelpInfoViewController.h"

@interface HelpController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;
@end

@implementation HelpController

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
    
    self.title = @"帮助信息";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataSource = @[@"关于118114",
                        @"关于支付问题", 
                        @"积份规则",   
                        @"如何获取现金抵用卷",
                        @"用户协议"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellIndetifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
    bgView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor colorWithWhite:0.9 alpha:1.0] : [UIColor colorWithWhite:0.88 alpha:1.0];
    cell.backgroundView = bgView;
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HelpInfoViewController *hivc = [[HelpInfoViewController alloc] initWithNibName:@"HelpInfoViewController" bundle:nil];
    [self.navigationController pushViewController:hivc animated:YES];
   
    NSString *path = [[NSBundle mainBundle] pathForResource:self.dataSource[indexPath.row] ofType:@"txt"];
    NSStringEncoding encode = NSUTF8StringEncoding;
    hivc.textView.text = [NSString stringWithContentsOfFile:path usedEncoding:&encode error:nil];
    hivc.title = self.dataSource[indexPath.row];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
