//
//  UPOMP_ForgetPasswordViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"
#import "UPOMP_KaNet.h"
#import "UPOMP_CheckPhoneCellViewController.h"
#import "UPOMP_CheckImageCellViewController.h"

@interface UPOMP_ForgetPasswordViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate,UPOMP_KaNetDelegate>{
    
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *backButton;
    IBOutlet UITableViewCell *buttonCell;
    IBOutlet UITableViewCell *spaceCell;
    IBOutlet UITableView *myTabelView;
    UPOMP_KaNet *net;
    NSMutableArray *cellArray;
    UPOMP_CheckPhoneCellViewController *sms;
    UPOMP_CheckImageCellViewController *checkImage;
    BOOL isfirst;
}
-(IBAction)okButon:(id)sender;
-(IBAction)back:(id)sender;
@end
