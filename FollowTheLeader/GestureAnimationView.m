//
//  GestureAnimationView.m
//  Gesturements
//
//  Created by Kagan Riedel on 3/21/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "GestureAnimationView.h"

@implementation GestureAnimationView

-(void)animate:(ANIMATION)animation;
{
    [UIView animateWithDuration:0.5 animations:^{
        switch (animation) {
            case SwipeLeft:
                self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -1000, 0);
                break;
                
            case Pinch:
                self.transform = CGAffineTransformScale(self.transform, 0.0, 0.0);
                break;
                
            default:
                break;
        }
    }
                     completion:^(BOOL finished) {
                         self.transform = CGAffineTransformIdentity;
                     }];
}

@end
