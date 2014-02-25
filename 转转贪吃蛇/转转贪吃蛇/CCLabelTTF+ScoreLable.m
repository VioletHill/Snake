//
//  CCLabelTTF+ScoreLable.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 14-2-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "CCLabelTTF+ScoreLable.h"

@implementation CCLabelTTF (ScoreLable)

+(CCLabelTTF*) labelWithScore:(int)score
{
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        return [CCLabelTTF labelWithScore:score andFont:60];
    }
    else return [CCLabelTTF labelWithScore:score andFont:30];
}

+(CCLabelTTF*) labelWithScore:(int)score andFont:(int)font
{
    return  [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",score] fontName:@"Courier-Bold" fontSize:font];
}

@end
