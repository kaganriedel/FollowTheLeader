//
//  main.m
//  FollowTheLeader
//
//  Created by Kagan Riedel on 3/1/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

@implementation UIColor (mathletes)

+(UIColor*)myLightBlueColor
{
    UIColor *color = [UIColor colorWithRed:32.0/255.0 green:127.0/255.0 blue:178.0/255.0 alpha:1];
    return color;
}

+(UIColor*)myDarkGrayColor
{
    UIColor *color = [UIColor colorWithRed:(58.0/255.0) green:(57.0/255.0) blue:(67.0/255.0) alpha:0.9];
    return color;
}

+(UIColor*)myRedColor
{
    UIColor *color = [UIColor colorWithRed:241.0/255.0 green:37.0/255.0 blue:63.0/255.0 alpha:1];
    return color;
}


+(UIColor*)myBlueColor
{
    UIColor *color = [UIColor colorWithRed:(13.0/255.0) green:(166.0/255.0) blue:(238/255.0) alpha:1];
    return color;
}

@end