//
//  HelpInfoViewController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-27.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "HelpInfoViewController.h"

@interface HelpInfoViewController ()

@end

@implementation HelpInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
