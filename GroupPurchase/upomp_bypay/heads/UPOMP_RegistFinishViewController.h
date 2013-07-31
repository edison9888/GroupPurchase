//
//  UPOMP_RegistFinishViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"

@interface UPOMP_RegistFinishViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView *myTabelView;
    NSMutableArray *cellArray;
    IBOutlet UITableViewCell *infoTopCell;
    IBOutlet UIImageView *infoTopBG;
    
    IBOutlet UITableViewCell *infoCell;
    IBOutlet UIImageView *infoBG;
    IBOutlet UIImageView *infoLeftBG;
    IBOutlet UILabel *infoText;
    IBOutlet UIView *infoLine;
    IBOutlet UIImageView *infoIcon;
    
    IBOutlet UITableViewCell *info2Cell;
    IBOutlet UIImageView *info2BG;
    IBOutlet UIImageView *info2LeftBG;
    IBOutlet UILabel *info2Text;
    
    IBOutlet UITableViewCell *infoBottomCell;
    IBOutlet UIImageView *infoBottomBG;
    
    IBOutlet UITableViewCell *topCell;
    IBOutlet UIImageView *topBG;
    
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
    
    IBOutlet UITableViewCell *bottomCell;
    IBOutlet UIImageView *bottomBG;
    
    IBOutlet UITableViewCell *finishCell;
    IBOutlet UIButton *finishButton;
    IBOutlet UIButton *addButton;
    
    IBOutlet UIImageView *icon;
}
-(IBAction)finish:(id)sender;
-(IBAction)addCard:(id)sender;
@end
