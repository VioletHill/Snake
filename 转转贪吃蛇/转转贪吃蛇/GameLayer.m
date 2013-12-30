//
//  GameLayer.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright 2013年 邱峰. All rights reserved.
//

#import "GameLayer.h"
#import "Snake.h"
#import "Food.h"
#import "Rocker.h"

@interface GameLayer()

@end

@implementation GameLayer
{
    int score;
    CCSprite* food;
    Snake* snake;
    Model* rocker;
    CGSize winSize;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



-(instancetype) init
{
    if (self=[super init])
    {
        winSize=[[CCDirector sharedDirector] winSize];
        [self addBg];

        [self addRocker];
        
        snake=[Snake node];
        snake.position=CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:snake];
        [self addFood];
        [self scheduleUpdate];
       // [self schedule:@selector(time:) interval:1];
    }
    return self;
}

-(void)addBg
{
    CCSprite* sprite=[CCSprite spriteWithFile:@"gameLayerBg.png"];
    sprite.position=CGPointMake(winSize.width/2, winSize.height/2);
    [self addChild:sprite];
}

-(void)addRocker
{
    rocker=[Rocker node];
    rocker.position=CGPointMake(winSize.width-rocker.contentSize.width, 100);
    [self addChild:rocker];

}

-(void)addFood
{
    food=[[Food sharedFood] createFood];
    int x=arc4random()% (int)winSize.width;
    int y=arc4random()% (int)winSize.height;
    [food setPosition:CGPointMake(x, y)];
    [self addChild:food];
}

-(void)eatFood
{
    [food removeFromParentAndCleanup:YES];
    [snake addBody];
    [self addFood];
}

-(BOOL)isEatFood
{
    CGPoint snakePosition=[snake getHeadPosition];
    CGPoint foodPosition=food.position;
    return isCollision(snakePosition, foodPosition);
}

-(void)update:(ccTime)delta
{
    if ([self isEatFood])
    {
        [self eatFood];
    }
    [snake move:rocker.getDirctionVector];
}

-(void)time:(ccTime)delte
{
    [snake move:rocker.getDirctionVector];

}


@end
