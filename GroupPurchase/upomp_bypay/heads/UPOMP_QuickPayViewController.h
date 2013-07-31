//
//  UPOMP_QuickPayViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_MainViewController.h"
#import "UPOMP_ViewController.h"
#import "UPOMP_KaNet.h"
#import "UPOMP_CheckPhoneCellViewController.h"

@interface UPOMP_QuickPayViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate,UPOMP_KaNetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{//MoreButtonDelegate
    IBOutlet UIImageView *infoTopImageView;
    IBOutlet UITableViewCell *infoTopCell;
    
    IBOutlet UITableViewCell *userNameCell;
    IBOutlet UIImageView *userNameBG;
    IBOutlet UIImageView *userNameLeftBG;
    IBOutlet UILabel *userNameText;
    IBOutlet UILabel *userNameValue;
    IBOutlet UIView *userNameLine;
    
    IBOutlet UITableViewCell *welComeCell;
    IBOutlet UIImageView *welComeBG;
    IBOutlet UIImageView *welComeLeftBG;
    IBOutlet UILabel *welComeText;
    IBOutlet UILabel *welComeValue;
    
    IBOutlet UITableViewCell *cardTypeCell;
    IBOutlet UIImageView *cardTypeBG;
    IBOutlet UIImageView *cardTypeLeftBG;
    IBOutlet UILabel *cardTypeValue;
    IBOutlet UIView *cardTypeLine;
    IBOutlet UIImageView *cardTypeIcon;
    IBOutlet UIButton *cardMoreButton;
    
    IBOutlet UIImageView *phoneNumIcon;
    IBOutlet UITableViewCell *phoneNumCell;
    IBOutlet UIImageView *phoneNumBG;
    IBOutlet UIImageView *phoneNumLeftBG;
    IBOutlet UILabel *phoneNumValue;
    
    IBOutlet UIImageView *bottomBG;
    IBOutlet UITableViewCell *bottomCell;
    
    IBOutlet UIButton *userButton;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *backButton;
    IBOutlet UITableViewCell *buttonCell;
    
    IBOutlet UITableView *myTabelView;
    
    IBOutlet UIImageView *infoTopImageView2;
    IBOutlet UITableViewCell *infoTopCell2;
    
    IBOutlet UILabel *infoValue;
    IBOutlet UIImageView *infoBG;
    IBOutlet UITableViewCell *infoCell;
    
    IBOutlet UIImageView *bottomBG2;
    IBOutlet UITableViewCell *bottomCell2;
    
    IBOutlet UIView *cardListView;
    IBOutlet UIPickerView *pickerView;
    
    IBOutlet UIImageView *infoTopImageView3;
    IBOutlet UITableViewCell *infoTopCell3;
    
    IBOutlet UIImageView *bottomBG3;
    IBOutlet UITableViewCell *bottomCell3;
    
    IBOutlet UIView *popinfoView;
    IBOutlet UIImageView *popBG;
    IBOutlet UILabel *poptext;
    
    NSTimer *timer;
    BOOL timerRun;
    
    UPOMP_KaNet *net;
    NSMutableArray *cellArray;
    BOOL hasLoadData;
    BOOL willAddCard;
    UPOMP_CheckPhoneCellViewController *smsCheck;
    int selectCardIndex;
}
-(IBAction)okButon:(id)sender;
-(IBAction)back:(id)sender;
-(IBAction)userManage:(id)sender;
-(IBAction)moreCard:(id)sender;
@end
