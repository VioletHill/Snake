//
//  inforLayer.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-24.
//  Copyright 2013年 邱峰. All rights reserved.
//

#import "InforLayer.h"
#import "StartLayer.h"
#import "SimpleAudioEngine+MusicAndEffect.h"

@interface InforLayer()

@property (nonatomic, strong) NSMutableArray* inforSprite;
@property (nonatomic, assign) CCMenuItemImage* backItem;
@property (nonatomic, assign) CCMenuItemImage* nextInfor;
@property (nonatomic, assign) CCMenuItemImage* lastInfor;
@property (nonatomic, assign) CCMenu* menu;

@end

@implementation InforLayer
{
    CGSize winSize;
    int currentIndex;
    BOOL isInforMoving;
}



+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	InforLayer *layer = [InforLayer node];
	
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
        [self addInfor];
        [self menu];
    }
    return self;
}

-(NSMutableArray*) inforSprite
{
    if (_inforSprite==nil)
    {
        _inforSprite=[[NSMutableArray alloc] init];
    }
    return _inforSprite;
}

-(CGFloat) itemHeightPosition
{
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        return 70;
    }
    else
    {
        return 20;
    }
}

-(CGFloat) itemWithPosition
{
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        return 80;
    }
    else
    {
        return 40;
    }
}

-(CCMenuItemImage*) backItem
{
    if (_backItem==nil)
    {
        _backItem=[CCMenuItemImage itemWithNormalImage:@"backStart.png" selectedImage:@"backStartSelect.png" target:self selector:@selector(backMenu:)];
        _backItem.anchorPoint=CGPointZero;
        _backItem.position=CGPointMake(self.lastInfor.contentSize.width+self.lastInfor.position.x+[self itemWithPosition], self.lastInfor.position.y);
    }
    return _backItem;
}

-(CCMenuItemImage*) lastInfor
{
    if (_lastInfor==nil)
    {
        _lastInfor=[CCMenuItemImage itemWithNormalImage:@"lastInfor.png" selectedImage:@"lastInforSelect.png" target:self selector:@selector(lastInforMenu:)];
        _lastInfor.anchorPoint=CGPointZero;
        _lastInfor.position=CGPointZero;
        _lastInfor.position=CGPointMake(80,[self itemHeightPosition]);
    }
    return _lastInfor;
}


-(CCMenuItemImage*) nextInfor
{
    if (_nextInfor==nil)
    {
        _nextInfor=[CCMenuItemImage itemWithNormalImage:@"nextInfor.png" selectedImage:@"nextInforSelect.png" target:self selector:@selector(nextInforMenu:)];
        _nextInfor.anchorPoint=CGPointZero;
        _nextInfor.position=CGPointMake(self.backItem.position.x+self.backItem.contentSize.width+[self itemWithPosition], self.backItem.position.y);
    }
    return _nextInfor;
}

-(CCMenu*) menu
{
    if (_menu==nil)
    {
        _menu=[CCMenu menuWithItems:self.backItem,self.lastInfor,self.nextInfor,nil];
        _menu.position=CGPointZero;
        [self addChild:_menu];
    }
    return _menu;
}

-(int) totInfor
{
    return 6;
}


-(void) addInfor
{
    for (int i=[self totInfor]; i>=1; i--)
    {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"infor%d.png",i]];
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(0, 0);
        [self addChild:sprite];
        [self.inforSprite insertObject:sprite atIndex:0];
    }

}

-(void) inforMoveDone:(CCNode*)pSender data:(void*)data
{
    currentIndex=data;
    
    if (currentIndex<=0) self.lastInfor.visible=NO;
    else self.lastInfor.visible=YES;
    
    if (currentIndex>=[self totInfor]-1) self.nextInfor.visible=NO;
    else self.nextInfor.visible=YES;
    
    isInforMoving=NO;
}

-(void) backMenu:(CCNode*)pSender
{
     [[SimpleAudioEngine sharedEngine] playBackEffect];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[StartLayer node]]];
}


-(void) lastInforMenu:(CCNode*)pSender
{
     [[SimpleAudioEngine sharedEngine] playBackEffect];
    if (currentIndex==0 || isInforMoving) return;
    isInforMoving=YES;
    CCSprite* sprite=[self.inforSprite objectAtIndex:currentIndex-1];
    CCActionInterval* move=[CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, sprite.position.y)];
    [sprite runAction:[CCSequence actionOne:move two:[CCCallFuncND actionWithTarget:self selector:@selector(inforMoveDone:data:) data:currentIndex-1]]];
}

-(void) nextInforMenu:(CCNode*)pSender
{
     [[SimpleAudioEngine sharedEngine] playBackEffect];
    if (currentIndex==[self totInfor]-1 || isInforMoving) return;
    isInforMoving=YES;
    CCSprite* sprite=[self.inforSprite objectAtIndex:currentIndex];
    CCActionInterval* move=[CCMoveTo actionWithDuration:0.5 position:CGPointMake(winSize.width, sprite.position.y)];
    [sprite runAction:[CCSequence actionOne:move two:[CCCallFuncND actionWithTarget:self selector:@selector(inforMoveDone:data:) data:currentIndex+1]]];
}

-(void) onEnter
{
    [super onEnter];
    currentIndex=0;
    isInforMoving=NO;
    self.lastInfor.visible=NO;
}

-(void)onExit
{
    [self.inforSprite release];
    [super onExit];
}

@end
