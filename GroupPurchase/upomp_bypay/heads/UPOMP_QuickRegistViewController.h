//
//  UPOMP_QuickRegistViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"
#import "UPOMP_KaNet.h"
#import "UPOMP_PasswordCellViewController.h"
#import "UPOMP_MoreRegistViewController.h"

@interface UPOMP_QuickRegistViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate,UPOMP_KaNetDelegate>{
    IBOutlet UITableView *myTabelView;
    NSMutableArray *cellArray;
    
    IBOutlet UITableViewCell *infoTopCell;
    IBOutlet UIImageView *infoTopBG;
    
    IBOutlet UITableViewCell *infoCell;
    IBOutlet UIImageView *infoBG;
    IBOutlet UIImageView *infoLeftBG;
    IBOutlet UILabel *infoText;
    IBOutlet UIImageView *infoIcon;
    
    IBOutlet UITableViewCell *infoBottomCell;
    IBOutlet UIImageView *infoBottomBG;
    
    IBOutlet UITableViewCell *userNameCell;
    IBOutlet UIButton *userNameBG;
    IBOutlet UILabel *userNameText;
    IBOutlet UILabel *userNameValue;
    
    IBOutlet UITableViewCell *checkinfoTopCell;
    IBOutlet UIImageView *checkinfoTopBG;
    
    IBOutlet UITableViewCell *checkinfoCell;
    IBOutlet UIImageView *checkinfoBG;
    IBOutlet UILabel *checkinfoText;
    
    IBOutlet UITableViewCell *readCell;
    IBOutlet UIButton *readButton;
    IBOutlet UILabel *readText;
    IBOutlet UILabel *hasReadText;
    IBOutlet UIImageView *arrow;
    IBOutlet UIButton *checkRead;
    
    IBOutlet UITableViewCell *checkinfoBottomCell;
    IBOutlet UIImageView *checkinfoBottomBG;
    
    
    IBOutlet UITableViewCell *finishCell;
    IBOutlet UIButton *finishButton;
    
    IBOutlet UIButton *escButton;
    
    BOOL hasCheck;
    UPOMP_PasswordCellViewController *password;
    UPOMP_KaNet *net;
    BOOL hasRead;
    UPOMP_MoreRegistViewController *moreRegist;
}
-(IBAction)finish:(id)sender;
-(IBAction)read:(id)sender;
-(IBAction)check:(id)sender;
-(IBAction)escAct:(id)sender;
@end
