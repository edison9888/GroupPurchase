//
//  UPOMP_ChangePhoneViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"
#import "UPOMP_PasswordCellViewController.h"
#import "UPOMP_PhoneNumCellViewController.h"
#import "UPOMP_CheckPhoneCellViewController.h"

@interface UPOMP_ChangePhoneViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate,UPOMP_KaNetDelegate>{
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
    
    IBOutlet UITableViewCell *infoTopCell2;
    IBOutlet UIImageView *infoTopBG2;
    
    IBOutlet UITableViewCell *userNameCell;
    IBOutlet UIImageView *userNameBG;
    IBOutlet UIImageView *userNameLeftBG;
    IBOutlet UILabel *userNameText;
    IBOutlet UILabel *userNameValue;
    IBOutlet UIImageView *userNameIcon;
    
    IBOutlet UITableViewCell *infoBottomCell2;
    IBOutlet UIImageView *infoBottomBG2;
    
    IBOutlet UITableViewCell *finishCell;
    IBOutlet UIButton *finishButton;
    IBOutlet UIButton *backButton;
    UPOMP_PasswordCellViewController *password;
    UPOMP_PhoneNumCellViewController *phoneNum;
    UPOMP_CheckPhoneCellViewController *checkPhone;
    UPOMP_KaNet *net;
}
-(IBAction)finish:(id)sender;
-(IBAction)back:(id)sender;
@end
