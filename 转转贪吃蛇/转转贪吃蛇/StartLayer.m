//
//  StartLayer.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-24.
//  Copyright 2013年 邱峰. All rights reserved.
//

#import "StartLayer.h"
#import "InforLayer.h"


@interface StartLayer ()

@property (nonatomic,strong) CCMenuItemImage* startItem;
@property (nonatomic,strong) CCMenuItemImage* inforItem;
@property (nonatomic,strong) CCMenuItemImage* scoreItem;
@property (nonatomic,strong) CCMenu* menu;
@property (nonatomic,strong) CCSprite* title;

@property (nonatomic,strong) CCMenuItemImage* gravityModelItem;
@property (nonatomic,strong) CCMenuItemImage* rockerModelItem;
@property (nonatomic,strong) CCMenuItemImage* returnItem;

@end

@implementation StartLayer
{
    CGSize winSize;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StartLayer *layer = [StartLayer node];
	
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
        [self addMenu];
       // [self performSelector:@selector(moveAllOut) withObject:self afterDelay:4];
    }
    return self;
}

#pragma mark - getter

-(CCSprite*)title
{
    if (_title==nil)
    {
        _title=[CCSprite spriteWithFile:@"title.png"];
        _title.anchorPoint=CGPointMake(0.5, 0);
        _title.position=CGPointMake(winSize.width/2, winSize.height);
        [self addChild:_title];
    }
    return _title;
}

-(CCMenuItemImage*) startItem
{
    if (_startItem==nil)
    {
        _startItem=[CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"start.png" target:self selector:@selector(startMenu:)];
        _startItem.anchorPoint=CGPointMake(0, 1);
        _startItem.position=CGPointMake(- _startItem.contentSize.width, winSize.height/2+_startItem.contentSize.height);
    }
    return _startItem;
}

-(CCMenuItemImage*)inforItem
{
    if (_inforItem==nil)
    {
        _inforItem=[CCMenuItemImage itemWithNormalImage:@"infor.png" selectedImage:@"infor-hd" target:self selector:@selector(inforMenu:)];
        _inforItem.anchorPoint=CGPointMake(0, 1);
        _inforItem.position=CGPointMake(- _inforItem.contentSize.width, winSize.height/2);
    }
    return _inforItem;
}

-(CCMenuItemImage*)scoreItem
{
    if (_scoreItem==nil)
    {
        _scoreItem=[CCMenuItemImage itemWithNormalImage:@"score.png" selectedImage:@"score.png" target:self selector:@selector(scoreMenu:)];
        _scoreItem.anchorPoint=CGPointMake(0, 1);
        _scoreItem.position=CGPointMake(- _scoreItem.contentSize.width, winSize.height/2-_scoreItem.contentSize.height);
    }
    return _scoreItem;
}

-(CCMenuItemImage*)gravityModelItem
{
    if (_gravityModelItem==nil)
    {
        _gravityModelItem=[CCMenuItemImage itemWithNormalImage:@"gravityModel.png" selectedImage:@"gravityModel.png" target:self selector:@selector(gravityMenu:)];
        _gravityModelItem.anchorPoint=CGPointMake(0, 0.5);
        _gravityModelItem.position=CGPointMake(winSize.width/2, winSize.height+_gravityModelItem.contentSize.height);
    }
    return _gravityModelItem;
}

-(CCMenuItemImage*)rockerModelItem
{
    if (_rockerModelItem==nil)
    {
        _rockerModelItem=[CCMenuItemImage itemWithNormalImage:@"rockerModel.png" selectedImage:@"rockerModel.png" target:self selector:@selector(rockerMenu:)];
        _rockerModelItem.anchorPoint=CGPointMake(1, 0.5);
        _rockerModelItem.position=CGPointMake(winSize.width/2, winSize.height+_rockerModelItem.contentSize.height);
    }
    return _rockerModelItem;
}

-(CCMenuItemImage*)returnItem
{
    if (_returnItem==nil)
    {
        _returnItem=[CCMenuItemImage itemWithNormalImage:@"return.png" selectedImage:@"return.png" target:self selector:@selector(returnMenu:)];
        _returnItem.anchorPoint=CGPointMake(0.5, 0);
        _returnItem.position=CGPointMake(winSize.width/2, - _returnItem.contentSize.height);
    }
    return _returnItem;
}

-(CCMenu*) menu
{
    if (_menu==nil)
    {
        _menu=[CCMenu menuWithItems:self.startItem, self.inforItem,self.scoreItem, self.gravityModelItem, self.rockerModelItem,self.returnItem, nil];
        _menu.position=CGPointZero;
        [self addChild:_menu];

    }
    return _menu;
}




#pragma mark - move action

-(ccTime) moveDuration
{
    return 0.5;
}

-(ccTime) moveDelay:(CCNode*)pSender
{
    if (pSender==self.startItem) return 0;
    else if (pSender==self.inforItem) return 0.1;
    else if (pSender==self.scoreItem) return 0.2;
    else if (pSender==self.gravityModelItem) return 0.2+[self moveDuration];
    else if (pSender==self.rockerModelItem) return 0.2+[self moveDuration];
    else if (pSender==self.returnItem) return 0.2+[self moveDuration];
    
    return 0;
}

-(void) moveNode:(CCNode*)node intoPoint:(CGPoint)point withDuration:(ccTime)duration andDelay:(ccTime)delay
{
    CCActionInterval* move=[CCMoveTo actionWithDuration:duration position:point];
    CCActionInterval* backAction=[CCEaseBackOut actionWithAction:move];
    CCActionInterval* action=[CCSequence actionOne:[CCDelayTime actionWithDuration:delay] two:backAction];
    [node runAction:action];
}

-(void) moveNode:(CCNode*)node outPoint:(CGPoint)point withDuration:(ccTime)duration andDelay:(ccTime)delay
{
    CCActionInterval* move=[CCMoveTo actionWithDuration:duration position:point];
    CCActionInterval* backAction=[CCEaseBackIn actionWithAction:move];
    CCActionInterval* action=[CCSequence actionOne:[CCDelayTime actionWithDuration:delay] two:backAction];
    [node runAction:action];

}


#pragma mark - move startItem

-(void) moveInStartItem
{
    
    CGPoint point=CGPointMake(0, self.startItem.position.y);
    [self moveNode:self.startItem intoPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.startItem]];
}

-(void)moveOutStartItem
{
    CGPoint point= CGPointMake(-self.startItem.contentSize.width, self.startItem.position.y);
    [self moveNode:self.startItem outPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.startItem]];
}

#pragma mark - move inforItem

-(void) moveIninforItem
{
    CGPoint point=CGPointMake(0, self.inforItem.position.y);
    [self moveNode:self.inforItem intoPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.inforItem]];
}

-(void) moveOutinforItem
{
    CGPoint point=CGPointMake(-self.inforItem.contentSize.width, self.inforItem.position.y);
    [self moveNode:self.inforItem outPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.inforItem]];
}

#pragma mark - move scoreItem

-(void) moveInScoreItem
{
    CGPoint point=CGPointMake(0, self.scoreItem.position.y);
    [self moveNode:self.scoreItem intoPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.scoreItem]];
}

-(void) moveOutScoreItem
{
    CGPoint point=CGPointMake(-self.scoreItem.contentSize.width, self.scoreItem.position.y);
    [self moveNode:self.scoreItem outPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.scoreItem]];
}

#pragma mark - move title

-(void) moveInTitle
{
    CGPoint point=CGPointMake(self.title.position.x, winSize.height/2);
    [self moveNode:self.title intoPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.title]];
}

-(void) moveOutTitle
{
    CGPoint point=CGPointMake(self.title.position.x, winSize.height);
    [self moveNode:self.title outPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.title]];
}

#pragma mark - move Select

-(void) moveInGravityItem
{
    CGPoint point=CGPointMake(self.gravityModelItem.position.x, winSize.height/2);
    [self moveNode:self.gravityModelItem intoPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.gravityModelItem]];
}

-(void) moveOutGravityItem
{
    CGPoint point=CGPointMake(self.gravityModelItem.position.x, winSize.height+_gravityModelItem.contentSize.height);
    [self moveNode:self.gravityModelItem outPoint:point withDuration:[self moveDuration] andDelay:0];
}

#pragma mark - move rocker

-(void) moveInRockerItem
{
    CGPoint point=CGPointMake(self.rockerModelItem.position.x, winSize.height/2);
    [self moveNode:self.rockerModelItem intoPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.rockerModelItem]];
}

-(void) moveOutRockerItem
{
    CGPoint point=CGPointMake(self.rockerModelItem.position.x, winSize.height+_rockerModelItem.contentSize.height);
    [self moveNode:self.rockerModelItem outPoint:point withDuration:[self moveDuration] andDelay:0];
}

#pragma mark - move return

-(void) moveInReturnItem
{
    CGPoint point=CGPointMake(self.returnItem.position.x, 0);
    [self moveNode:self.returnItem intoPoint:point withDuration:[self moveDuration] andDelay:[self moveDelay:self.returnItem]];
}

-(void) moveOutReturnItem
{
    CGPoint point=CGPointMake(self.returnItem.position.x, -self.returnItem.contentSize.height);
    [self moveNode:self.returnItem outPoint:point withDuration:[self moveDuration] andDelay:0];
}

#pragma mark - move all

-(void) moveStartMenuIn
{
    [self moveInStartItem];
    [self moveIninforItem];
    [self moveInScoreItem];
    [self moveInTitle];
}

-(void) moveStartMenuOut
{
    [self moveOutStartItem];
    [self moveOutinforItem];
    [self moveOutScoreItem];
    [self moveOutTitle];
}

-(void)moveChoseIn
{
    [self moveInGravityItem];
    [self moveInRockerItem];
    [self moveInReturnItem];
}

-(void)moveChoseOut
{
    [self moveOutGravityItem];
    [self moveOutRockerItem];
    [self moveOutReturnItem];
}

#pragma mark - add menu child

-(void) addBg
{
    CCSprite* bg = nil ;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        bg = [CCSprite spriteWithFile:@"beginBackground.jpg"];
    }
    else
    {
        bg = [CCSprite spriteWithFile:@"beginBackground~iPad.jpg"];
    }
    bg.position=CGPointMake(winSize.width/2, winSize.height/2);
    [self addChild:bg];
    
}


-(void) addMenu
{
    [self menu];
    [self performSelector:@selector(moveStartMenuIn) withObject:self afterDelay:2];
}


#pragma mark - Item select


-(void)startMenu:(CCNode*)pSender
{
    [self moveStartMenuOut];
    [self moveChoseIn];
}

-(void)inforMenu:(CCNode*)pSender
{
    CCScene* inforScene=[InforLayer scene];
    [[CCDirector sharedDirector] pushScene:inforScene];
}

-(void)scoreMenu:(CCNode*)pSender
{
    
}

-(void)gravityMenu:(CCNode*)pSender
{
    
}

-(void)rockerMenu:(CCNode*)pSender
{
    
}

-(void)returnMenu:(CCNode*)pSender
{
    [self moveChoseOut];
    [self performSelector:@selector(moveStartMenuIn) withObject:self afterDelay:[self moveDuration]];
}

@end
