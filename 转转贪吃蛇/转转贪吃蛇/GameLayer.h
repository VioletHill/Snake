//
//  GameLayer.h
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-26.
//  Copyright 2013年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Food.h"
#import <math.h>


struct Vector
{
    float x;
    float y;

};

typedef struct Vector Vector;

NS_INLINE Vector VHMakeVector(float x, float y)
{
    Vector r;
    r.x=x;
    r.y=y;
    return r;
}

NS_INLINE BOOL isZeroVector(Vector vector)
{
    if (vector.x==0 && vector.y==0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



NS_INLINE float getVectorLength(Vector x)
{
    return sqrt( pow(x.x, 2)+pow(x.y, 2) );
}

NS_INLINE Vector VHMakeOneDistanceVectorByPoint(float x, float y)
{
    if (x==0 && y==0) return VHMakeVector(0, 0);
    float dis=sqrt( pow(x, 2)+pow(y, 2) );
    return VHMakeVector(x/dis, y/dis);
}

NS_INLINE Vector VHMakeOneDistanceVectorByVector(Vector vecotor)
{
    return VHMakeOneDistanceVectorByPoint(vecotor.x, vecotor.y);
}

NS_INLINE float vectorDotProduct(Vector a, Vector b)
{
    return a.x*b.x+a.y*b.y;
}

NS_INLINE float vectorCrossPorduct(Vector a,Vector b)
{
    return  a.x*b.y-a.y*b.x;
}

NS_INLINE float VHVectorGetAngle(Vector a, Vector b)
{
    if (isZeroVector(a) && isZeroVector(b)) return 0;
    return CC_RADIANS_TO_DEGREES(acos( vectorDotProduct(a, b)/ (getVectorLength(a)*getVectorLength(b) ) ));
}

NS_INLINE Vector VHVectorMultiply(Vector a, float x)
{
    return VHMakeVector(a.x*x, a.y*x);
}

NS_INLINE BOOL isSameVector(Vector a, Vector b)
{
    if (a.x==b.x && a.y==b.y) return YES;
    else return NO;
}



NS_INLINE float minDis()
{
    return [[Food sharedFood] foodSize].width/2;
}

NS_INLINE float getDistance(CGPoint a,CGPoint b)
{
    return sqrt( pow(a.x-b.x, 2)+pow(a.y-b.y, 2) );
}

NS_INLINE BOOL isCollision(CGPoint a, CGPoint b)
{
    float dis=getDistance(a, b);
    if (dis<=minDis()) return YES;
    else return NO;
}


@interface GameLayer : CCLayer {
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

+(BOOL) isEnter;

@end
