//
//  UPOMP_SecureAnswerCellViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_CellViewController.h"

@interface UPOMP_SecureAnswerCellViewController : UPOMP_CellViewController<UITextFieldDelegate>{
    IBOutlet UITextField *myField;
    IBOutlet UILabel* label;
    IBOutlet UIButton* bg;
    BOOL noTitel;
    BOOL hasDefulte;
}
-(IBAction)selectBG:(id)sender;
@property BOOL noTitel;
@property BOOL hasDefulte;
@end
