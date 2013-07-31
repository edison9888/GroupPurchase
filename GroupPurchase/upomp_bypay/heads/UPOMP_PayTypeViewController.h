//
//  UPOMP_PayTypeViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_MainViewController.h"
#import "UPOMP_CheckImageCellViewController.h"
#import "UPOMP_PasswordCellViewController.h"
#import "UPOMP_PhoneNumCellViewController.h"
#import "UPOMP_CardNumCellViewController.h"
#import "UPOMP_UserNameCellViewController.h"
#import "UPOMP_ViewController.h"
#import "UPOMP_KaNet.h"

@interface UPOMP_PayTypeViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate,UPOMP_KaNetDelegate,MoreButtonDelegate>{
    IBOutlet UITableViewCell *changeButtonCell;
    IBOutlet UIButton *changeButton;
    
    
    IBOutlet UIButton *okButton;
    IBOutlet UITableViewCell *okButtonCell;
    
    IBOutlet UIButton *escButton;
    
    IBOutlet UITableView *myTabelView;
    
    BOOL isOrdinary;
    
    NSMutableArray *cellArray;
    
    
    UPOMP_CheckImageCellViewController *checkImage;
    UPOMP_PhoneNumCellViewController *phoneNum;
    UPOMP_PasswordCellViewController *passWord;
    UPOMP_CardNumCellViewController *cardNum;
    UPOMP_UserNameCellViewController *userName;
    UPOMP_KaNet *net;
    
    BOOL isFirstLogin;
    BOOL isFirstCardCheck;
}
-(IBAction)changeAct:(id)sender;
-(IBAction)okAct:(id)sender;
-(IBAction)closeAct:(id)sender;
@end
