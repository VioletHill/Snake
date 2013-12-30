//
//  ModelController.h
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, OperateModel)
{
    kGravity=0,
    kRocker=1,
};

@interface ModelController : NSObject


+(ModelController*) sharedModelController;
+(void)purge;

@property (nonatomic,readwrite) OperateModel operateModel;

@end
