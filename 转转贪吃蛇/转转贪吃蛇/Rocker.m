//
//  Rocker.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright 2013年 邱峰. All rights reserved.
//

#import "Rocker.h"

@interface Rocker()

@property (nonatomic,assign) CCSprite* touchSprite;

@end

@implementation Rocker

-(instancetype) init
{
    if (self=[super init])
    {
        [self addBg];
        [self registeTouch];
    }
    return self;
}


-(CCSprite*)touchSprite
{
    if (_touchSprite==nil)
    {
        _touchSprite=[CCSprite spriteWithFile:@"rockerPoint.png"];
        _touchSprite.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_touchSprite];
    }
    return _touchSprite;
}


-(void) addBg
{
    CCSprite* bg=[CCSprite spriteWithFile:@"rockerBg.png"];
    self.contentSize=bg.contentSize;
    bg.position=CGPointMake(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:bg];
    
    [self touchSprite];
}

-(Vector) getDirctionVector
{
    return VHMakeVector(self.touchSprite.position.x-self.contentSize.width/2, self.touchSprite.position.y-self.contentSize.height/2);
}

#pragma mark - touch

-(void)registeTouch
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)removeTouch
{
    [self removeAllChildrenWithCleanup:YES];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

-(BOOL)isTouchPointAtLayer:(CGPoint)point
{
    if (point.x<0 || point.y<0 || point.x>self.contentSize.width || point.y>self.contentSize.height) return NO;
    else return YES;
}

-(void) moveToNextPoint:(CGPoint)point
{
    CGPoint newPoint=point;
    newPoint.x=min(self.contentSize.width,newPoint.x);
    newPoint.x=max(0, newPoint.x);
    newPoint.y=min(self.contentSize.height, newPoint.y);
    newPoint.y=max(0, newPoint.y);
    self.touchSprite.position=newPoint;
}

-(void) resetLastPoint
{
    CGPoint centerPoint=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    self.touchSprite.position=centerPoint;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    BOOL isTouchInLayer=[self isTouchPointAtLayer:touchLocation];
    if (isTouchInLayer)
    {
        [self resetLastPoint];
        [self moveToNextPoint:touchLocation];
    }
   // return isTouchInLayer;
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self moveToNextPoint:touchLocation];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self moveToNextPoint:touchLocation];
    [self resetLastPoint];
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self ccTouchEnded:touch withEvent:event];
}




@end
