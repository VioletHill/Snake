//
//  Model.h
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import "cocos2d.h"
#import "GameLayer.h"

typedef NS_ENUM(int, GameModel)
{
    kRocker=0,
    kGravity=1,
}GameModel;

@interface Model : CCLayer<CCTouchOneByOneDelegate>

-(Vector) getDirctionVector;

@end
