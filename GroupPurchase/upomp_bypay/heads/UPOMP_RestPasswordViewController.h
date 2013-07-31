//
//  UPOMP_RestPasswordViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"
#import "UPOMP_KaNet.h"

@interface UPOMP_RestPasswordViewController : UPOMP_ViewController<UITableViewDataSource,UITableViewDelegate,UPOMP_KaNetDelegate>{
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *backButton;
    IBOutlet UITableViewCell *buttonCell;
    
    IBOutlet UITableViewCell *topCell;
    IBOutlet UIImageView *topBG;
    IBOutlet UITableViewCell *topCell2;
    IBOutlet UIImageView *topBG2;
    
    
    IBOutlet UITableViewCell *userNameCell;
    IBOutlet UIImageView *userNameBG;
    IBOutlet UIImageView *userNameLeftBG;
    IBOutlet UILabel *userNameValue;
    IBOutlet UIView *userNameLine;
    IBOutlet UIImageView *userNameIcon;
    
    
    IBOutlet UITableViewCell *phoneNumCell;
    IBOutlet UIImageView *phoneNumBG;
    IBOutlet UIImageView *phoneNumLeftBG;
    IBOutlet UILabel *phoneNumValue;
    IBOutlet UIImageView *phoneNumIcon;
    
    IBOutlet UITableViewCell *questionCell;
    IBOutlet UIImageView *questionBG;
    IBOutlet UIImageView *questionLeftBG;
    IBOutlet UILabel *questionValue;
    IBOutlet UIImageView *questionIcon;
    
    IBOutlet UITableViewCell *bottomCell;
    IBOutlet UIImageView *bottomBG;
    IBOutlet UITableViewCell *bottomCell2;
    IBOutlet UIImageView *bottomBG2;
    
    IBOutlet UITableView *myTabelView;
    UPOMP_KaNet *net;
    NSMutableArray *cellArray;
}
-(IBAction)okButon:(id)sender;
-(IBAction)back:(id)sender;
@end
