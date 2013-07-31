//
//  UPOMP_AgreementView.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UPOMP;

@interface UPOMP_AgreementView : UIViewController {
	UITextView *textview;
	UILabel *lable;
    UPOMP *upomp;
}
- (id)initWithUPOMP:(UPOMP*)obj;
@end



