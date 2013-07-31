//
//  UPOMP_CardFinishViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"

@interface UPOMP_CardFinishViewController : UPOMP_ViewController<UITableViewDelegate,UITableViewDataSource>{
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
    
    IBOutlet UITableViewCell *finishCell;
    IBOutlet UIButton *finishButton;
    
    IBOutlet UITableViewCell *titelTextCell;
    IBOutlet UILabel *titelText;
    
    IBOutlet UITableViewCell *helpTextCell;
    IBOutlet UITextView *helpText;
    
    IBOutlet UITableViewCell *topCell;
    IBOutlet UIImageView *topBG;
    
    IBOutlet UITableViewCell *bankNameCell;
    IBOutlet UIImageView *bankNameBG;
    IBOutlet UIImageView *bankNameLeftBG;
    IBOutlet UILabel *bankNameText;
    IBOutlet UILabel *bankNameValue;
    IBOutlet UIView *bankNameLine;
    
    IBOutlet UITableViewCell *cardTypeCell;
    IBOutlet UIImageView *cardTypeBG;
    IBOutlet UIImageView *cardTypeLeftBG;
    IBOutlet UILabel *cardTypeText;
    IBOutlet UILabel *cardTypeValue;
    IBOutlet UIView *cardTypeLine;
    IBOutlet UIImageView *cardTypeIcon;
    
    IBOutlet UITableViewCell *cardNumCell;
    IBOutlet UIImageView *cardNumBG;
    IBOutlet UIImageView *cardNumLeftBG;
    IBOutlet UILabel *cardNumText;
    IBOutlet UILabel *cardNumValue;
    IBOutlet UIView *cardNumLine;
    
    IBOutlet UITableViewCell *phoneNumCell;
    IBOutlet UIImageView *phoneNumBG;
    IBOutlet UIImageView *phoneNumLeftBG;
    IBOutlet UILabel *phoneNumText;
    IBOutlet UILabel *phoneNumValue;
    IBOutlet UIImageView *phoneNumIcon;
    
    IBOutlet UITableViewCell *bottomCell;
    IBOutlet UIImageView *bottomBG;
    
    int willAddCard;
    
}
-(IBAction)finish:(id)sender;
@end
