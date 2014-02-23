//
//  Gravity.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-31.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import "Gravity.h"
#import <CoreMotion/CoreMotion.h>

@interface Gravity ()

@end

@implementation Gravity
{
    CMMotionManager* motionManager;
}

-(instancetype) init
{
    if (self=[super init])
    {
        motionManager=[[[CMMotionManager alloc] init] retain];
        motionManager.accelerometerUpdateInterval=0.01;
        [motionManager startAccelerometerUpdates];
    }
    return self;
}

-(Vector) getDirctionVector
{
    motionManager=[[CMMotionManager alloc] init];

    double rotationRate = motionManager.deviceMotion.gravity.x;
    NSLog(@"%f",rotationRate);
//    float rotationX = rotationRate.x;
//    float rotationY = rotationRate.y;
//    float rotationZ = rotationRate.z;
//    NSLog(@"%f",rotationX);
//    return VHMakeVector(rotationX, rotationY);
//    double gravityX = self.motionManager.deviceMotion.gravity.x;
//    double gravityY = self.motionManager.deviceMotion.gravity.y;
//    double gravityZ = self.motionManager.deviceMotion.gravity.z;
//    return VHMakeVector(gravityX, gravityY);
}

@end
