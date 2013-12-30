//
//  Snake.h
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

@interface Snake : CCSprite

-(void) move:(Vector)nextDirection;

-(void) addBody;

-(CGPoint) getHeadPosition;

@end
