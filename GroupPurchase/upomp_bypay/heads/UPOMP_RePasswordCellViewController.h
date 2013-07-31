//
//  UPOMP_RePasswordCellViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_CellViewController.h"
#import "UPOMP_KeyBoardView.h"

@interface UPOMP_RePasswordCellViewController : UPOMP_CellViewController<UITextFieldDelegate,UPOMP_KeyBoardViewDelegate>{
    IBOutlet UITextField *myField;
    IBOutlet UILabel* label;
    IBOutlet UIButton* bg;
    UPOMP_KeyBoardView *keyBoard;
    UPOMP_CellViewController *compareCell;
    BOOL noTitel;
}
-(IBAction)selectBG:(id)sender;
-(void)setCompareCell:(id)cell;
@property BOOL noTitel;
@end
