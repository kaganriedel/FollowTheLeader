//
//  GestureAnimationView.m
//  Gesturements
//
//  Created by Kagan Riedel on 3/21/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "GestureAnimationView.h"

@implementation GestureAnimationView

-(void)animate:(ANIMATION)animation withDuration:(NSTimeInterval)duration
{
    //added extra set of curly braces for each case because of "switch case is in protected scope" warning
    switch (animation) {
        case SwipeLeft:
        {
            [UIView animateWithDuration:duration animations:^{
                self.layer.transform = CATransform3DMakeTranslation(-700, 0, 0);
            }                     completion:^(BOOL finished) {
                self.layer.transform = CATransform3DIdentity;
            }];
            break;
        }
        case SwipeRight:
        {
            [UIView animateWithDuration:duration animations:^{
                self.layer.transform = CATransform3DMakeTranslation(700, 0, 0);
            }                     completion:^(BOOL finished) {
                self.layer.transform = CATransform3DIdentity;
            }];
            break;
        }
        case SwipeUp:
        {
            [UIView animateWithDuration:duration animations:^{
                self.layer.transform = CATransform3DMakeTranslation(0, -400, 0);
            }                     completion:^(BOOL finished) {
                self.layer.transform = CATransform3DIdentity;
            }];
            break;
        }
        case SwipeDown:
        {
            [UIView animateWithDuration:duration animations:^{
                self.layer.transform = CATransform3DMakeTranslation(0, 400, 0);
            }                     completion:^(BOOL finished) {
                self.layer.transform = CATransform3DIdentity;
            }];
            break;
        }
        case Pinch:
        {
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformScale(self.transform, 0.0, 0.0);
            }                     completion:^(BOOL finished) {
                self.transform = CGAffineTransformIdentity;
            }];
            break;
        }
        case Tap:
        {
            [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformScale(self.transform, 0.6, 0.6);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration/2 animations:^{
                    self.transform = CGAffineTransformIdentity;
                }];
            }];
            break;
        }
        case DoubleTap:
        {
            [UIView animateWithDuration:duration/4 animations:^{
                self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration/4 animations:^{
                    self.transform = CGAffineTransformIdentity;

                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:duration/4 animations:^{
                        self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:duration/4 animations:^{
                            self.transform = CGAffineTransformIdentity;
                        }];
                    }];
                }];
            }];
            break;
        }
        case Press:
        {
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformScale(self.transform, 0.0, 0.0);
            }                     completion:^(BOOL finished) {
                self.transform = CGAffineTransformIdentity;
            }];
            break;
        }
        default:
            break;
            
    }
}

@end
