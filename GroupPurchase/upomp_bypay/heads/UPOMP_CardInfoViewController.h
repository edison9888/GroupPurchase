//
//  UPOMP_CardInfoViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UPOMP_CardInfoViewController : UIViewController{
    IBOutlet UIButton *closeButton;
    IBOutlet UIImageView *imageView;
    IBOutlet UIView *bgView;
}
-(IBAction)close:(id)sender;
-(void)showView;
@end
