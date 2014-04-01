//
//  CCLabelTTF+ScoreLable.h
//  转转贪吃蛇
//
//  Created by 邱峰 on 14-2-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "CCLabelTTF.h"

@interface CCLabelTTF (ScoreLable)

+(CCLabelTTF*) labelWithScore:(int)score;

+(CCLabelTTF*) labelWithScore:(int)score andFont:(int)font;

@end
