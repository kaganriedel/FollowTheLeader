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
#import "TutorialViewController.h"
#import "UIView+GestureAnimation.h"

#define FONT_ALTEHAAS_REG(s) [UIFont fontWithName:@"AlteHaasGrotesk" size:s]
static NSTimeInterval animationDuration = 0.3;

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
    __weak IBOutlet UIImageView *titleImageView;
    BKECircularProgressView *progressView;
    NSTimer *gameTimer;
    NSTimer *memoryGameDemonstrationTimer;
    NSString *gestureCommanded;
    NSString *lastGestureRecieved;
    NSArray *feedbackArray;
    NSArray *gestures;
    NSMutableArray *memoryGameGestures;
    NSUserDefaults *userDefaults;
    float maxCounterTime;
    int memoryCounter;
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
    
    self.view.backgroundColor = [UIColor myDarkGrayColor];
    feedbackLabel.textColor = [UIColor myRedColor];
    highscoreLabel.textColor = [UIColor myRedColor];
    scoreLabel.textColor = [UIColor whiteColor];
    gameModeSegmentedControl.tintColor = [UIColor myBlueColor];
    
    
    feedbackLabel.font = FONT_ALTEHAAS_REG(40);
    highscoreLabel.font = FONT_ALTEHAAS_REG(34);
    leaderLabel.font = FONT_ALTEHAAS_REG(52);
    goButton.titleLabel.font = FONT_ALTEHAAS_REG(52);
    scoreLabel.font = FONT_ALTEHAAS_REG(28);
    
    progressView = [[BKECircularProgressView alloc] initWithFrame:CGRectMake(15, 7, 30, 30)];
    [progressView setProgressTintColor:[UIColor myBlueColor]];
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
    
    feedbackArray = @[@"NICE", @"RAWR", @"MARVELOUS", @"CALIENTE", @"EN FUEGO", @"ROCKSTAR", @"BOOM SHAKALAKA", @"UNSTOPPABLE", @"AMAZING", @"RIDICULOUS", @"STELLAR", @"SMASHING", @"BANGIN", @"INCREDIBLE", @"SHUT THE FRONT DOOR", @"NO WAY", @"KILLER", @"SILLY GOOD", @"PERFECTION", @"REVOLUTIONARY", @"GREAT", @"INCENDIARY", @"UNBELIEVABLE", @"FANTASTIC", @"FABULOUS", @"TERRIFIC", @"EXCELLENT", @"MAGNIFICENT", @"SUPERB", @"ASTONISHING", @"BRILLIANT", @"STUPENDOUS", @"TREMENDOUS", @"AWESOME", @"SENSATIONAL", @"AWE INSPIRING", @"PEACHY", @"GROOVY", @"DYNAMITE", @"DAZZLING", @"DIVINE", @"GLORIOUS", @"ELECTRIFYING", @"GORGEOUS", @"ADMIRABLE", @"BLISSFUL", @"BRAVO", @"ENCORE", @"CLASSIC", @"EXQUISITE", @"GENIUS", @"IMPRESSIVE", @"KEEN", @"PHENOMENAL", @"POWERFUL", @"QUALITY", @"REMARKABLE", @"SPARKLING", @"STUNNING", @"UNREAL", @"VICTORY", @"WONDROUS", @"WONDERFUL", @"WOW"];
    
    gestures = @[@"TAP", @"DOUBLE TAP", @"PINCH", @"SWIPE RIGHT", @"SWIPE LEFT", @"SWIPE UP", @"SWIPE DOWN", @"PRESS"];
    
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
    
    ADDropDownMenuItemView *item2 = [[ADDropDownMenuItemView alloc] initWithSize: CGSizeMake(35, 35)];
    item2.tag = 2;
    [item2 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateNormal];
    [item2 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateHighlighted];
    [item2 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateSelected];

    [item2 setBackgroundImage:[UIImage imageNamed:@"music"] forState:ADDropDownMenuItemViewStateNormal];
    [item2 setBackgroundImage:[UIImage imageNamed:@"music"] forState:ADDropDownMenuItemViewStateHighlighted];
    [item2 setBackgroundImage:[UIImage imageNamed:@"music"] forState:ADDropDownMenuItemViewStateSelected];

    ADDropDownMenuItemView *item3 = [[ADDropDownMenuItemView alloc] initWithSize: CGSizeMake(35, 35)];
    item3.tag = 3;
    [item3 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateNormal];
    [item3 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateHighlighted];
    [item3 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateSelected];

    [item3 setBackgroundImage:[UIImage imageNamed:@"trophy_silver"] forState:ADDropDownMenuItemViewStateNormal];
    [item3 setBackgroundImage:[UIImage imageNamed:@"trophy_silver"] forState:ADDropDownMenuItemViewStateHighlighted];
    [item3 setBackgroundImage:[UIImage imageNamed:@"trophy_silver"] forState:ADDropDownMenuItemViewStateSelected];

    ADDropDownMenuItemView *item4 = [[ADDropDownMenuItemView alloc] initWithSize: CGSizeMake(35, 35)];
    item4.tag = 4;
    [item4 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateNormal];
    [item4 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateHighlighted];
    [item4 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateSelected];

    [item4 setBackgroundImage:[UIImage imageNamed:@"iad_icon.jpg"] forState:ADDropDownMenuItemViewStateNormal];
    [item4 setBackgroundImage:[UIImage imageNamed:@"iad_icon.jpg"] forState:ADDropDownMenuItemViewStateHighlighted];
    [item4 setBackgroundImage:[UIImage imageNamed:@"iad_icon.jpg"] forState:ADDropDownMenuItemViewStateSelected];
    
    ADDropDownMenuItemView *item5 = [[ADDropDownMenuItemView alloc] initWithSize: CGSizeMake(35, 35)];
    item5.tag = 5;
    [item5 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateNormal];
    [item5 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateHighlighted];
    [item5 setBackgroundColor:[UIColor clearColor] forState:ADDropDownMenuItemViewStateSelected];
    
    item5.titleLabel.text = @"?";
//    [item5 setBackgroundImage:[UIImage imageNamed:@"iad_icon.jpg"] forState:ADDropDownMenuItemViewStateNormal];
//    [item5 setBackgroundImage:[UIImage imageNamed:@"iad_icon.jpg"] forState:ADDropDownMenuItemViewStateHighlighted];
//    [item5 setBackgroundImage:[UIImage imageNamed:@"iad_icon.jpg"] forState:ADDropDownMenuItemViewStateSelected];


    dropDownView = [[ADDropDownMenuView alloc] initAtOrigin:CGPointMake(0, 8) withItemsViews:@[item1, item2, item3, item4, item5]];
    dropDownView.delegate = self;
    dropDownView.shouldExchangeItems = NO;
    
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
        feedbackLabel.text = @"ENDLESS";
        maxCounterTime = 5.0;
        self.gameMode = GameModeEndless;

    }
    //timed
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        feedbackLabel.text = @"TIMED";
        maxCounterTime = 50.0;
        self.gameMode = GameModeTimed;
    }
    else if (segmentedControl.selectedSegmentIndex == 2)
    {
        feedbackLabel.text = @"MEMORY";
        maxCounterTime = 2.0;
        self.gameMode = GameModeMemory;
    }
    
    feedbackLabel.alpha = 1.0;
    feedbackAnimationView.type = CSAnimationTypeZoomOut;
    [feedbackAnimationView startCanvasAnimation];
    [UIView animateWithDuration:4.0 animations:^{
        feedbackLabel.alpha = 0.0;
    }];
}

- (IBAction)goPressed:(UIButton *)sender
{
    feedbackAnimationView.type = CSAnimationTypeBounceDown;
    feedbackAnimationView.alpha = 0.0;
    highscoreLabel.text = @"";
    goButton.alpha = 0.0;
    highscoreLabel.alpha = 0.0;
    leaderLabel.alpha = 1.0;
    scoreLabel.alpha = 1.0;
    gameModeSegmentedControl.alpha = 0.0;
    settingsAnimationView.alpha = 0.0;
    score = 0;
    scoreLabel.text = [NSString stringWithFormat:@"%li", score];
    self.canDisplayBannerAds = NO;
    
    if (self.gameMode == GameModeEndless)
    {
        maxCounterTime = 5.0;
        [self startNextCommand];
    }
    else if (self.gameMode == GameModeTimed)
    {
        counter = 0;
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [self startNextCommand];
    }
    else if (self.gameMode == GameModeMemory)
    {
        counter = 0;
        [self demoMemoryGameGestures];
    }
}

- (void)startNextCommand
{
    leaderLabel.textColor = [UIColor whiteColor];
    if (self.gameMode == GameModeEndless || self.gameMode == GameModeMemory)
    {
        counter = 0;
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
    if (self.gameMode != GameModeMemory)
    {
        feedbackLabel.alpha = 0.0;
        gestureCommanded = leaderLabel.text = [self pickRandomGesture];
    }
    else if (self.gameMode == GameModeMemory)
    {
        gestureCommanded = memoryGameGestures[memoryCounter];
        leaderLabel.text = [NSString stringWithFormat:@"%i", memoryCounter +1];
    }
}

- (NSString *) pickRandomGesture
{
    int randomNumber = arc4random()%gestures.count;
    if (randomNumber == lastRandomGesturePicked && randomNumber > 0)
    {
        randomNumber --;
    }
    else if (randomNumber == lastRandomGesturePicked && randomNumber == 0)
    {
        randomNumber = gestures.count - 1;
    }
    lastRandomGesturePicked = randomNumber;
    switch (randomNumber) {
        case 0:
            return gestures[0];
            break;
        case 1:
            return gestures[1];
            break;
        case 2:
            return gestures[2];
            break;
        case 3:
            return gestures[3];
            break;
        case 4:
            return gestures[4];
            break;
        case 5:
            return gestures[5];
            break;
        case 6:
            return gestures[6];
            break;
        case 7:
            return gestures[7];
            break;
        default:
            return nil;
            break;
    }
}

- (void)demoMemoryGameGestures
{
    leaderLabel.text = @"PAY ATTENTION";
    leaderLabel.textColor = [UIColor myRedColor];
    [progressView setProgress:1.0];
    if (!memoryGameGestures) {
        memoryGameGestures = [NSMutableArray new];
    }
    //if it's the first turn, add in 3 gestures
    if (score == 0)
    {
        for (int x = 0; x < 2; x++)
        {
            [memoryGameGestures addObject:[self pickRandomGesture]];
        }
    }
    //else add 1 gesture
    else
    {
        [memoryGameGestures addObject:[self pickRandomGesture]];
    }
    NSLog(@"Memory Game Gestures: %lu",(unsigned long)memoryGameGestures.count);
    memoryGameDemonstrationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(demonstrationTimerFired) userInfo:nil repeats:YES];
}

-(void)demonstrationTimerFired
{
    leaderLabel.textColor = [UIColor whiteColor];
    leaderLabel.text = memoryGameGestures[(int)counter];
    counter += 1.0;
    if ((int)counter >= memoryGameGestures.count)
    {
        [memoryGameDemonstrationTimer invalidate];
        memoryCounter = 0;
        
        [self performSelector:@selector(yourTurnReadyGo) withObject:nil afterDelay:1.0];
    }
}

-(void)yourTurnReadyGo
{
    feedbackLabel.alpha = 0.0;

    leaderLabel.text = @"YOUR TURN";
    leaderLabel.textColor = [UIColor myRedColor];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ready) userInfo:nil repeats:NO];
}

-(void)ready
{
    leaderLabel.text = @"READY?";
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(go) userInfo:nil repeats:NO];
}

-(void)go
{
    leaderLabel.text = @"GO";
    [UIView animateWithDuration:2.0 animations:^{
        feedbackLabel.alpha = 0.0;
    }];
    lastGestureRecieved = nil;
    [self performSelector:@selector(startNextCommand) withObject:nil afterDelay:1.0];
}

- (void)timerFired
{
    counter += 0.01;
    [progressView setProgress:counter/maxCounterTime];
    if (counter >= maxCounterTime)
    {
        [self gameOver];
    }
    else if ([gestureCommanded isEqualToString:lastGestureRecieved])
    {
        [self animateViewForGesture:gestureCommanded forDuration:animationDuration];
        [self correct];
    }
}

- (void)correct
{
    score += 1;
    lastGestureRecieved = @"";
    gestureCommanded = nil;
    [progressView setProgress:0.0];
    
    if (self.gameMode == GameModeEndless || self.gameMode == GameModeMemory)
    {
        [gameTimer invalidate];
    }
    //make the timer be a shorter amount of time each correct answer to a minimum of 1.2 seconds
    if (self.gameMode == GameModeEndless)
    {
        if (maxCounterTime > 1.2)
        {
            maxCounterTime -= 0.1;
        }
    }
    
    if (self.gameMode == GameModeMemory)
    {
        memoryCounter ++;
        if (memoryCounter < memoryGameGestures.count)
        {
            [self performSelector:@selector(startNextCommand) withObject:nil afterDelay:animationDuration];
        }
        else
        {
            [progressView setProgress:0.0];
            [self performSelector:@selector(givePositiveFeedback) withObject:nil afterDelay:animationDuration];
        }
    }
    else
    {
        [self performSelector:@selector(startNextCommand) withObject:nil afterDelay:animationDuration];
    }
    scoreLabel.text = [NSString stringWithFormat:@"%li", score];
    
    //Every 5 points give feedback
    if (score %5 == 0 && self.gameMode != GameModeMemory)
    {
        [self givePositiveFeedback];
    }
}

-(void)animateViewForGesture:(NSString*)gesture forDuration:(NSTimeInterval)duration
{
    if ([gesture isEqualToString:@"TAP"])
    {
        
        [UIView animate:Tap view:leaderLabel withDuration:duration];
    }
    else if ([gesture isEqualToString:@"DOUBLE TAP"])
    {
        [UIView animate:DoubleTap view:leaderLabel withDuration:duration];
    }
    else if ([gesture isEqualToString:@"PINCH"])
    {
        [UIView animate:Pinch view:leaderLabel withDuration:duration];
    }
    else if ([gesture isEqualToString:@"PRESS"])
    {
        [UIView animate:Press view:leaderLabel withDuration:duration];
    }
    else if ([gesture isEqualToString:@"SWIPE LEFT"])
    {
        [UIView animate:SwipeLeft view:leaderLabel withDuration:duration];
    }
    else if ([gesture isEqualToString:@"SWIPE RIGHT"])
    {
        [UIView animate:SwipeRight view:leaderLabel withDuration:duration];
    }
    else if ([gesture isEqualToString:@"SWIPE UP"])
    {
        [UIView animate:SwipeUp view:leaderLabel withDuration:duration];
    }
    else if ([gesture isEqualToString:@"SWIPE DOWN"])
    {
        [UIView animate:SwipeDown view:leaderLabel withDuration:duration];
    }
}

-(void)givePositiveFeedback
{
    if (self.gameMode == GameModeMemory)
    {
        leaderLabel.text = @"";
    }
    int randomNumber = arc4random()%feedbackArray.count;
    feedbackLabel.text = feedbackArray[randomNumber];
    feedbackAnimationView.alpha = 1.0;
    feedbackLabel.alpha = 1.0;
    [feedbackAnimationView startCanvasAnimation];
    [UIView animateWithDuration:2.0 animations:^{
        feedbackLabel.alpha = 0.0;

    } completion:^(BOOL finished) {
        if (self.gameMode == GameModeMemory)
        {
            [self demoMemoryGameGestures];
        }
    }];
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
    feedbackAnimationView.alpha = 0.0;
    gameModeSegmentedControl.alpha = 1.0;
    settingsAnimationView.alpha = 1.0;
    [progressView setProgress:1.0];
    
    //have the uiimageview animate the Gesturements intro animation in, then have the button alpha to 1.0. this will have a cooler animation and prevent the user from accidently tapping the goButton and starting a new game
    goButton.alpha = 1.0;

    
    segmentedControlAnimationView.delay = 0.0;
    [segmentedControlAnimationView startCanvasAnimation];
    leaderAnimationView.delay = 0.0;
    [leaderAnimationView startCanvasAnimation];
    settingsAnimationView.delay = 0.0;
    [settingsAnimationView startCanvasAnimation];
    
    [gameTimer invalidate];
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
    else if (self.gameMode == GameModeMemory)
    {
        [self reportScore:score forLeaderboardID:@"memory"];
        memoryGameGestures = nil;
    }
}

- (void)checkGamesPlayedCount
{
    NSLog(@"Games Played = %i", gamesPlayed);
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
    else if (self.gameMode == GameModeMemory)
    {
        highScoreKey = @"memoryHighScore";
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
    else if (item.tag == 5)
    {
        [self performSegueWithIdentifier:@"tutorial segue" sender:self];
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
