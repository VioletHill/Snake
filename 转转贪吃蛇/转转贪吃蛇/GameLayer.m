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
#import "SimpleAudioEngine+MusicAndEffect.h"
#import "GameKitHelper.h"
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

static GameLayer* layer=nil;
+(GameLayer*) layer
{
    return layer;
}

+(CCScene *) scene
{
    if ([GameLayer layer]!=nil) return nil;
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
   
	layer = [GameLayer node];
	
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
    [food removeFromParentAndCleanup:YES];
    [snake removeFromParentAndCleanup:YES];
    

    
    snake=[Snake node];
    snake.position=CGPointMake(winSize.width/2, winSize.height/2);
    [self addChild:snake];
    [self addFood];
   
    self.isPause=YES;
    if (self.isPause)
    {
        [self resumeGame:nil];
    }
}

-(void)addPause
{
    self.pauseItem=[CCMenuItemImage itemWithNormalImage:@"pauseButton.png" selectedImage:@"pauseButton.png" target:self selector:@selector(pauseGame:)];
    self.pauseItem.anchorPoint=CGPointZero;
    self.pauseItem.position=CGPointMake(0, 0);
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
        x=arc4random()% (int)(winSize.width-4*minDis()) +minDis()*2;
        y=arc4random()% (int)(winSize.height-4*minDis()) +minDis()*2;
        NSLog(@"%f %f",model.position.x,model.position.y+model.contentSize.height);
        if ([Model getGameModel]==kRocker)
        {
            if (x>model.position.x-minDis()*2 && y<model.position.y+model.contentSize.height/2+2*minDis()) continue;
        }
        if (![snake isCollisionOnPosition:CGPointMake(x, y)]) break;
    }
    [food setPosition:CGPointMake(x, y)];
    [self addChild:food];
}

-(void)eatFood
{
    [[SimpleAudioEngine sharedEngine] playEatEffect];
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
    if (score>35) return 1.0/300;
    if (score>25) return 1.0/200;
    if (score>20) return 1.0/100.0;
    if (score>15) return 1.0/80;
    if (score>10) return 1.0/60;
    if (score>5) return 1.0/50;
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
    
    [snake move:model.getDirctionVector];
    
    if ([self isEatFood])
    {
        [self eatFood];
        score++;
    }
}


#pragma mark - pause

-(CCLayer*) pauseLayer
{
    if (_pauseLayer==nil)
    {
        _pauseLayer=[CCLayer node];
        CCSprite* bg=[CCSprite spriteWithFile:@"pauseBackground.png"];
        bg.position=CGPointMake(winSize.width/2, winSize.height/2);
        
        
        
        CCMenuItemImage* returnHome=[CCMenuItemImage itemWithNormalImage:@"pauseBackHome.png" selectedImage:@"pauseBackHomeSelect.png" target:self selector:@selector(returnHome:)];
       
        
        CCMenuItemImage* resumeGame=[CCMenuItemImage itemWithNormalImage:@"pauseContinue.png" selectedImage:@"pauseContinueSelect.png" target:self selector:@selector(resumeGame:)];
        
        
        CCMenuItemImage* pauseNewGame=[CCMenuItemImage itemWithNormalImage:@"pauseNewGame.png" selectedImage:@"pauseNewGameSelect.png" target:self selector:@selector(resumeNewGame:)];
       
        
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        {
            returnHome.position=CGPointMake(returnHome.contentSize.width,winSize.height/2+200);
            resumeGame.position=CGPointMake(resumeGame.contentSize.width, winSize.height/2);
            pauseNewGame.position=CGPointMake(pauseNewGame.contentSize.width, winSize.height/2-200);
        }
        else
        {
            returnHome.position=CGPointMake(returnHome.contentSize.width,winSize.height/2+100);
            resumeGame.position=CGPointMake(resumeGame.contentSize.width, winSize.height/2);
            pauseNewGame.position=CGPointMake(pauseNewGame.contentSize.width, winSize.height/2-100);
        }
        
        CCMenu* menu=[CCMenu menuWithItems:returnHome, pauseNewGame,resumeGame, nil];
        menu.position=CGPointZero;
        
        [_pauseLayer addChild:bg];

        [_pauseLayer addChild:menu];
    }
    return _pauseLayer;
}

-(void) returnHome:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playBackEffect];
    CCScene* scene=[StartLayer node];
    [[CCDirector sharedDirector] resume];       //why ccdirectior pause will be back i don't know?
    
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] resume];
    
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void) resumeNewGame:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playBackEffect];
    [self restart];
}

-(void) resumeGame:(id)sender
{
     [[SimpleAudioEngine sharedEngine] playBackEffect];
    [self.pauseLayer removeFromParentAndCleanup:YES];
    self.pauseLayer=nil;
    self.isPause=NO;
    [[CCDirector sharedDirector] resume];
    
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] resume];
}

-(void) pauseGame:(id)sender
{
     [[SimpleAudioEngine sharedEngine] playBackEffect];
    if (self.isPause) return;
    
    [[CCDirector sharedDirector] pause];
    self.isPause=YES;
   
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
    NSLog(@"onenter");
    [super onEnter];
    isEnter=YES;
}

-(void) onExit
{
    NSLog(@"onexit");
    layer=nil;
    [model purgeModel];
    isEnter=NO;
    [super onExit];
}

@end
