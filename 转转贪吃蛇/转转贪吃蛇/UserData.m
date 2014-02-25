//
//  UseData.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-30.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

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

@end
