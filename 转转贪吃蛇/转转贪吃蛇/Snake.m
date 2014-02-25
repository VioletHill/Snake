//
//  Snake.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import "Snake.h"
#import <math.h>

@interface Direction : NSObject

@property (nonatomic) Vector v;
@property (nonatomic) float speed;

@end

@implementation Direction

+(Direction*) makeDirection:(Vector)v
{
    Direction* dir=[[[Direction alloc] init] autorelease];
    dir.v=v;
    return dir;
}

@end

@interface Snake()

@property (nonatomic,retain) NSMutableArray* body;

@property (nonatomic,retain) NSMutableArray* moveVector;    //moveVector 里面的内容是一个数组
                                                            //数组的每个元素 保存了一个Direction  其中记录蛇的index 的下一个移动方向
                                                            // OBJECT at index 0 保存着距离上一个身体的距离 其他后面的元素保存着方向

@end

@implementation Snake
{
    Vector lastDirection;
    
    float speed;        //1 start 2 max
                        //最大值与最小值差值不予大于0.5
                        //speed 变化太大会导致蛇蛇分离  解决办法是增加刷新频率 不改变speed大小 但是这样好吗？
    
                        //* speed 属性已经被废除 全部=1  修改刷新频率增加速度
}

@synthesize body=_body;
@synthesize moveVector=_moveVector;

const float maxAngel=3;


-(instancetype) init
{
    if (self=[super init])
    {
        speed=3;
        CCSprite* head=[CCSprite spriteWithFile:@"snakeHead.png"];
        head.zOrder=1;
        head.position=CGPointMake(0, 0);
        [self.body addObject:head];
        [self addChild:head];
        [self addBody];
    }
    return self;
}

-(NSMutableArray*) body
{
    if (_body==nil)
    {
        _body=[[NSMutableArray alloc] init];
    }
    return _body;
}

-(NSMutableArray*) moveVector
{
    if (_moveVector==nil)
    {
        _moveVector=[[NSMutableArray alloc] init];
    }
    return _moveVector;
}

-(void)addBody
{
    CCSprite* body=[CCSprite spriteWithFile:@"body.png"];
    CCSprite* lastBody=[self.body lastObject];
    [body setPosition:lastBody.position];
    [self.body addObject:body];
    [self addChild:body];
    
    NSMutableArray* dir=[[[NSMutableArray alloc] init] autorelease];
    [dir addObject:@(0)];
    [self.moveVector addObject:dir];
}

-(Vector) getMaxVector:(Vector)v withClockwise:(BOOL)clockwise andSpeed:(float)value
{
    v=VHMakeOneDistanceVectorByVector(v);
    float sinTheta=sin( CC_DEGREES_TO_RADIANS(maxAngel) );
    float cosTheta=cos( CC_DEGREES_TO_RADIANS(maxAngel) );
    if (clockwise) sinTheta=-sinTheta;
    Vector result=VHMakeVector( v.x*cosTheta-v.y*sinTheta, v.x*sinTheta+v.y*cosTheta );
    return VHVectorMultiply(result, value);
}

-(BOOL) isSameDirectionA:(Vector)a andB:(Vector)b
{
    Vector ax=VHMakeOneDistanceVectorByVector(a);
    Vector bx=VHMakeOneDistanceVectorByVector(b);
    return isSameVector(ax, bx);
}

-(void) addDirection:(Direction*)dir atIndex:(NSUInteger)index
{
    if (self.moveVector.count<=index) return ;
    NSMutableArray* moveDirection=[self.moveVector objectAtIndex:index];
    NSNumber* dis=[moveDirection firstObject];
   // NSLog(@"%f",getVectorLength(dir.v));
    if ([dis floatValue]<50.0)
    {
        dis=@([dis floatValue]+getVectorLength(dir.v));
        [moveDirection replaceObjectAtIndex:0 withObject:dis];
    }
    [moveDirection addObject:dir];
}

-(void)removeDirectionAtIndex:(NSUInteger)index
{
    if (self.moveVector.count<=index) return;
    NSMutableArray* moveDirection=[self.moveVector objectAtIndex:index];
    [moveDirection removeObjectAtIndex:1];
}

-(void) moveHead:(Vector)nextDirection
{
    if (isZeroVector(nextDirection))
    {
        nextDirection=VHMakeOneDistanceVectorByVector(lastDirection);
        nextDirection=VHVectorMultiply(nextDirection, speed);
    }
    
    CCSprite* head=[self.body firstObject];
    
    if (![self isSameDirectionA:lastDirection andB:nextDirection])
    {
        @try {
            float crossProduct=vectorCrossPorduct(lastDirection, nextDirection);
            float angle=VHVectorGetAngle(lastDirection, nextDirection);
            if (isnan(angle))       //here is a bug  why angle=nan? I don't know
            {
                angle=0.0;
            }
            if (angle!=0.0)
            {
                if (angle>maxAngel)
                {
                    BOOL clockwise=YES;
                    if (crossProduct>0) clockwise=NO;
                    nextDirection=[self getMaxVector:lastDirection withClockwise:clockwise andSpeed:speed];
                    angle=maxAngel;
                }
                
                if (crossProduct>0) angle=-angle;
               // NSLog(@"%f %f",head.rotation,angle);
                float newAngle=head.rotation+angle;
                if (newAngle>360) newAngle=newAngle-360;
                if (newAngle<-360) newAngle=newAngle+360;
               // NSLog(@"%f",newAngle);
                [head setRotation: newAngle];
            }

        }
        @catch (NSException *exception) {
            nextDirection=lastDirection;
        }
        @finally {
            
        }
    }
    head.position=CGPointMake(head.position.x + nextDirection.x, head.position.y + nextDirection.y);
    lastDirection=nextDirection;
    
    [self addDirection:[Direction makeDirection:nextDirection] atIndex:0];
}

-(void)moveBody
{
    for (int i=1; i<self.body.count; i++)
    {
        NSMutableArray* moveArray=[self.moveVector objectAtIndex:i-1];
        CCSprite* nowMoveBody=[self.body objectAtIndex:i];
        float dis=[(NSNumber*)[moveArray firstObject] floatValue];
        if (dis>=nowMoveBody.contentSize.width)
        {
            Vector next=((Direction*)[moveArray objectAtIndex:1]).v;
            nowMoveBody.position=CGPointMake(nowMoveBody.position.x+next.x, nowMoveBody.position.y+next.y);
            [self removeDirectionAtIndex:i-1];
            [self addDirection:[Direction makeDirection:next] atIndex:i];
        }
    }
}

-(void) move:(Vector)nextDirection
{
    Vector vector;
    if (isZeroVector(nextDirection) && isZeroVector(lastDirection)) return; //没开始
    
    if (isZeroVector(lastDirection)) lastDirection=VHMakeVector(0, -1);
    
    if (isZeroVector(nextDirection))
    {
        vector=VHMakeOneDistanceVectorByVector(lastDirection);
    }
    else
    {
        vector=VHMakeOneDistanceVectorByVector(nextDirection);
    }
    
    vector=VHVectorMultiply(vector, speed);
    [self moveHead:vector];
    [self moveBody];
}

-(CGPoint)getHeadPosition
{
    CCSprite* head=[self.body firstObject];
    return CGPointMake(head.position.x+self.position.x, head.position.y+self.position.y);
}

-(BOOL) isEatSelf
{
    CCSprite* head=[self.body firstObject];
    for (int i=3; i<self.body.count; i++)
    {
        CCSprite* body=[self.body objectAtIndex:i];
        if (isCollision(head.position, body.position)) return YES;
    }
    return NO;
}

-(BOOL) isCollisionOnPosition:(CGPoint)p
{
    for (int i=0; i<self.body.count; i++)
    {
        CCSprite* body=[self.body objectAtIndex:i];
        if (isCollision(CGPointMake(body.position.x+self.position.x, body.position.y+self.position.y), p)) return YES;
    }
    return NO;
}

-(void)onExit
{
    [self.body release];
    [self.moveVector release];
    [super onExit];
}

@end
