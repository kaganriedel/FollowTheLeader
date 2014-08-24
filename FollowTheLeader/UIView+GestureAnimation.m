//
//  UIView+GestureAnimation.m
//  Gesturements
//
//  Created by Kagan Riedel on 3/22/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "UIView+GestureAnimation.h"

@implementation UIView (GestureAnimation)

+(void)animate:(ANIMATION)animation view:(UIView*)view withDuration:(NSTimeInterval)duration
{
    //the "swipe" animations use CATransforms because autolayout was messing up CGAffineTransforms
    switch (animation) {
        case SwipeLeft:
        {
            [UIView animateWithDuration:duration animations:^{
                view.layer.transform = CATransform3DMakeTranslation(-700, 0, 0);
            }                     completion:^(BOOL finished) {
                view.layer.transform = CATransform3DIdentity;
            }];
            break;
        }
        case SwipeRight:
        {
            [UIView animateWithDuration:duration animations:^{
                view.layer.transform = CATransform3DMakeTranslation(700, 0, 0);
            }                     completion:^(BOOL finished) {
                view.layer.transform = CATransform3DIdentity;
            }];
            break;
        }
        case SwipeUp:
        {
            [UIView animateWithDuration:duration animations:^{
                view.layer.transform = CATransform3DMakeTranslation(0, -400, 0);
            }                     completion:^(BOOL finished) {
                view.layer.transform = CATransform3DIdentity;
            }];
            break;
        }
        case SwipeDown:
        {
            [UIView animateWithDuration:duration animations:^{
                view.layer.transform = CATransform3DMakeTranslation(0, 400, 0);
            }                     completion:^(BOOL finished) {
                view.layer.transform = CATransform3DIdentity;
            }];
            break;
        }
        case Pinch:
        {
            [UIView animateWithDuration:duration animations:^{
                view.transform = CGAffineTransformScale(view.transform, 0.0, 0.0);
            }                     completion:^(BOOL finished) {
                view.transform = CGAffineTransformIdentity;
            }];
            break;
        }
        case Tap:
        {
            [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.transform = CGAffineTransformScale(view.transform, 0.6, 0.6);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration/2 animations:^{
                    view.transform = CGAffineTransformIdentity;
                }];
            }];
            break;
        }
        case DoubleTap:
        {
            [UIView animateWithDuration:duration/4 animations:^{
                view.transform = CGAffineTransformScale(view.transform, 0.8, 0.8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration/4 animations:^{
                    view.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:duration/4 animations:^{
                        view.transform = CGAffineTransformScale(view.transform, 0.8, 0.8);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:duration/4 animations:^{
                            view.transform = CGAffineTransformIdentity;
                        }];
                    }];
                }];
            }];
            break;
        }
        case Press:
        {
            [UIView animateWithDuration:duration animations:^{
                view.transform = CGAffineTransformScale(view.transform, 0.0, 0.0);
            }                     completion:^(BOOL finished) {
                view.transform = CGAffineTransformIdentity;
            }];
            break;
        }
        default:
            break;
    }
}


@end
