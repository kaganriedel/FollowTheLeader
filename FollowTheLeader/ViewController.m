//
//  ViewController.m
//  FollowTheLeader
//
//  Created by Kagan Riedel on 3/1/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ViewController.h"
#import "CSAnimationView.h"

@interface ViewController () <UIGestureRecognizerDelegate>
{
    __weak IBOutlet UILabel *leaderLabel;
    __weak IBOutlet UILabel *feedbackLabel;
    __weak IBOutlet UILabel *scoreLabel;
    __weak IBOutlet UILabel *highscoreLabel;
    __weak IBOutlet UIButton *goButton;
    __weak IBOutlet UILabel *timerLabel;
    __weak IBOutlet UISegmentedControl *gameModeControl;
    __weak IBOutlet CSAnimationView *feedbackAnimationView;
    __weak IBOutlet CSAnimationView *leaderAnimationView;
    __weak IBOutlet CSAnimationView *timerAnimationView;
    __weak IBOutlet CSAnimationView *segmentedControlAnimationView;
    __weak IBOutlet CSAnimationView *highscoreAnimationView;
    NSTimer *timer;
    NSString *gestureCommanded;
    NSString *lastGestureRecieved;
    NSArray *feedbackArray;
    NSUserDefaults *userDefaults;
    float counter;
    int score;
    BOOL endlessMode;
    int lastRandomGesturePicked;
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
    timerLabel.alpha = 1.0;
    endlessMode = NO;

    feedbackAnimationView.type = CSAnimationTypeBounceDown;
    feedbackAnimationView.delay = 0.0;
    feedbackAnimationView.duration = 0.5;
    highscoreAnimationView.type = CSAnimationTypeZoomOut;
    highscoreAnimationView.delay = 0.0;
    highscoreAnimationView.duration = 1.0;
    
    feedbackArray = @[@"NICE", @"HOT DAMN", @"SEXY", @"RAWR", @"MARVELOUS", @"CALIENTE", @"EN FUEGO", @"ROCKSTAR", @"BOOM SHAKALAKA", @"UNSTOPPABLE", @"AMAZING", @"RIDICULOUS", @"STELLAR", @"SMASHING", @"BANGIN", @"INCREDIBLE", @"SHUT THE FRONT DOOR", @"NO WAY", @"KILLER", @"SILLY GOOD", @"PERFECTION", @"REVOLUTIONARY", @"GREAT", @"INCENDIARY", @"UNBELIEVABLE"];
    userDefaults = [NSUserDefaults standardUserDefaults];
    highscoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE %li", (long)([userDefaults integerForKey:@"timedhighscore"] ?: 0)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    leaderAnimationView.type = CSAnimationTypeZoomOut;
    leaderAnimationView.delay = 0.4;
    leaderAnimationView.duration = 1.0;
    [leaderAnimationView startCanvasAnimation];
    
    timerAnimationView.type = CSAnimationTypeSlideRight;
    timerAnimationView.delay = 0.8;
    timerAnimationView.duration = 1.5;
    [timerAnimationView startCanvasAnimation];
    
    segmentedControlAnimationView.type = CSAnimationTypeSlideDown;
    segmentedControlAnimationView.delay = 0.8;
    segmentedControlAnimationView.duration = 1.5;
    [segmentedControlAnimationView startCanvasAnimation];

}
- (IBAction)segmentValueChanged:(UISegmentedControl *)segmentedControl
{
    scoreLabel.alpha = 0.0;
    //speed
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        timerLabel.alpha = 1.0;
        timerAnimationView.type = CSAnimationTypeFadeIn;
        timerAnimationView.delay = 0.0;
        timerAnimationView.duration = 1.0;
        [timerAnimationView startCanvasAnimation];
        endlessMode = NO;
        highscoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE %li", (long)([userDefaults integerForKey:@"timedhighscore"] ?: 0)];
    }
    //timed
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        timerAnimationView.type = CSAnimationTypeFadeOut;
        timerAnimationView.delay = 0.0;
        timerAnimationView.duration = 1.0;
        [timerAnimationView startCanvasAnimation];

        endlessMode = YES;
        highscoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE %li", (long)([userDefaults integerForKey:@"endlesshighscore"] ?: 0)];
    }
}
- (IBAction)goPressed:(UIButton *)sender
{
    if (!endlessMode)
    {
        counter = 10.0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
    else
    {
        timerLabel.alpha = 0.0;
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
    if (endlessMode)
    {
        counter = 2.0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
    feedbackLabel.alpha = 0.0;
    int randomNumber = arc4random()%9;
    if (randomNumber == lastRandomGesturePicked && randomNumber > 0)
    {
        randomNumber --;
    }
    else if (randomNumber == lastRandomGesturePicked && randomNumber == 0)
    {
        randomNumber ++;
    }
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
    lastRandomGesturePicked = randomNumber;
}

- (void)timerFired
{
    counter -= 0.01;
    timerLabel.text = [NSString stringWithFormat:@"%i", (int)(counter+0.99)];
    if (counter <= 0)
    {
        [self gameOver];
    }
    if ([leaderLabel.text isEqualToString:lastGestureRecieved])
    {
        [self correct];
    }
}

- (void)correct
{
    lastGestureRecieved = @"";
    if (endlessMode)
    {
        [timer invalidate];
    }
    int randomNumber = arc4random()%feedbackArray.count;
    feedbackLabel.text = feedbackArray[randomNumber];
    feedbackLabel.alpha = 1.0;
    [feedbackAnimationView startCanvasAnimation];
    [UIView animateWithDuration:2.0 animations:^{
        feedbackLabel.alpha = 0.0;
    }];
    score += 1;
    scoreLabel.text = [NSString stringWithFormat:@"%i", score];
    [self startNextCommand];
}

- (void)gameOver
{
    leaderLabel.alpha = 0.0;
    highscoreLabel.alpha = 1.0;
    gameModeControl.alpha = 1.0;
    goButton.alpha = 1.0;
    segmentedControlAnimationView.delay = 0.0;
    [segmentedControlAnimationView startCanvasAnimation];
    leaderAnimationView.delay = 0.0;
    [leaderAnimationView startCanvasAnimation];
    [highscoreAnimationView startCanvasAnimation];
    [timer invalidate];
    if (endlessMode)
    {
        if ([userDefaults integerForKey:@"endlesshighscore"] < score)
        {
            [userDefaults setInteger:score forKey:@"endlesshighscore"];
            highscoreLabel.text = [NSString stringWithFormat:@"NEW HIGH SCORE %i", score];
        }
    }
    else
    {
        if ([userDefaults integerForKey:@"timedhighscore"] < score)
        {
            [userDefaults setInteger:score forKey:@"timedhighscore"];
            highscoreLabel.text = [NSString stringWithFormat:@"NEW HIGH SCORE %i", score];
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
