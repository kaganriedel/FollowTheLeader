//
//  ViewController.m
//  FollowTheLeader
//
//  Created by 612 Development LLC on 3/1/14.
//  Copyright (c) 612 Development LLC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>
#import "ViewController.h"
#import "CSAnimationView.h"
#import "BKECircularProgressView.h"
#import <GameKit/GameKit.h>

#define FONT_ALTEHAAS_REG(s) [UIFont fontWithName:@"AlteHaasGrotesk" size:s]

@interface ViewController () <UIGestureRecognizerDelegate, AVAudioPlayerDelegate, GKGameCenterControllerDelegate, UINavigationControllerDelegate>
{
    __weak IBOutlet UILabel *leaderLabel;
    __weak IBOutlet UILabel *feedbackLabel;
    __weak IBOutlet UILabel *scoreLabel;
    __weak IBOutlet UILabel *highscoreLabel;
    __weak IBOutlet UIButton *goButton;
    __weak IBOutlet UISegmentedControl *gameModeSegmentedControl;
    __weak IBOutlet CSAnimationView *feedbackAnimationView;
    __weak IBOutlet CSAnimationView *leaderAnimationView;
    __weak IBOutlet CSAnimationView *timerAnimationView;
    __weak IBOutlet CSAnimationView *segmentedControlAnimationView;
    __weak IBOutlet CSAnimationView *highscoreAnimationView;
    __weak IBOutlet UIButton *musicButton;
    BKECircularProgressView *progressView;
    NSTimer *timer;
    NSString *gestureCommanded;
    NSString *lastGestureRecieved;
    NSArray *feedbackArray;
    NSUserDefaults *userDefaults;
    float maxCounterTime;
    float counter;
    long score;
    BOOL endlessMode;
    BOOL firstLoad;
    int lastRandomGesturePicked;
    int gamesPlayed;
    
    AVAudioPlayer *audioPlayer;
    GKPlayer *currentPlayer;
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
    endlessMode = YES;
    maxCounterTime = 5.0;
    gamesPlayed = 0;
    firstLoad = YES;
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:FONT_ALTEHAAS_REG(17.0) forKey:NSFontAttributeName];
//    [gameModeSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    feedbackLabel.font = FONT_ALTEHAAS_REG(35);
    highscoreLabel.font = FONT_ALTEHAAS_REG(35);
    leaderLabel.font = FONT_ALTEHAAS_REG(52);
    goButton.titleLabel.font = FONT_ALTEHAAS_REG(52);
    scoreLabel.font = FONT_ALTEHAAS_REG(20);
    
    progressView = [[BKECircularProgressView alloc] initWithFrame:CGRectMake(15, 5, 33, 33)];
    [progressView setProgressTintColor:[UIColor orangeColor]];
    [progressView setBackgroundTintColor:[UIColor clearColor]];
    [progressView setLineWidth:2.0f];
    [progressView setProgress:1.0f];
    [timerAnimationView addSubview:progressView];
    
    feedbackAnimationView.type = CSAnimationTypeBounceDown;
    feedbackAnimationView.delay = 0.0;
    feedbackAnimationView.duration = 0.5;
    highscoreAnimationView.type = CSAnimationTypeZoomOut;
    highscoreAnimationView.delay = 0.0;
    highscoreAnimationView.duration = 1.0;
    
    feedbackArray = @[@"NICE", @"HOT DAMN", @"SEXY", @"RAWR", @"MARVELOUS", @"CALIENTE", @"EN FUEGO", @"ROCKSTAR", @"BOOM SHAKALAKA", @"UNSTOPPABLE", @"AMAZING", @"RIDICULOUS", @"STELLAR", @"SMASHING", @"BANGIN", @"INCREDIBLE", @"SHUT THE FRONT DOOR", @"NO WAY", @"KILLER", @"SILLY GOOD", @"PERFECTION", @"REVOLUTIONARY", @"GREAT", @"INCENDIARY", @"UNBELIEVABLE"];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    highscoreLabel.text = @"";
    
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource: @"Ghostwriter"
                                    ofType: @"mp3"];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    
    [audioPlayer prepareToPlay];
    audioPlayer.delegate = self;
    if (![userDefaults boolForKey:@"Prefer Music Off"])
    {
        [audioPlayer play];
    }
    if (![userDefaults boolForKey:@"Ads Disabled"])
    {
        self.canDisplayBannerAds = YES;
    }
    
    self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (firstLoad)
    {
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
        
        firstLoad = NO;
    }
}
- (IBAction)segmentValueChanged:(UISegmentedControl *)segmentedControl
{
    scoreLabel.alpha = 0.0;
    //endless
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        maxCounterTime = 5.0;
        endlessMode = YES;
    }
    //timed
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        maxCounterTime = 50.0;
        endlessMode = NO;
    }
}
- (IBAction)goPressed:(UIButton *)sender
{
    if (!endlessMode)
    {
        counter = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
    else
    {
        maxCounterTime = 5.0;
    }
    goButton.alpha = 0.0;
    highscoreLabel.alpha = 0.0;
    highscoreLabel.text = @"";
    leaderLabel.alpha = 1.0;
    scoreLabel.alpha = 1.0;
    gameModeSegmentedControl.alpha = 0.0;
    score = 0;
    scoreLabel.text = [NSString stringWithFormat:@"%li", score];
    [self startNextCommand];
    self.canDisplayBannerAds = NO;
}

- (void)startNextCommand
{
    if (endlessMode)
    {
        counter = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
    feedbackLabel.alpha = 0.0;
    int numberOfGestures = 8;
    int randomNumber = arc4random()%numberOfGestures;
    if (randomNumber == lastRandomGesturePicked && randomNumber > 0)
    {
        randomNumber --;
    }
    else if (randomNumber == lastRandomGesturePicked && randomNumber == 0)
    {
        randomNumber = numberOfGestures - 1;
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
            leaderLabel.text = @"PRESS";
            break;
        default:
            break;
    }
    lastRandomGesturePicked = randomNumber;
}

- (void)timerFired
{
    counter += 0.01;
    [progressView setProgress:counter/maxCounterTime];
    if (counter >= maxCounterTime)
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
        if (maxCounterTime > 1.2)
        {
            maxCounterTime -= 0.1;
        }
    }
    int randomNumber = arc4random()%feedbackArray.count;
    feedbackLabel.text = feedbackArray[randomNumber];
    feedbackLabel.alpha = 1.0;
    [feedbackAnimationView startCanvasAnimation];
    [UIView animateWithDuration:2.0 animations:^{
        feedbackLabel.alpha = 0.0;
    }];
    score += 1;
    scoreLabel.text = [NSString stringWithFormat:@"%li", score];
    [self startNextCommand];
}

- (IBAction)musicButtonPressed:(id)sender
{
    if (audioPlayer.playing)
    {
        [audioPlayer pause];
        [userDefaults setBool:YES forKey:@"Prefer Music Off"];
    }
    else
    {
        [audioPlayer play];
        [userDefaults setBool:NO forKey:@"Prefer Music Off"];
    }
    [userDefaults synchronize];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark GameOver

- (void)gameOver
{
    leaderLabel.alpha = 0.0;
    highscoreLabel.alpha = 1.0;
    gameModeSegmentedControl.alpha = 1.0;
    goButton.alpha = 1.0;
    [progressView setProgress:1.0];
    
    segmentedControlAnimationView.delay = 0.0;
    [segmentedControlAnimationView startCanvasAnimation];
    leaderAnimationView.delay = 0.0;
    [leaderAnimationView startCanvasAnimation];
    [timer invalidate];
    self.canDisplayBannerAds = YES;
    gamesPlayed ++;
    [self checkGamesPlayedCount];

    if (endlessMode)
    {
        [self reportScore:score forLeaderboardID:@"endless"];
    }
    else
    {
        [self reportScore:score forLeaderboardID:@"timed"];
    }
}

- (void)checkGamesPlayedCount
{
    NSLog(@"%i", gamesPlayed);
    if (gamesPlayed >= 3)
    {
        if (![userDefaults boolForKey:@"Ads Disabled"])
        {
            [self requestInterstitialAdPresentation];
        }
        gamesPlayed = 0;
    }
}

#pragma mark GameCenter

- (void) reportScore: (int64_t) gameScore forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = gameScore;
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        GKLeaderboard *leaderBoard = [[GKLeaderboard alloc] init];
        if (leaderBoard)
        {
            leaderBoard.identifier = identifier;
            leaderBoard.timeScope = GKLeaderboardTimeScopeAllTime;
            [leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
                GKScore *bestScore = scores[0];
                if (bestScore.value > score)
                {
                    highscoreLabel.text = [NSString stringWithFormat:@"%lli MORE TO GO", bestScore.value - score];
                }
                else if (bestScore.value == score)
                {
                    highscoreLabel.text = @"YOU TIED THE RECORD!";
                }
                else
                {
                    highscoreLabel.text = @"HOT DAMN! NEW RECORD!";
                }
                [highscoreAnimationView startCanvasAnimation];
            }];
        }
    }];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)leaderBoardButtonPressed:(id)sender
{
    GKGameCenterViewController *GKVC = [[GKGameCenterViewController alloc] init];
    GKVC.gameCenterDelegate = self;
    [self presentViewController:GKVC animated:YES completion:nil];
}

#pragma mark Gesture Recognizers

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


- (IBAction)didRecieveLongPress:(UILongPressGestureRecognizer *)sender
{
    lastGestureRecieved = @"PRESS";
}



#pragma mark Delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    return YES;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [audioPlayer play];
}

@end
