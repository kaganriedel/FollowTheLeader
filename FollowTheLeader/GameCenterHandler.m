//
//  GameCenterHandler.m
//  Gesturements
//
//  Created by Kagan Riedel on 3/14/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "GameCenterHandler.h"

@implementation GameCenterHandler

@synthesize gameCenterAvailable;

static GameCenterHandler *sharedHandler = nil;

+ (GameCenterHandler *) sharedInstance
{
    if (!sharedHandler)
    {
        sharedHandler = [[GameCenterHandler alloc] init];
    }
    return sharedHandler;
}

- (BOOL)isGameCenterAvailable
{
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init
{
    if ((self = [super init]))
    {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable)
        {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

- (void)authenticateLocalUser {
    
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Already authenticated!");
    }
}
@end
