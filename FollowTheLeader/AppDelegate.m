//
//  AppDelegate.m
//  FollowTheLeader
//
//  Created by 612 Development LLC on 3/1/14.
//  Copyright (c) 612 Development LLC. All rights reserved.
//

#import "AppDelegate.h"
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "TestFlight.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIViewController prepareInterstitialAds];
    
    [TestFlight takeOff:@"f289ad7c-aeb4-4fce-a6ed-b9fb10c80cda"];
    [self authenticateLocalPlayer];

    return YES;
}

- (void) authenticateLocalPlayer
{
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil)
        {
            [self showAuthenticationDialog: viewController];
        }
        else if (localPlayer.isAuthenticated)
        {
            [self enableGameCenter: localPlayer];
        }
        else
        {
            [self disableGameCenter];
        }
    };
}

-(void)showAuthenticationDialog:(UIViewController*)viewController
{
    
    [self.window.rootViewController presentViewController:viewController animated:YES completion:nil];
    
}

-(void)enableGameCenter:(GKLocalPlayer*)localPlayer
{
    NSLog(@"Game Center Enabled");
}

-(void)disableGameCenter
{
    NSLog(@"Game Center Disabled");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
