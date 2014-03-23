//
//  UIView+GestureAnimation.h
//  Gesturements
//
//  Created by Kagan Riedel on 3/22/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ANIMATION)
{
    SwipeLeft,
    SwipeRight,
    SwipeUp,
    SwipeDown,
    Tap,
    DoubleTap,
    Press,
    Pinch
};

@interface UIView (GestureAnimation)

+(void)animate:(ANIMATION)animation view:(UIView*)view withDuration:(NSTimeInterval)duration;

@end
