//
//  SimpleAudioEngine+MusicAndEffect.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 14-2-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "SimpleAudioEngine+MusicAndEffect.h"
#include "UserData.h"

@implementation SimpleAudioEngine (MusicAndEffect)


-(void) playBgm
{
    if ([[UserData sharedUserData] isNeedBackgroundMusic])
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.mp3"];
    }
}

-(void) playBackEffect
{
    if ([[UserData sharedUserData] isNeedEffect])
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"back.wav"];
    }
}

-(void) playButtonEffect
{
    if ([[UserData sharedUserData] isNeedEffect])
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"button.wav"];
    }
}

-(void) playEatEffect
{
    if  ([[UserData sharedUserData]  isNeedEffect])
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"eat.wav"];
    }
}

@end
