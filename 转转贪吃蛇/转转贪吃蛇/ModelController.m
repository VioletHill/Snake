//
//  ModelController.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import "ModelController.h"
#import "Rocker.h"

@implementation ModelController

static ModelController* modelController = nil;

+(ModelController*) sharedModelController
{
    if (modelController==nil)
    {
        modelController=[[ModelController alloc] init];
    }
    return modelController;
}

+(void)purge
{
    [modelController release];
    modelController=nil;
}

@end
