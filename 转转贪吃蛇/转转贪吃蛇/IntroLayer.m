//
//  IntroLayer.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-24.
//  Copyright 邱峰 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "StartLayer.h"
#import "SimpleAudioEngine.h"
#import "GameKitHelper.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



// 
-(id) init
{
	if( (self=[super init])) {

//		// ask director for the window size
//		CGSize size = [[CCDirector sharedDirector] winSize];
//
//		CCSprite *background=[CCSprite spriteWithFile:@"beginBackground.png"];
//		background.position = ccp(size.width/2, size.height/2);
//
//		// add the label as a child to this Layer
//		[self addChild: background];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
  
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
   // [[CCDirector sharedDirector] replaceScene:[StartLayer scene]];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.1 scene:[StartLayer scene] ]];
}
@end
