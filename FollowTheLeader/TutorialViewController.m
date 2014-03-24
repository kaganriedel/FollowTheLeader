//
//  TutorialViewController.m
//  Gesturements
//
//  Created by Kagan Riedel on 3/17/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "TutorialViewController.h"

#define FONT_ALTEHAAS_REG(s) [UIFont fontWithName:@"AlteHaasGrotesk" size:s]

@interface TutorialViewController () <UIScrollViewDelegate>
{
    __weak IBOutlet UIScrollView *tutorialScrollView;
    __weak IBOutlet UIPageControl *pageControl;
}

@end

@implementation TutorialViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
    [closeButton setImage:[UIImage imageNamed:@"close_circle"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(onCloseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeButton];
    
    //width and height are reversed because screen is rotated
    CGFloat frameWidth = [UIScreen mainScreen].bounds.size.height;
    CGFloat frameHeight = [UIScreen mainScreen].bounds.size.width;
    
    UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
    overlayImageView.image = [UIImage imageNamed:@"murray_background.jpeg"];
    
    UIImageView *tutorialAnimationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frameWidth, 0, frameWidth, frameHeight)];
    tutorialAnimationImageView.image = [UIImage imageNamed:@"cage_background.jpeg"];
    
    UIView *acknowledgementsView = [[UIImageView alloc] initWithFrame:CGRectMake(frameWidth * 2, 0, frameWidth, frameHeight)];
    acknowledgementsView.backgroundColor = [UIColor myDarkGrayColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frameWidth, 40)];
    titleLabel.text = @"GESTUREMENTS";
    titleLabel.font = FONT_ALTEHAAS_REG(46);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor myBlueColor];
    
    UILabel *creditTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, frameWidth, 35)];
    creditTitleLabel.text = @"CREDITS";
    creditTitleLabel.font = FONT_ALTEHAAS_REG(40);
    creditTitleLabel.textAlignment = NSTextAlignmentCenter;
    creditTitleLabel.textColor = [UIColor whiteColor];
    
    UITextView *creditsTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 105, frameWidth, frameHeight - 90)];
    creditsTextView.text = @"612 Development LLC\nDeveloped by Kagan Riedel\nDesign by Willy Mattson";
    creditsTextView.font = FONT_ALTEHAAS_REG(26);
    creditsTextView.textAlignment = NSTextAlignmentCenter;
    creditsTextView.textColor = [UIColor grayColor];
    creditsTextView.backgroundColor = [UIColor clearColor];
    
    [acknowledgementsView addSubview:titleLabel];
    [acknowledgementsView addSubview:creditTitleLabel];
    [acknowledgementsView addSubview:creditsTextView];
    
    [tutorialScrollView addSubview:overlayImageView];
    [tutorialScrollView addSubview:tutorialAnimationImageView];
    [tutorialScrollView addSubview:acknowledgementsView];
    tutorialScrollView.contentSize = CGSizeMake(frameWidth * tutorialScrollView.subviews.count, frameHeight);
    tutorialScrollView.scrollEnabled = YES;
    tutorialScrollView.scrollsToTop = NO;
}


-(IBAction)onCloseButtonPressed:(UIButton *)closeButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"close button pressed");
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = tutorialScrollView.frame.size.width;
    float fractionalPage = tutorialScrollView.contentOffset.x / pageWidth;
    NSInteger page = round(fractionalPage);
    pageControl.currentPage = page;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (pageControl.currentPage == 1)
    {
        //start animating the tutorial
    }
}

@end
