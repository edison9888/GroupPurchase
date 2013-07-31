//
//  ProductListView.m
//  GroupPurchase
//
//  Created by xcode on 13-2-19.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "ProductListView.h"
#import "ProductListCell.h"
#import "UIImageView+WebCache.h"
#import "Model.h"
#import "SVPullToRefresh.h"
#import "ProductDetailController.h"
#import "DataManager.h"

NSString *cellIdentifier = @"ProductListCell";


@interface ProductListView()
@property(nonatomic, strong) MNMBottomPullToRefreshManager *bottomPullToRefreshManager;
@end

@implementation ProductListView

- (id)init
{
    self = [super init]; 
    if(self)
    {
        [self initWork];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWork];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initWork];
    }
    return self;
}


- (void)initWork
{
    self.delegate = self;
    self.dataSource = self;
    self.rowHeight = 115;
    self.allowPullToRefresh = NO;
    self.showFavoriteAndShareButton = YES;
    [self registerNib:[UINib nibWithNibName:@"ProductListCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    _placeholderImage = [UIImage imageNamed:@""];
    _lastRefreshProductListDate = [NSDate date];
    
    [self setRefershView];

}

- (void)setRefershView
{
    if(self.allowPullToRefresh)
    {
        __weak ProductListView *weakSelf = self;
        [self addPullToRefreshWithActionHandler:^{
            [weakSelf pullRefreshProductList];
        }];
        [self.pullToRefreshView setTitle:@"下拉即可刷新..." forState:SVPullToRefreshStateStopped];
        [self.pullToRefreshView setTitle:@"刷新中..." forState:SVPullToRefreshStateLoading];
        [self.pullToRefreshView setTitle:@"松开即可刷新..." forState:SVPullToRefreshStateTriggered];
        
        self.bottomPullToRefreshManager = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f
                                                                                                       tableView:self
                                                                                                withClient:self];
    }
}

- (void)setAllowEdit:(BOOL)allowEdit
{
    _allowEdit = allowEdit;
    if(_allowEdit){
        [self reloadData];
    }
}

- (void)setAllowPullToRefresh:(BOOL)allowPullToRefresh
{
    _allowPullToRefresh = allowPullToRefresh;
    [self setRefershView];
}

- (void)setProductList:(NSMutableArray *)productList
{
    [_productList removeAllObjects];
    _productList = productList;
    [self reloadData];
    
    // 必须调用此方法来重新定位 MNMBottomPullToRefreshView 的位置
    if(self.allowPullToRefresh)
        [self.bottomPullToRefreshManager tableViewReloadFinished];
}

- (void)setMoreProduct:(NSMutableArray *)moreProduct
{
    _moreProduct = moreProduct;
    
    [self beginUpdates];
    for(Product *product in _moreProduct)
    {
        [_productList addObject:product];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_productList.count - 1 inSection:0];
        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
    [self endUpdates];
    
    self.isLoading = NO;
    if(self.allowPullToRefresh)
        [self.bottomPullToRefreshManager tableViewReloadFinished];
}

- (void)loadMoreProdcut
{
    if(self.loadMoreProductItemDelegate)
    {
        self.isLoading = YES;
        
        if(self.allowPullToRefresh)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.loadMoreProductItemDelegate loadMoreProduct];
            });
        }
    }
}

#pragma mark -
#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListCell *cell = (ProductListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Product *product = self.productList[indexPath.row];
    cell.producTilteLabel.text          = product.shopName;
    cell.cityNameOrDistanceLabel.text   = (self.controllerType == ControllerTypeGP) ? product.cityName : FLOAT_TO_STR(product.distance);
    cell.productDesLable.text           = product.description;
    cell.userAmountLabel.text           = [NSString stringWithFormat:@"%@人",INT_TO_STR(product.sumBuyQty)];
    cell.prodcutCostPriceLabel.text     = FLOAT_TO_STR(product.priceGoods);
    cell.productNotVIPPriceLabel.text   = FLOAT_TO_STR(product.priceNonMember);
    cell.productVIPPriceLabel.text      = FLOAT_TO_STR(product.priceGroup);
    
    [cell.productPreviewImageView setImageWithURL:[NSURL URLWithString:product.txImg] placeholderImage:_placeholderImage
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         if(error || !image)
         {
             
         }
     }];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.allowEdit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Product *product = self.productList[indexPath.row];
        [DataManager removeCollectedProduct:product.dbID];
        
        [self.productList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark -
#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Product *product = self.productList[indexPath.row];
    ProductDetailController *pdc = [[ProductDetailController alloc] initWithNibName:@"ProductDetailController" bundle:nil];
    [self.navigationController pushViewController:pdc animated:YES];
    pdc.product = product;
    pdc.showFavoriteButton = self.showFavoriteAndShareButton;
}

- (void)pullRefreshProductList
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *date = [formatter stringFromDate:_lastRefreshProductListDate];
    date = [NSString stringWithFormat:@"上次更新 %@",date];
    [self.pullToRefreshView setSubtitle:date forState:SVPullToRefreshStateLoading];
    _lastRefreshProductListDate = [NSDate date];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.pullToRefreshView stopAnimating];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.allowPullToRefresh)
        [self.bottomPullToRefreshManager tableViewScrolled];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.allowPullToRefresh)
        [self.bottomPullToRefreshManager tableViewReleased];
}


- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
{
    if(self.allowPullToRefresh)
        [self performSelector:@selector(loadMoreProdcut) withObject:nil afterDelay:1.0f];
}

@end
