//
//  UPOMP_ChangePasswordViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"
#import "UPOMP_KaNet.h"
#import "UPOMP_PasswordCellViewController.h"
#import "UPOMP_RePasswordCellViewController.h"
#import "UPOMP_CheckPhoneCellViewController.h"

@interface UPOMP_ChangePasswordViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate,UPOMP_KaNetDelegate>{
    IBOutlet UITableView *myTabelView;
    NSMutableArray *cellArray;
    
    IBOutlet UITableViewCell *infoTopCell;
    IBOutlet UIImageView *infoTopBG;
    
    IBOutlet UITableViewCell *phoneCell;
    IBOutlet UIImageView *phoneBG;
    IBOutlet UIImageView *phoneLeftBG;
    IBOutlet UILabel *phoneText;
    IBOutlet UILabel *phoneValue;
    IBOutlet UIImageView *phoneIcon;
    
    IBOutlet UITableViewCell *infoBottomCell;
    IBOutlet UIImageView *infoBottomBG;
    
    
    IBOutlet UITableViewCell *finishCell;
    IBOutlet UIButton *finishButton;
    IBOutlet UIButton *backButton;
    
    IBOutlet UITableViewCell *spaceCell;
    
    UPOMP_KaNet *net;
    
    UPOMP_CheckPhoneCellViewController *checkPhone;
    UPOMP_PasswordCellViewController *oldPassword;
    UPOMP_PasswordCellViewController *newPassword;
    UPOMP_RePasswordCellViewController *rePassword;
}
-(IBAction)finish:(id)sender;
-(IBAction)back:(id)sender;
@end
