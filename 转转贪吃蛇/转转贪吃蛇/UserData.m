//
//  UseData.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-30.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//
#import "SimpleAudioEngine.h"
#import "UserData.h"

@implementation UserData
{
    GameModel thisTimeModel;
    int thisTimeScore;
}

static UserData* userData=nil;
+(UserData*) sharedUserData
{
    if (userData==nil)
    {
        userData=[[UserData alloc] init];
    }
    return userData;
}

+(void)purge
{
    [userData release];
    userData=nil;
}

-(NSString*)getModelString:(GameModel)model
{
    if (model==kGravity) return @"gravityModelRecord";
    else return @"rockerModelRecord";
}

-(void) setNewRecord:(int)record inModel:(GameModel)model
{
    [[NSUserDefaults standardUserDefaults] setInteger:record forKey:[self getModelString:model]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(int) getRecordInModel:(GameModel)model
{
    id obj=[[NSUserDefaults standardUserDefaults] objectForKey:[self getModelString:model]];
    return [obj intValue];
}

-(BOOL) isNewRecord:(int)score inModel:(GameModel)model
{
    int record=[self getRecordInModel:model];
    if (score>record) return YES;
    else return NO;
}

-(void)setThisTimeScore:(int)score inModel:(GameModel)model
{
    thisTimeModel=model;
    thisTimeScore=score;
}

-(GameModel) getThisTimeModel
{
    return thisTimeModel;
}

-(int) getThisTimeScore
{
    return thisTimeScore;
}

-(BOOL) isNeedBackgroundMusic
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"isNeedBgm"];
}

-(BOOL) isNeedEffect
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"isNeedEffect"];
}

-(void) setIsNeedBackgroundMusic:(BOOL)is
{
    [[NSUserDefaults standardUserDefaults] setBool:is forKey:@"isNeedBgm"];
    if (is)
    {
        if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) return;
        else [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.mp3" loop:YES];
    }
}

-(void) setIsNeedEffect:(BOOL)is
{
    [[NSUserDefaults standardUserDefaults] setBool:is forKey:@"isNeedEffect"];
}

-(void) setEvaluate:(Evaluate)evaluate
{
    if (evaluate==kNextTime)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"Evaluate"];
    }
    else
    {
      [[NSUserDefaults standardUserDefaults] setObject:@(-1) forKey:@"Evaluate"];
    }
}

-(int) getPlayGameTime
{
    int times=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Evaluate"] intValue];
    if (times>=0)
    {
        times++;
        [[NSUserDefaults standardUserDefaults] setObject:@(times) forKey:@"Evaluate"];
    }
    return times;
}

-(Evaluate) getEvaluteType
{
    int times=[self getPlayGameTime];
    if (times<10) return kNever;
    else return kNextTime;
}

-(void) setDefaultSetting
{
    BOOL isFirstLaunch=![[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLaunch"] boolValue];
    if (isFirstLaunch)
    {
        [self setIsNeedEffect:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNeedBgm"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
        [self setEvaluate:kNextTime];
    }
}

@end
