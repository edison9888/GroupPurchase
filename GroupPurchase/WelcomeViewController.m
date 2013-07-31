//
//  WelcomeViewController.m
//  GroupPurchase
//
//  Created by xcode on 13-4-2.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "WelcomeViewController.h"

#define ItemCount 3

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end

@implementation WelcomeViewController

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
    
    self.index = 0;
    NSArray *names = @[@"welcome1.jpg",@"welcome2.jpg",@"welcome3.jpg"];
    
    self.scrollView.contentSize = CGSizeMake(LH_SCREEN_WIDTH*ItemCount, LH_SCREEN_HEIGHT-LH_STATUS_BAR_HEIGHT);

    
    for(int i = 0; i != ItemCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*LH_SCREEN_WIDTH, 0, LH_SCREEN_WIDTH, LH_SCREEN_HEIGHT-LH_STATUS_BAR_HEIGHT)];
        imageView.image = [UIImage imageNamed:names[i]];
        [self.scrollView addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setRemoveButton:nil];
    [super viewDidUnload];
}

- (IBAction)removeWelcomeView:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.index =  (NSInteger)floor(scrollView.contentOffset.x / LH_SCREEN_WIDTH);
    self.removeButton.hidden = self.index == 2 ? NO : YES;
}

@end
