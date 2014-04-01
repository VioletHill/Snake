//
//  Model.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import "Model.h"
#import "Rocker.h"
#import "Gravity.h"

@implementation Model

+(Model*)instanceTypeWithGameModel:(GameModel)model
{
    if (model==kGravity) return [Gravity node];
    else return [Rocker node];
}

static GameModel gameModel=kRocker;

+(void) setGameModel:(GameModel *)model
{
    gameModel=model;
}

+(GameModel)getGameModel
{
    return gameModel;
}

-(Vector) getDirctionVector
{
    return VHMakeVector(0, 0);
}

-(void)purgeModel
{
    if ([Model getGameModel]==kGravity)
    {
        [(Gravity*)self closeMotionManager];
    }
    else
    {
        [self removeFromParentAndCleanup:YES];
    }
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return [super ccTouchBegan:touch withEvent:event];
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}


@end
