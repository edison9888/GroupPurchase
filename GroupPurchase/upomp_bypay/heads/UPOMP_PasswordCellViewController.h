//
//  UPOMP_PasswordCellViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_CellViewController.h"
#import "UPOMP_KeyBoardView.h"

@interface UPOMP_PasswordCellViewController : UPOMP_CellViewController<UITextFieldDelegate,UPOMP_KeyBoardViewDelegate>{
    IBOutlet UITextField *myField;
    IBOutlet UILabel* label;
    IBOutlet UIButton* bg;
    IBOutlet UIButton *forgetButton;
    UPOMP_KeyBoardView *keyBoard;
    NSString *tempTitel;
    NSString *tempKey;
    BOOL noTitel;
    NSString *placeholderStr;
}
-(IBAction)selectBG:(id)sender;
-(IBAction)forgetAct:(id)sender;
-(void)setKey:(NSString*)tKey;
-(void)setPlaceholder:(NSString*)str;
@property BOOL noTitel;
@end
