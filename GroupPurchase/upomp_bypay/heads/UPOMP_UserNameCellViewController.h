//
//  UPOMP_UserNameCellViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_CellViewController.h"

@interface UPOMP_UserNameCellViewController : UPOMP_CellViewController<UITextFieldDelegate>{
    IBOutlet UITextField *myField;
    IBOutlet UILabel* label;
    IBOutlet UIButton* bg;
    NSString *value;
    BOOL notitel;
    NSString *placeholderStr;
}
-(void)setPlaceholder:(NSString*)str;
-(IBAction)selectBG:(id)sender;
-(void)setValue:(NSString*)str;
@property BOOL noTitel;
@end
