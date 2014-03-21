//
//  ViewController.h
//  FollowTheLeader
//
//  Created by 612 Development LLC on 3/1/14.
//  Copyright (c) 612 Development LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GameMode)
{
    GameModeEndless,
    GameModeTimed,
    GameModeMemory
};

@interface ViewController : UIViewController

@property (nonatomic) GameMode gameMode;

@end
