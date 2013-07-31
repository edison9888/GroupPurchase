//
//  UPOMP_AboutViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_ViewController.h"

@interface UPOMP_AboutViewController : UPOMP_ViewController{
    IBOutlet UILabel *textLabel;
    IBOutlet UIImageView *logoView;
    IBOutlet UIButton *backButton;
}
-(IBAction)back:(id)sender;
@end
