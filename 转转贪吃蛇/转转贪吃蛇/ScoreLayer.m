//
//  ScoreLayer.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 14-2-25.
//  Copyright 2014年 邱峰. All rights reserved.
//

#import "ScoreLayer.h"
#import "UserData.h"
#import "CCLabelTTF+ScoreLable.h"
#import "StartLayer.h"

@implementation ScoreLayer
{
    CGSize winSize;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ScoreLayer *layer = [ScoreLayer node];
	
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
        [self addGravityScore];
        [self addRockerScore];
        [self addBack];
    }
    return self;
}

-(void) addGravityScore
{
    int score=[[UserData sharedUserData] getRecordInModel:kGravity];
    CCLabelTTF* scoreLabel=[CCLabelTTF labelWithScore:score];
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        scoreLabel.position=ccp(winSize.width/2+50, winSize.height/2-20);
    }
    else
    {
        if (winSize.width==480.0)
        {
            scoreLabel.position=ccp(winSize.width/2+50, winSize.height/2-10);
        }
        else
        {
            scoreLabel.position=ccp(winSize.width/2+50, winSize.height/2+5);
        }
    }
    [self addChild:scoreLabel];
}

-(void) addRockerScore
{
    int score=[[UserData sharedUserData] getRecordInModel:kRocker];
    CCLabelTTF* scoreLabel=[CCLabelTTF labelWithScore:score];
    NSLog(@"%f",winSize.height);
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        scoreLabel.position=ccp(winSize.width/2+50,winSize.height/2+80);
    }
    else
    {
        if (winSize.width==480.0)
        {
            scoreLabel.position=ccp(winSize.width/2+50,winSize.height/2+30);
        }
        else
        {
            scoreLabel.position=ccp(winSize.width/2+50,winSize.height/2+45);
        }
    }
    
    [self addChild:scoreLabel];
}

-(void) addBg
{
    CCSprite* bg=[CCSprite spriteWithFile:@"highestScore.png"];
    bg.position=ccp(winSize.width/2, winSize.height/2);
    [self addChild:bg];
}

-(void) addBack
{
    CCMenuItemImage* item=[CCMenuItemImage itemWithNormalImage:@"highScoreBack.png" selectedImage:@"highScoreBackSelect.png" target:self selector:@selector(returnToStartLayer)];
    item.anchorPoint=ccp(0.5, 0);
    item.position=ccp(winSize.width/2,50);
    CCMenu* back=[CCMenu menuWithItems:item, nil];
    back.anchorPoint=ccp(0, 0);
    back.position=ccp(0, 0);
    [self addChild:back];
}

-(void) returnToStartLayer
{
    CCScene* scene=[StartLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:scene]];
}

@end
