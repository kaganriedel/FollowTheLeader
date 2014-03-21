//
//  TutorialViewController.m
//  Gesturements
//
//  Created by Kagan Riedel on 3/17/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "TutorialViewController.h"

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
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
    [closeButton setImage:[UIImage imageNamed:@"close_circle"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(onCloseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeButton];
    
    //width and height are reversed because screen is rotated
    CGFloat frameWidth = [UIScreen mainScreen].bounds.size.height;
    CGFloat frameHeight = [UIScreen mainScreen].bounds.size.width;
    tutorialScrollView.contentSize = CGSizeMake(frameWidth * 3, frameHeight);
    
    UIImageView *ImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
    ImageView1.image = [UIImage imageNamed:@"kitten_background.jpeg"];
    [tutorialScrollView addSubview:ImageView1];
    
    UIImageView *ImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(frameWidth, 0, frameWidth, frameHeight)];
    ImageView2.image = [UIImage imageNamed:@"murray_background.jpeg"];
    [tutorialScrollView addSubview:ImageView2];
    
    UIImageView *ImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(frameWidth * 2, 0, frameWidth, frameHeight)];
    ImageView3.image = [UIImage imageNamed:@"cage_background.jpeg"];
    [tutorialScrollView addSubview:ImageView3];

    
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

@end
