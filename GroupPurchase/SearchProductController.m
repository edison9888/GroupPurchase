//
//  SearchProductController.m
//  GroupPurchase
//
//  Created by xcode on 13-1-31.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "SearchProductController.h"
#import "ProductListView.h"
#import "GPWSAPI.h"
#import "AppDelegate.h"

@interface SearchProductController ()
@property (weak, nonatomic) IBOutlet ProductListView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation SearchProductController

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
    
    [self.searchBar becomeFirstResponder];
    self.tableView.navigationController = self.navigationController;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
    showHudWith(self.view, @"搜索中", YES, NO);
    
    [GPWSAPI getProductListWithCityID:0
                               typeID:0
                              keyWord:searchBar.text
                                  lon:0
                                  lat:0
                             distance:0
                             sortType:0
                             pageSize:1000
                            pageIndex:0
                              success:^(NSMutableArray *productEntities) {
                                  self.tableView.productList = productEntities;
                                  
                                  if(productEntities.count == 0)
                                  {
                                      showHudWith(self.view, @"没有相关商品", NO, YES);
                                  }else{
                                      removeHudFromView(self.view);
                                  }
                              } faile:^(ErrorType errorType) {
                                  showHudWith(self.view, @"搜索失败", NO, YES);
                              }];
}


- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
