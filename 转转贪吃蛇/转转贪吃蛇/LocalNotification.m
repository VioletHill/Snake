//
//  LocalNotification.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 14-2-24.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "LocalNotification.h"

@implementation LocalNotification

static LocalNotification* _localNotification=nil;

+(LocalNotification*)sharedLoaclNotification
{
    if (_localNotification==nil)
    {
        _localNotification=[[LocalNotification alloc] init];
    }
    return _localNotification;
}

-(NSArray*) getNotificationMessage
{
    NSString* filePath=[[NSBundle mainBundle] pathForResource:@"notificationMessage" ofType:@"plist"];
    NSMutableArray* content=[[[NSMutableArray alloc] initWithContentsOfFile:filePath] autorelease];
    
    for (int i=0; i<content.count; i++) {
        int random=arc4random()%(content.count-1);
        id x=[[content objectAtIndex:random] copy];
        id y=[[content objectAtIndex:i] copy];
        [content replaceObjectAtIndex:i withObject:x];
        [content replaceObjectAtIndex:random withObject:y];
    }
    
    int index=0;
    while (content.count<30)
    {
        [content addObject:[[content objectAtIndex:index] copy]];
        index++;
    }
    
    for (int i=0; i<content.count; i++)
    {
        NSLog(@"%@",[content objectAtIndex:i]);
    }
    return content;
}

-(void) pushNotifation
{
 
    NSTimeInterval aDay = 24*60*60;
    
    NSArray* message=[self getNotificationMessage];
    
    for (int i=0; i<message.count; i++)
    {
        UILocalNotification* notification=[[[UILocalNotification alloc] init] autorelease];
        NSDate* pushDate=[NSDate dateWithTimeIntervalSinceNow:(i+1)*aDay];
        notification.fireDate=pushDate;
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.repeatInterval=NSCalendarUnitMonth;
        notification.soundName=UILocalNotificationDefaultSoundName;
        notification.alertBody=[message objectAtIndex:i];
        notification.applicationIconBadgeNumber=i+1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void) cancelNotifation
{
    UIApplication *app = [UIApplication sharedApplication];
    
    app.applicationIconBadgeNumber=0;
    
    //获取本地推送数组
    NSArray *localArray = [app scheduledLocalNotifications];
    //声明本地通知对象
    if (localArray)
    {
        for (UILocalNotification *noti in localArray)
        {
             [app cancelLocalNotification:noti];
        }
    }
}

@end
