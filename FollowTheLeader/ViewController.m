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
#import "ADDropDownMenuItemView.h"
#import "ADDropDownMenuView.h"

#define FONT_ALTEHAAS_REG(s) [UIFont fontWithName:@"AlteHaasGrotesk" size:s]

@interface ViewController () <UIGestureRecognizerDelegate, AVAudioPlayerDelegate, GKGameCenterControllerDelegate, ADDropDownMenuDelegate, UINavigationControllerDelegate>
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
    __weak IBOutlet CSAnimationView *settingsAnimationView;
    BKECircularProgressView *progressView;
    NSTimer *timer;
    NSString *gestureCommanded;
    NSString *lastGestureRecieved;
    NSArray *feedbackArray;
    NSUserDefaults *userDefaults;
    float maxCounterTime;
    float counter;
    long score;
    BOOL firstLoad;
    int lastRandomGesturePicked;
    int gamesPlayed;
    
    AVAudioPlayer *audioPlayer;
    GKPlayer *currentPlayer;
    ADDropDownMenuView *dropDownView;
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
    self.gameMode = GameModeEndless;
    maxCounterTime = 5.0;
    gamesPlayed = 0;
    firstLoad = YES;
    
    feedbackLabel.font = FONT_ALTEHAAS_REG(34);
    highscoreLabel.font = FONT_ALTEHAAS_REG(34);
    leaderLabel.font = FONT_ALTEHAAS_REG(52);
    goButton.titleLabel.font = FONT_ALTEHAAS_REG(52);
    scoreLabel.font = FONT_ALTEHAAS_REG(28);
    
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
    
    self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
    
    //Drop Down Menu
    ADDropDownMenuItemView *item1 = [[ADDropDownMenuItemView alloc] initWithSize: CGSizeMake(35, 35)];
    item1.tag = 1;
    [item1 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateNormal];
    [item1 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateHighlighted];
    [item1 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateSelected];

    [item1 setBackgroundImage:[UIImage imageNamed:@"settings"] forState:ADDropDownMenuItemViewStateNormal];
    [item1 setBackgroundImage:[UIImage imageNamed:@"settings"] forState:ADDropDownMenuItemViewStateHighlighted];
    [item1 setBackgroundImage:[UIImage imageNamed:@"settings"] forState:ADDropDownMenuItemViewStateSelected];
    item1.layer.cornerRadius = 10.0f;
    
    ADDropDownMenuItemView *item2 = [[ADDropDownMenuItemView alloc] initWithSize: CGSizeMake(35, 35)];
    item2.tag = 2;
    [item2 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateNormal];
    [item2 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateHighlighted];
    [item2 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateSelected];

    [item2 setBackgroundImage:[UIImage imageNamed:@"music"] forState:ADDropDownMenuItemViewStateNormal];
    [item2 setBackgroundImage:[UIImage imageNamed:@"music"] forState:ADDropDownMenuItemViewStateHighlighted];
    [item2 setBackgroundImage:[UIImage imageNamed:@"music"] forState:ADDropDownMenuItemViewStateSelected];
    item2.state = ADDropDownMenuItemViewStateHighlighted;
    item2.layer.cornerRadius = 10.0f;

    ADDropDownMenuItemView *item3 = [[ADDropDownMenuItemView alloc] initWithSize: CGSizeMake(35, 35)];
    item3.tag = 3;
    [item3 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateNormal];
    [item3 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateHighlighted];
    [item3 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateSelected];

    [item3 setBackgroundImage:[UIImage imageNamed:@"trophy_silver"] forState:ADDropDownMenuItemViewStateNormal];
    [item3 setBackgroundImage:[UIImage imageNamed:@"trophy_silver"] forState:ADDropDownMenuItemViewStateHighlighted];
    [item3 setBackgroundImage:[UIImage imageNamed:@"trophy_silver"] forState:ADDropDownMenuItemViewStateSelected];
    item3.state = ADDropDownMenuItemViewStateHighlighted;
    item3.layer.cornerRadius = 10.0f;

    ADDropDownMenuItemView *item4 = [[ADDropDownMenuItemView alloc] initWithSize: CGSizeMake(35, 35)];
    item4.tag = 4;
    [item4 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateNormal];
    [item4 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateHighlighted];
    [item4 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateSelected];

    [item4 setBackgroundImage:[UIImage imageNamed:@"iad_icon.jpg"] forState:ADDropDownMenuItemViewStateNormal];
    [item4 setBackgroundImage:[UIImage imageNamed:@"iad_icon.jpg"] forState:ADDropDownMenuItemViewStateHighlighted];
    [item4 setBackgroundImage:[UIImage imageNamed:@"iad_icon.jpg"] forState:ADDropDownMenuItemViewStateSelected];
    item4.state = ADDropDownMenuItemViewStateHighlighted;
    item4.layer.cornerRadius = 10.0f;

    dropDownView = [[ADDropDownMenuView alloc] initAtOrigin:CGPointMake(0, 8) withItemsViews:@[item1, item2, item3, item4]];
    dropDownView.delegate = self;
    
    [settingsAnimationView addSubview:dropDownView];

    //Audio

    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"Ghostwriter" ofType: @"mp3"];
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
        
        settingsAnimationView.type = CSAnimationTypeSlideLeft;
        settingsAnimationView.delay = 0.8;
        settingsAnimationView.duration = 1.5;
        [settingsAnimationView startCanvasAnimation];
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
        self.gameMode = GameModeEndless;
    }
    //timed
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        maxCounterTime = 50.0;
        self.gameMode = GameModeTimed;
    }
    else if (segmentedControl.selectedSegmentIndex == 2)
    {
        maxCounterTime = 2.0;
        self.gameMode = GameModeMemory;
    }
}
- (IBAction)goPressed:(UIButton *)sender
{
    if (self.gameMode == GameModeEndless)
    {
        maxCounterTime = 5.0;
    }
    else if (self.gameMode == GameModeTimed)
    {
        counter = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
    highscoreLabel.text = @"";
    goButton.alpha = 0.0;
    highscoreLabel.alpha = 0.0;
    leaderLabel.alpha = 1.0;
    scoreLabel.alpha = 1.0;
    gameModeSegmentedControl.alpha = 0.0;
    settingsAnimationView.alpha = 0.0;
    score = 0;
    scoreLabel.text = [NSString stringWithFormat:@"%li", score];
    [self startNextCommand];
    self.canDisplayBannerAds = NO;
}

- (void)startNextCommand
{
    if (self.gameMode == GameModeEndless)
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
    
    //make the timer be a shorter amount of time each correct answer to a minimum of 1.2 seconds
    if (self.gameMode == GameModeEndless)
    {
        [timer invalidate];
        if (maxCounterTime > 1.2)
        {
            maxCounterTime -= 0.1;
        }
    }
    
    score += 1;
    scoreLabel.text = [NSString stringWithFormat:@"%li", score];
    [self startNextCommand];
    
    //Every 5 points give feedback
    if (score %5 == 0)
    {
        int randomNumber = arc4random()%feedbackArray.count;
        feedbackLabel.text = feedbackArray[randomNumber];
        feedbackLabel.alpha = 1.0;
        [feedbackAnimationView startCanvasAnimation];
        [UIView animateWithDuration:3.0 animations:^{
            feedbackLabel.alpha = 0.0;
        }];
    }
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
    settingsAnimationView.alpha = 1.0;
    [progressView setProgress:1.0];
    
    segmentedControlAnimationView.delay = 0.0;
    [segmentedControlAnimationView startCanvasAnimation];
    leaderAnimationView.delay = 0.0;
    [leaderAnimationView startCanvasAnimation];
    settingsAnimationView.delay = 0.0;
    [settingsAnimationView startCanvasAnimation];
    
    [timer invalidate];
    if (![userDefaults boolForKey:@"Ads Disabled"])
    {
        self.canDisplayBannerAds = YES;
    }
    gamesPlayed ++;
    [self checkGamesPlayedCount];

    if (self.gameMode == GameModeEndless)
    {
        [self reportScore:score forLeaderboardID:@"endless"];
    }
    else if (self.gameMode == GameModeTimed)
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
    //grab the local userDefaults highscore first
    NSString *highScoreKey;
    if (self.gameMode == GameModeEndless)
    {
        highScoreKey = @"endlessHighScore";
    }
    else if (self.gameMode == GameModeTimed)

    {
        highScoreKey = @"timedHighScore";
    }
    
    int yourHighScore;
    yourHighScore = [userDefaults integerForKey:highScoreKey];

    //then push to GameCenter if it's available
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = gameScore;
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        GKLeaderboard *leaderBoard = [[GKLeaderboard alloc] init];
        if (leaderBoard)
        {
            leaderBoard.identifier = identifier;
            leaderBoard.timeScope = GKLeaderboardTimeScopeAllTime;
            [leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
                if (!error)
                {
                    GKScore *bestScore = scores[0];
                    if (bestScore.value > score)
                    {
                        highscoreLabel.text = [NSString stringWithFormat:@"%lli MORE FOR THE RECORD", bestScore.value - score];
                    }
                    else if (bestScore.value == score)
                    {
                        highscoreLabel.text = @"YOU TIED THE RECORD!";
                    }
                    else
                    {
                        highscoreLabel.text = @"HOT DAMN NEW RECORD!";
                    }
                    [highscoreAnimationView startCanvasAnimation];
                }
                //if gamecenter isn't available
                else
                {
                    if (yourHighScore > score)
                    {
                        highscoreLabel.text = [NSString stringWithFormat:@"%li MORE FOR YOUR RECORD", yourHighScore - score];
                    }
                    else if (yourHighScore == score)
                    {
                        highscoreLabel.text = @"YOU TIED YOUR RECORD!";
                    }
                    else
                    {
                        highscoreLabel.text = @"HOT DAMN NEW RECORD!";
                    }
                    [highscoreAnimationView startCanvasAnimation];

                }
                //always save the local high score
                if (score > yourHighScore)
                {
                    [userDefaults setInteger:score forKey:highScoreKey];
                }
                [userDefaults synchronize];
            }];
        }
    }];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)ADDropDownMenu:(ADDropDownMenuView *)view didSelectItem:(ADDropDownMenuItemView *)item
{
    if (item.tag == 2)
    {
        NSLog(@"Music Tapped");
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
    else if (item.tag == 3)
    {
        NSLog(@"Leaders Tapped");
        GKGameCenterViewController *GKVC = [[GKGameCenterViewController alloc] init];
        GKVC.gameCenterDelegate = self;
        [self presentViewController:GKVC animated:YES completion:nil];
    }
    else if (item.tag == 4)
    {
        NSLog(@"Ads Tapped");
        if (![userDefaults boolForKey:@"Ads Disabled"])
        {
            self.canDisplayBannerAds = NO;
            [userDefaults setBool:YES forKey:@"Ads Disabled"];
        }
        else
        {
            self.canDisplayBannerAds = YES;
            [userDefaults setBool:NO forKey:@"Ads Disabled"];
        }
        [userDefaults synchronize];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]] || [touch.view isKindOfClass:[ADDropDownMenuItemView class]])
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
