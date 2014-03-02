//
//  ViewController.m
//  FollowTheLeader
//
//  Created by Kagan Riedel on 3/1/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>
{
    __weak IBOutlet UILabel *leaderLabel;
    __weak IBOutlet UILabel *feedbackLabel;
    __weak IBOutlet UILabel *scoreLabel;
    __weak IBOutlet UILabel *highscoreLabel;
    __weak IBOutlet UIButton *goButton;
    __weak IBOutlet UILabel *timerLabel;
    __weak IBOutlet UISegmentedControl *gameModeControl;
    NSTimer *timer;
    NSString *gestureCommanded;
    NSString *lastGestureRecieved;
    NSArray *feedbackArray;
    NSUserDefaults *userDefaults;
    int counter;
    int score;
    BOOL speedMode;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    feedbackLabel.alpha = 0.0;
    highscoreLabel.alpha = 0.0;
    leaderLabel.alpha = 0.0;
    scoreLabel.alpha = 0.0;
    timerLabel.alpha = 0.0;
    speedMode = YES;
    feedbackArray = @[@"NICE", @"HOT DAMN", @"SEXY", @"RAWR", @"MARVELOUS", @"CALIENTE", @"EN FUEGO", @"ROCKSTAR", @"BOOM SHAKALAKA", @"UNSTOPPABLE", @"AMAZEBALLS", @"RIDICULOUS", @"STELLAR", @"SMASHING", @"BANGIN", @"INCREDIBLE", @"SHUT THE FRONT DOOR", @"NO WAY", @"KILLER", @"SILLY GOOD", @"PERFECTION", @"REVOLUTIONARY", @"GREAT", @"INCENDIARY", @"UNBELIEVABLE"];
    userDefaults = [NSUserDefaults standardUserDefaults];
    highscoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE %li", (long)([userDefaults integerForKey:@"speedhighscore"] ?: 0)];
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)segmentedControl
{
    scoreLabel.alpha = 0.0;
    //speed
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        timerLabel.alpha = 0.0;
        speedMode = YES;
        highscoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE %li", (long)([userDefaults integerForKey:@"speedhighscore"] ?: 0)];
    }
    //timed
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        timerLabel.alpha = 1.0;
        speedMode = NO;
        highscoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE %li", (long)([userDefaults integerForKey:@"timedhighscore"] ?: 0)];
    }
}
- (IBAction)goPressed:(UIButton *)sender
{
    if (!speedMode)
    {
        counter = 1000;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
    goButton.alpha = 0.0;
    highscoreLabel.alpha = 0.0;
    leaderLabel.alpha = 1.0;
    scoreLabel.alpha = 1.0;
    gameModeControl.alpha = 0.0;
    score = 0;
    scoreLabel.text = [NSString stringWithFormat:@"%i", score];
    [self startNextCommand];
}

- (void)startNextCommand
{
    if (speedMode)
    {
        counter = 25;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
    
    feedbackLabel.alpha = 0.0;
    int randomNumber = arc4random()%9;
    switch (randomNumber) {
        case 0:
            leaderLabel.text = @"TAP";
            break;
        case 1:
            leaderLabel.text = @"DOUBLE TAP";
            break;
        case 2:
            leaderLabel.text = @"PINCH";
            break;
        case 3:
            leaderLabel.text = @"SWIPE RIGHT";
            break;
        case 4:
            leaderLabel.text = @"SWIPE LEFT";
            break;
        case 5:
            leaderLabel.text = @"SWIPE UP";
            break;
        case 6:
            leaderLabel.text = @"SWIPE DOWN";
            break;
        case 7:
            leaderLabel.text = @"DOUBLE SWIPE";
            break;
        case 8:
            leaderLabel.text = @"PRESS";
            break;
        default:
            break;
    }
}

- (void)timerFired
{
    counter --;
    timerLabel.text = [NSString stringWithFormat:@"%i", (counter + 9) / 10];
    if (counter == 0)
    {
        [self wrong];
    }
    if ([leaderLabel.text isEqualToString:lastGestureRecieved])
    {
        [self correct];
    }
}

- (void)correct
{
    if (speedMode)
    {
        [timer invalidate];
    }
    lastGestureRecieved = @"";
    int randomNumber = arc4random()%feedbackArray.count;
    feedbackLabel.text = feedbackArray[randomNumber];
    feedbackLabel.alpha = 1.0;
    [UIView animateWithDuration:3.5 animations:^{
        feedbackLabel.alpha = 0.0;
    }];
    score += 1;
    scoreLabel.text = [NSString stringWithFormat:@"%i", score];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startNextCommand) userInfo:nil repeats:NO];
}

- (void)wrong
{
    leaderLabel.alpha = 0.0;
    highscoreLabel.alpha = 1.0;
    gameModeControl.alpha = 1.0;
    goButton.alpha = 1.0;
    [timer invalidate];
    if (speedMode)
    {
        if ([userDefaults integerForKey:@"speedhighscore"] < score)
        {
            [userDefaults setInteger:score forKey:@"speedhighscore"];
            highscoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE %i", score];
        }
    }
    else
    {
        if ([userDefaults integerForKey:@"timedhighscore"] < score)
        {
            [userDefaults setInteger:score forKey:@"timedhighscore"];
            highscoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE %i", score];
        }
    }
    [userDefaults synchronize];
}

- (IBAction)didRecieveTap:(UITapGestureRecognizer *)sender
{
    lastGestureRecieved = @"TAP";
}

- (IBAction)didRecieveDoubletap:(UITapGestureRecognizer *)sender
{
    lastGestureRecieved = @"DOUBLE TAP";
}

- (IBAction)didRecievePinch:(UIPinchGestureRecognizer *)sender
{
    lastGestureRecieved = @"PINCH";
}

- (IBAction)didSwipeRight:(UISwipeGestureRecognizer *)sender
{
    lastGestureRecieved = @"SWIPE RIGHT";
}

- (IBAction)didSwipeLeft:(UISwipeGestureRecognizer *)sender
{
    lastGestureRecieved = @"SWIPE LEFT";
}

- (IBAction)didSwipeUp:(UISwipeGestureRecognizer *)sender
{
    lastGestureRecieved = @"SWIPE UP";
}

- (IBAction)didSwipeDown:(UISwipeGestureRecognizer *)sender
{
    lastGestureRecieved = @"SWIPE DOWN";
}

- (IBAction)didRecievePan:(UIPanGestureRecognizer *)sender
{
    lastGestureRecieved = @"DOUBLE SWIPE";
}

- (IBAction)didRecieveLongPress:(UILongPressGestureRecognizer *)sender
{
    lastGestureRecieved = @"PRESS";
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
