//
//  Gravity.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-31.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import "Gravity.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreFoundation/CoreFoundation.h>


@interface Gravity ()

@property (nonatomic) CMMotionManager* motionManager;

@end


@implementation Gravity


@synthesize motionManager=_motionManager;

-(CMMotionManager*) motionManager
{
    if (_motionManager==nil)
    {
        _motionManager=[[CMMotionManager alloc] init];
    }
    return _motionManager;
}

-(instancetype) init
{
    if (self=[super init])
    {
        if (self.motionManager.isDeviceMotionAvailable)
        {
            [self.motionManager startDeviceMotionUpdates];
        }
    }
    return self;
}

-(void) openMotionManager
{
    self.motionManager.accelerometerUpdateInterval=0.01;
}

-(void) closeMotionManager
{
    [self.motionManager stopDeviceMotionUpdates];
}


+(BOOL) isDeviceMotionAvailable
{
    CMMotionManager* motion=[[[CMMotionManager alloc] init] autorelease];
    return motion.isDeviceMotionAvailable;
}

-(Vector) getDirctionVector
{
    double gravityX = self.motionManager.deviceMotion.gravity.x;
    double gravityY = self.motionManager.deviceMotion.gravity.y;
    return  VHMakeOneDistanceVectorByPoint(gravityY, -gravityX);

}

@end
