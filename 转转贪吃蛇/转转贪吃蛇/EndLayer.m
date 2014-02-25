//
//  EndLayer.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 14-2-24.
//  Copyright 2014年 邱峰. All rights reserved.
//

#import "EndLayer.h"
#import "UserData.h"
#import "StartLayer.h"
#import "GameLayer.h"
#import "CCLabelTTF+ScoreLable.h"

@implementation EndLayer
{
    CGSize winSize;
}


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EndLayer *layer = [EndLayer node];
	
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
        [self addScore];
        [self addRecordScore];
        [self addBack];
    }
    return self;
}

-(void)addBg
{
    CCSprite* bg=[CCSprite spriteWithFile:@"endBackground.png"];
    bg.position=CGPointMake(winSize.width/2, winSize.height/2);
    [self addChild:bg];
}

-(void) addScore
{
    CCLabelTTF* scoreLable=[CCLabelTTF labelWithScore:[[UserData sharedUserData] getThisTimeScore] ];
    [scoreLable setPosition:CGPointMake(winSize.width/2+50, winSize.height/2+60)];
    [self addChild:scoreLable];
}

-(void) addRecordScore
{
    GameModel model=[[UserData sharedUserData] getThisTimeModel];
    CCLabelTTF* recordLable=[CCLabelTTF labelWithScore:[[UserData sharedUserData] getRecordInModel:model] ];
    [recordLable setPosition:CGPointMake(winSize.width/2+50, winSize.height/2-10)];
    [self addChild:recordLable];
    
    int score=[[UserData sharedUserData] getThisTimeScore];
    
    if ([[UserData sharedUserData] isNewRecord:score inModel:model])
    {
        [[UserData sharedUserData] setNewRecord:score inModel:model];
    }

}

-(void) addBack
{
    CCMenuItemImage* backItem=[CCMenuItemImage itemWithNormalImage:@"gameoverReturn.png" selectedImage:@"gameoverReturnSelect.png" target:self selector:@selector(returnToStartLayer)];
    backItem.anchorPoint=ccp(1, 0);
    backItem.position=ccp(winSize.width/2-10,30);
    
    CCMenuItemImage* retry=[CCMenuItemImage itemWithNormalImage:@"gameoverRetry.png" selectedImage:@"gameoverRetrySelect.png" target:self selector:@selector(retry)];
    retry.anchorPoint=ccp(0, 0);
    retry.position=ccp(winSize.width/2+10,30);
    
    CCMenu* back=[CCMenu menuWithItems:backItem,retry, nil];
    back.anchorPoint=ccp(0, 0);
    back.position=ccp(0, 0);
    [self addChild:back];
}

-(void) returnToStartLayer
{
    CCScene* scene=[StartLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:scene]];
}

-(void) retry
{
    CCScene* scene=[GameLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:scene]];
}


@end
