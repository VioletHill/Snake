//
//  Model.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import "Model.h"

@implementation Model

-(Vector) getDirctionVector
{
    return VHMakeVector(0, 0);
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
