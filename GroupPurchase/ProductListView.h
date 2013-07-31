//
//  ProductListView.h
//  GroupPurchase
//
//  Created by xcode on 13-2-19.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPWSAPI.h"
#import "MNMBottomPullToRefreshManager.h"

typedef enum{
    ControllerTypeGP = 0,   // 团购(默认)
    ControllerTypeNR        // 周边
}ControllerType;

@protocol ProductListViewDelegate;
@interface ProductListView : UITableView<UITableViewDataSource,UITableViewDelegate, MNMBottomPullToRefreshManagerClient>
{
    @private
    UIImage  *_placeholderImage;
    NSDate   *_lastRefreshProductListDate;
}

@property(nonatomic,weak) id<ProductListViewDelegate> loadMoreProductItemDelegate;

@property(nonatomic, assign) BOOL isLoading;             // YES为正在加载更多产品,默认为NO.
@property(nonatomic, assign) BOOL allowPullToRefresh;    // YES为允许下拉和下拉刷新操作,默认为NO
@property(nonatomic, assign) BOOL allowEdit;             // YES为允许编辑表格,默认为NO
@property(nonatomic, assign) BOOL showFavoriteAndShareButton;

@property(nonatomic,strong) NSMutableArray *productList;  // 设置此属性将加载产品列表，用于初始化表视图
@property(nonatomic,strong) NSMutableArray  *moreProduct; // 设置此属性将在表视图中插入产品信息,用于下拉加载更多

// 告诉ProductListView它是为那个控制器显示数据.因为团购和周边显示的信息有一处不同,
// 团购显示地区,周边显示距离.ProductListView将根据此属性值进行不同的显示
@property(nonatomic,assign) ControllerType controllerType;

@property(nonatomic,assign) ProductType productType;
@property(nonatomic,assign) SortType    sortType;

@property(nonatomic,weak)  UINavigationController *navigationController;

@end

@protocol ProductListViewDelegate <NSObject>
@required
-(void)loadMoreProduct;
@end

