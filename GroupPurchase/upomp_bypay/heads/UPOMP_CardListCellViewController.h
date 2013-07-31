//
//  UPOMP_CardListCellViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UPOMP_CardMainViewController;
@class UPOMP;

@interface UPOMP_CardListCellViewController : UIViewController{
    IBOutlet UIImageView *bg;
    IBOutlet UIImageView *leftBG;
    IBOutlet UIImageView *icon;
    IBOutlet UIImageView *defauletIcon;
    IBOutlet UIImageView *topBG;
    IBOutlet UILabel *text;
    IBOutlet UIButton *selectButton;
    IBOutlet UIView *line;
    IBOutlet UITableViewCell *bottomCell;
    IBOutlet UIImageView *bottomBG;
    IBOutlet UITableViewCell *deleteCell;
    IBOutlet UIImageView *deleteLeftBG;
    IBOutlet UIImageView *deleteArrow;
    IBOutlet UIImageView *deleteIcon;
    IBOutlet UILabel *deleteText;
    IBOutlet UIButton *deleteSelectButton;
    IBOutlet UITableViewCell *setDefauletCell;
    IBOutlet UIImageView *setDefauletLeftBG;
    IBOutlet UIImageView *setDefauletArrow;
    IBOutlet UIImageView *setDefauletIcon;
    IBOutlet UILabel *setDefauletText;
    IBOutlet UIButton *setDefauletSelectButton;
    IBOutlet UIView *setDefauletline;
    UPOMP *upomp;
    NSDictionary *cardInfo;
    UPOMP_CardMainViewController *cardMain;
    BOOL isdefault;
    BOOL isSelect;
    int cardIndex;
    NSMutableArray *cellArray;
}
-(NSInteger)numberOfRowsInSection;
-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(id)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(IBAction)select:(id)sender;
-(IBAction)deleteCard:(id)sender;
-(IBAction)setDefaulet:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil upomp:(UPOMP*)obj;
-(void)setCardInfo:(NSDictionary *)dic cardMain:(UPOMP_CardMainViewController*)main cardIndex:(int)index;
-(void)setNOSelcet;
-(void)setSelect;
-(int)getCardIndex;
-(BOOL)getIsDefault;
-(NSDictionary*)getCardInfo;
@end
