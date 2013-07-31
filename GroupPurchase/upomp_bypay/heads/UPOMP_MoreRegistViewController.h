//
//  UPOMP_MoreRegistViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"
#import "UPOMP_KaNet.h"
#import "UPOMP_WelComeCellViewController.h"

@interface UPOMP_MoreRegistViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate,UPOMP_KaNetDelegate>{
    IBOutlet UITableView *myTableView;
    IBOutlet UITableViewCell *finishCell;
    IBOutlet UIButton *finishButton;
    IBOutlet UIView *bgView;
    UPOMP_KaNet *net;
    NSMutableArray *cellArray;
    UPOMP_WelComeCellViewController *welCome;
}
-(IBAction)finishAct:(id)sender;
@end
