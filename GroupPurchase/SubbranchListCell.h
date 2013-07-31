//
//  SubbranchListCell.h
//  GroupPurchase
//
//  Created by xcode on 13-3-5.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

// 城市列表
@interface SubbranchListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *merchantLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *callPhoneButton;

@end
