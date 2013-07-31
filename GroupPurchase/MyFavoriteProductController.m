//
//  MyFavoriteProductController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-22.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "MyFavoriteProductController.h"
#import "ProductListView.h"
#import "DataManager.h"

@interface MyFavoriteProductController ()
@property (weak, nonatomic) IBOutlet ProductListView *tableView;
@property (weak, nonatomic) IBOutlet UIView *hitsView;
@end

@implementation MyFavoriteProductController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的收藏";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [DataManager getAllCollectedProduct:^(NSMutableArray *productsEntiy) {
        if(productsEntiy.count == 0)
        {
            CGRect f = self.hitsView.frame;
            f.origin.y = 0;
            self.hitsView.frame = f;
        }else
        {
            CGRect f = self.hitsView.frame;
            f.origin.y = -504;
            self.hitsView.frame = f;
            
            self.tableView.productList = productsEntiy;
            self.tableView.navigationController = self.navigationController;
            self.tableView.showFavoriteAndShareButton = NO;
            self.tableView.allowEdit = YES;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setHitsView:nil];
    [super viewDidUnload];
}
@end
