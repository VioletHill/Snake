//
//  LocalNotification.h
//  转转贪吃蛇
//
//  Created by 邱峰 on 14-2-24.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotification : NSObject

+(LocalNotification*) sharedLoaclNotification;

-(void) pushNotifation;

-(void) cancelNotifation;

@end
