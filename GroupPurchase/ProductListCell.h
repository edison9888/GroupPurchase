//
//  ProductListCell.h
//  GroupPurchase
//
//  Created by xcode on 13-2-19.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productPreviewImageView;
@property (weak, nonatomic) IBOutlet UILabel *producTilteLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDesLable;
@property (weak, nonatomic) IBOutlet UILabel *prodcutCostPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNotVIPPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productVIPPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameOrDistanceLabel;

@end
