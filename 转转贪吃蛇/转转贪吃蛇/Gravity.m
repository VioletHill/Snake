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
        motionManager=[[CMMotionManager alloc] init];
        motionManager.accelerometerUpdateInterval=0.01;
        [motionManager startAccelerometerUpdates];
    }
    return self;
}

-(Vector) getDirctionVector
{
    CMRotationRate rotationRate = motionManager.deviceMotion.rotationRate;
    float rotationX = rotationRate.x;
    float rotationY = rotationRate.y;
    float rotationZ = rotationRate.z;
    return VHMakeVector(rotationX, rotationY);
//    double gravityX = self.motionManager.deviceMotion.gravity.x;
//    double gravityY = self.motionManager.deviceMotion.gravity.y;
//    double gravityZ = self.motionManager.deviceMotion.gravity.z;
//    return VHMakeVector(gravityX, gravityY);
}

@end
