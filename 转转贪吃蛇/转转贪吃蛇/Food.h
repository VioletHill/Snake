//
//  Food.h
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import "CCSprite.h"

@interface Food : CCSprite

+(Food*) sharedFood;
+(void) purge;


-(CGSize)foodSize;


-(CCSprite*) createFood;


@end
