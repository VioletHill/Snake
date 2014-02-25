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
#import "Gravity.h"
#import "StartLayer.h"
#import "EndLayer.h"
#import "UserData.h"
#import <CoreMotion/CoreMotion.h>

@interface GameLayer()

@property (nonatomic,assign) CCMenuItemImage* pauseItem;
@property (nonatomic,assign) CCLayer* pauseLayer;

@property (nonatomic) BOOL isPause;

@end

@implementation GameLayer
{
    int score;
    CCSprite* food;
    Snake* snake;
    Model* model;
    CGSize winSize;
}

static BOOL isEnter=NO;

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
        [self addPause];
        [self addModel];
        [self restart];
    }
    return self;
}

-(void) setIsPause:(BOOL)isPause
{
    _isPause=isPause;
    if (_isPause==NO)
    {
        [self updateSnake];
    }
}

-(void)restart
{
    score=0;
    [food removeFromParent];
    [snake removeFromParent];
    
    snake=[Snake node];
    snake.position=CGPointMake(winSize.width/2, winSize.height/2);
    [self addChild:snake];
    [self addFood];
    
    if ([CCDirector sharedDirector].isPaused)
    {
        [self resumeGame:nil];
    }
}

-(void)addPause
{
    self.pauseItem=[CCMenuItemImage itemWithNormalImage:@"pauseButton.png" selectedImage:@"pauseButton.png" target:self selector:@selector(pauseGame:)];
    self.pauseItem.anchorPoint=CGPointZero;
    self.pauseItem.position=CGPointZero;
    CCMenu* menu= [CCMenu menuWithItems:self.pauseItem, nil];
    menu.position=CGPointZero;
    [self addChild:menu];
}

-(void)addBg
{
    CCSprite* sprite=[CCSprite spriteWithFile:@"gameLayerBg.png"];
    sprite.position=CGPointMake(winSize.width/2, winSize.height/2);
    [self addChild:sprite];
}

-(void)addModel
{
    model=[Model instanceTypeWithGameModel:[Model getGameModel]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
         model.position=CGPointMake(winSize.width-model.contentSize.width-100, 100);
    }
    else
    {
        model.position=CGPointMake(winSize.width-model.contentSize.width-50, 50);
    }
    [self addChild:model];
}

-(void)addFood
{
    food=[[Food sharedFood] createFood];
    int x;
    int y;
    while (1)
    {
        x=arc4random()% (int)(winSize.width-2*minDis()) +minDis();
        y=arc4random()% (int)(winSize.height-2*minDis()) +minDis();
        if (![snake isCollisionOnPosition:CGPointMake(x, y)]) break;
    }
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

-(BOOL) isCollision
{
    CGPoint snakePosition=[snake getHeadPosition];
    if (snakePosition.x<=minDis()/2) return YES;
    if (snakePosition.x>=winSize.width-minDis()/2) return YES;
    if (snakePosition.y<=minDis()/2) return YES;
    if (snakePosition.y>=winSize.height-minDis()/2) return YES;
    return [snake isEatSelf];
}

-(float) getDelayTime
{
    if (score>20) return 1.0/150;
    if (score>15) return 1.0/100;
    if (score>10) return 1.0/80;
    if (score>5) return 1.0/55;
    return 1.0/40;
}

-(void)updateSnake
{
    if (self.isPause) return;
    [self performSelector:@selector(updateSnake) withObject:self afterDelay:[self getDelayTime]];
    if ([self isCollision])
    {
        [self endGame];
        return ;
    }
    if ([self isEatFood])
    {
        [self eatFood];
        score++;
    }
    [snake move:model.getDirctionVector];
}


#pragma mark - pause

-(CCLayer*) pauseLayer
{
    if (_pauseLayer==nil)
    {
        _pauseLayer=[CCLayer node];
        CCSprite* bg=[CCSprite spriteWithFile:@"pauseBackground.png"];
        bg.position=CGPointMake(winSize.width/2, winSize.height/2);
        
        CCSprite* pauseLayout=[CCSprite spriteWithFile:@"pauseLayout.png"];
        pauseLayout.position=CGPointMake(winSize.width/2, winSize.height/2);
        
        
        CCMenuItemImage* returnHome=[CCMenuItemImage itemWithNormalImage:@"pauseBackHome.png" selectedImage:@"pauseBackHomeSelect.png" target:self selector:@selector(returnHome:)];
        returnHome.position=CGPointMake(winSize.width/2-pauseLayout.contentSize.width/2+returnHome.contentSize.width/2,winSize.height/2);
        
        CCMenuItemImage* resumeGame=[CCMenuItemImage itemWithNormalImage:@"pauseContinue.png" selectedImage:@"pauseContinueSelect.png" target:self selector:@selector(resumeGame:)];
        resumeGame.position=CGPointMake(winSize.width/2, winSize.height/2);
        
        CCMenuItemImage* pauseNewGame=[CCMenuItemImage itemWithNormalImage:@"pauseNewGame.png" selectedImage:@"pauseNewGameSelect.png" target:self selector:@selector(resumeNewGame:)];
        pauseNewGame.position=CGPointMake(winSize.width/2+pauseLayout.contentSize.width/2-pauseNewGame.contentSize.width/2, winSize.height/2);
        
        CCMenu* menu=[CCMenu menuWithItems:returnHome, pauseNewGame,resumeGame, nil];
        menu.position=CGPointZero;
        
        [_pauseLayer addChild:bg];
        [_pauseLayer addChild:pauseLayout];
        [_pauseLayer addChild:menu];
    }
    return _pauseLayer;
}

-(void) returnHome:(id)sender
{
    CCScene* scene=[StartLayer node];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:scene]];
}

-(void) resumeNewGame:(id)sender
{
    [self restart];
}

-(void) resumeGame:(id)sender
{
    [self.pauseLayer removeFromParentAndCleanup:YES];
    self.pauseLayer=nil;
    self.isPause=NO;
    [[CCDirector sharedDirector] resume];
}

-(void) pauseGame:(id)sender
{
    self.isPause=YES;
    [[CCDirector sharedDirector] pause];
    [self addChild:self.pauseLayer];
}

-(void) endGame
{
    self.isPause=YES;
    [[UserData sharedUserData] setThisTimeScore:score*100 inModel:[Model getGameModel]];
    [[CCDirector sharedDirector] replaceScene:[EndLayer node]];
}

+(BOOL) isEnter
{
    return isEnter;
}

-(void) onEnter
{
    [super onEnter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EnterBackgroundObserver" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseGame:) name:@"EnterBackgroundObserver" object:nil];
    isEnter=YES;
    [self updateSnake];
}

-(void) onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EnterBackgroundObserver" object:nil];
    [model purgeModel];
    isEnter=NO;
    [super onExit];
}

@end
