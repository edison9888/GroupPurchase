//
//  UPOMP_UserMainViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"

@interface UPOMP_UserMainViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *myTabelView;
    NSMutableArray *cellArray;
    
    IBOutlet UITableViewCell *infoTopCell;
    IBOutlet UIImageView *infoTopBG;
    
    IBOutlet UITableViewCell *userNameCell;
    IBOutlet UIImageView *userNameBG;
    IBOutlet UIImageView *userNameLeftBG;
    IBOutlet UILabel *userNameText;
    IBOutlet UILabel *userNameValue;
    IBOutlet UIView *userNameLine;
    IBOutlet UIImageView *userIcon;
    
    IBOutlet UITableViewCell *welComeCell;
    IBOutlet UIImageView *welComeBG;
    IBOutlet UIImageView *welComeLeftBG;
    IBOutlet UILabel *welComeText;
    IBOutlet UILabel *welComeValue;
    
    IBOutlet UITableViewCell *infoBottomCell;
    IBOutlet UIImageView *infoBottomBG;
    
    IBOutlet UITableViewCell *infoTopCell2;
    IBOutlet UIImageView *infoTopBG2;
    
    IBOutlet UITableViewCell *infoBottomCell2;
    IBOutlet UIImageView *infoBottomBG2;
    
    IBOutlet UIImageView *cardBG;
    IBOutlet UIImageView *cardLeftBG;
    IBOutlet UILabel *cardText;
    IBOutlet UILabel *cardValue;
    IBOutlet UIView *cardLine;
    IBOutlet UIImageView *cardIcon;
    IBOutlet UITableViewCell *cardCell;
    
    
    IBOutlet UIImageView *phoneNumBG;
    IBOutlet UIImageView *phoneNumLeftBG;
    IBOutlet UILabel *phoneNumText;
    IBOutlet UILabel *phoneNumValue;
    IBOutlet UIImageView *phoneNumIcon;
    IBOutlet UITableViewCell *phoneNumCell;
    
    IBOutlet UIButton *changPhoneButton;
    IBOutlet UIButton *changePasswordButton;
    IBOutlet UIButton *cardMainButton;
    
    
    IBOutlet UITableViewCell *finishCell;
    IBOutlet UIButton *backButton;
    
}
-(IBAction)back:(id)sender;
-(IBAction)changePhone:(id)sender;
-(IBAction)changePassword:(id)sender;
-(IBAction)cardMain:(id)sender;
@end
