//
//  UPOMP_SecureQuestionCellViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_CellViewController.h"

@interface UPOMP_SecureQuestionCellViewController : UPOMP_CellViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    IBOutlet UITextField *myField;
    IBOutlet UILabel* label;
    IBOutlet UIButton* bg;
    IBOutlet UIButton *listButton;
    IBOutlet UIPickerView *picker;
    IBOutlet UIView *pickerBG;
    NSMutableArray *secureQuestionArray;
    int secureQuestionSelectIndex;
}
-(IBAction)selectBG:(id)sender;
-(IBAction)selectList:(id)sender;
@end
