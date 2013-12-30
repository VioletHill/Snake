//
//  Food.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import "Food.h"

@implementation Food


static Food* food=nil;

+(Food*) sharedFood
{
    if (food==nil)
    {
        food=[[Food alloc] init];
    }
    return food;
}

+(void)purge
{
    [food release];
    food=nil;
}

-(CGSize)foodSize
{
    return CGSizeMake(40, 40);
}


-(CCSprite*) createFood
{
    int random=arc4random()%4+1;
    CCSprite* food=[CCSprite spriteWithFile:[NSString stringWithFormat:@"food%d.png",random]];
    return food;
}

@end
