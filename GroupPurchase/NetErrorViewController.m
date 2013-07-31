//
//  NetErrorViewController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-28.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "NetErrorViewController.h"

@interface NetErrorViewController ()

@end

@implementation NetErrorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.hidesBackButton = YES;
        self.title = @"网络连接断开";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)clickOnScreen:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(self.handleErrorNetDelegate)
        {
            [self.handleErrorNetDelegate handelNetConnectonBreakError];
        }
    });
    
    [self.navigationController popViewControllerAnimated:NO];

}

@end
