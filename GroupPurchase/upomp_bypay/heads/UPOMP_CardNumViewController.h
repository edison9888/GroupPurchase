//
//  UPOMP_CardNumViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"
#import "UPOMP_KaNet.h"
#import "UPOMP_CardNumCellViewController.h"
#import "UPOMP_CheckImageCellViewController.h"
#import "UPOMP_PhoneNumCellViewController.h"

@interface UPOMP_CardNumViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate,UPOMP_KaNetDelegate>{
    IBOutlet UITableViewCell *finishCell;
    IBOutlet UIButton *finishButton;
    IBOutlet UIButton *backButton;
    IBOutlet UITableViewCell *spaceCell;
    IBOutlet UITableView *myTabelView;
    UPOMP_CardNumCellViewController *cardNum;
    UPOMP_CheckImageCellViewController *checkImage;
    UPOMP_PhoneNumCellViewController *phoneNum;
    NSMutableArray *cellArray;
    UPOMP_KaNet *net;
    BOOL isFirst;
}
-(IBAction)back:(id)sender;
-(IBAction)next:(id)sender;
@end
