//
//  GameCenterHandler.h
//  Gesturements
//
//  Created by Kagan Riedel on 3/14/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterHandler : NSObject
{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property (assign, readonly) BOOL gameCenterAvailable;

+ (GameCenterHandler *)sharedInstance;
- (void)authenticateLocalUser;

@end