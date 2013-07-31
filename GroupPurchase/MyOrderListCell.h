//
//  MyOrderListCell.h
//  GroupPurchase
//
//  Created by xcode on 13-3-15.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end
