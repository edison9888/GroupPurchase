//
//  RetakeUserPasswordController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-14.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "RetakeUserPasswordController.h"

@interface RetakeUserPasswordController ()
@property (weak, nonatomic) IBOutlet UIButton    *shortMessageButton;
@property (weak, nonatomic) IBOutlet UIButton    *emailButton;
@property (weak, nonatomic) IBOutlet UITextField *inputBoxTextFiled;

@property (strong, nonatomic) IBOutlet UIImageView *shortMessageImageView;
@property (strong, nonatomic) IBOutlet UIImageView *emailImageView;
@end

@implementation RetakeUserPasswordController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"找回密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)switchToShortMessageWay:(id)sender
{
    
}

- (IBAction)switchToEmailWay:(id)sender
{
    
}

- (IBAction)retakeUserPassword:(id)sender
{
    
}

- (void)viewDidUnload
{
    [self setShortMessageButton:nil];
    [self setEmailButton:nil];
    [self setInputBoxTextFiled:nil];
    [self setShortMessageImageView:nil];
    [self setEmailImageView:nil];
    [super viewDidUnload];
}
@end
