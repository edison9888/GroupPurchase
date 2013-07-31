//
//  UPOMP_CardMainViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"
#import "UPOMP_CardListCellViewController.h"
#import "UPOMP_KaNet.h"

@interface UPOMP_CardMainViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate,UPOMP_KaNetDelegate>{
    IBOutlet UITableViewCell *infoTopCell;
    IBOutlet UIImageView *infoTopBG;
    
    IBOutlet UITableViewCell *infoBottomCell;
    IBOutlet UIImageView *infoBottomBG;
    
    IBOutlet UITableViewCell *finishCell;
    IBOutlet UIButton *finishButton;
    IBOutlet UIButton *backButton;
    
    
    IBOutlet UITableViewCell *nodataCell;
    IBOutlet UIImageView *nodataBG;
    IBOutlet UILabel *nodataText;
    
    IBOutlet UITableView *myTabelView;
    NSMutableArray *cardCellArray;
    UPOMP_KaNet *net;
    
    UPOMP_CardListCellViewController *selectCard;
    BOOL hasData;
}
-(IBAction)back:(id)sender;
-(IBAction)addCard:(id)sender;
-(void)setDefault:(id)sender;
-(void)deleteCard:(id)sender;
-(void)setSelectCard:(UPOMP_CardListCellViewController*)cell;
@end
