//
//  MyCoupanListCell.h
//  GroupPurchase
//
//  Created by xcode on 13-3-6.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCoupanListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *coupanNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *coupanPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *coupanStartDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *coupanEndDateLabel;
@end
