//
//  inforLayer.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-24.
//  Copyright 2013年 邱峰. All rights reserved.
//

#import "InforLayer.h"


@interface InforLayer()

@property (nonatomic, strong) NSMutableArray* inforSprite;
@property (nonatomic, strong) CCMenuItemImage* backItem;
@property (nonatomic, strong) CCMenuItemImage* nextInfor;
@property (nonatomic, strong) CCMenuItemImage* lastInfor;
@property (nonatomic, strong) CCMenu* menu;

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

-(CCMenuItemImage*) backItem
{
    if (_backItem==nil)
    {
        _backItem=[CCMenuItemImage itemWithNormalImage:@"backStart.png" selectedImage:@"backStart.png" target:self selector:@selector(backMenu:)];
        _backItem.anchorPoint=CGPointZero;
        _backItem.position=CGPointZero;
    }
    return _backItem;
}

-(CCMenuItemImage*) lastInfor
{
    if (_lastInfor==nil)
    {
        _lastInfor=[CCMenuItemImage itemWithNormalImage:@"lastInfor.png" selectedImage:@"lastInfor.png" target:self selector:@selector(lastInforMenu:)];
        _lastInfor.anchorPoint=CGPointZero;
        _lastInfor.position=CGPointMake(self.backItem.position.x+self.backItem.contentSize.width, self.backItem.contentSize.height);
    }
    return _lastInfor;
}


-(CCMenuItemImage*) nextInfor
{
    if (_nextInfor==nil)
    {
        _nextInfor=[CCMenuItemImage itemWithNormalImage:@"nextInfor.png" selectedImage:@"nextInfor.png" target:self selector:@selector(nextInforMenu:)];
        _nextInfor.anchorPoint=CGPointZero;
        _nextInfor.position=CGPointMake(self.lastInfor.position.x+self.lastInfor.contentSize.width, self.lastInfor.contentSize.height);
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
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"infor%d.jpg",i]];
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
    [[CCDirector sharedDirector] popScene];
}


-(void) lastInforMenu:(CCNode*)pSender
{
    if (currentIndex==0 || isInforMoving) return;
    isInforMoving=YES;
    CCSprite* sprite=[self.inforSprite objectAtIndex:currentIndex-1];
    CCActionInterval* move=[CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, sprite.position.y)];
    [sprite runAction:[CCSequence actionOne:move two:[CCCallFuncND actionWithTarget:self selector:@selector(inforMoveDone:data:) data:currentIndex-1]]];
}

-(void) nextInforMenu:(CCNode*)pSender
{
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

@end
