//
//  GameKitHelper.h
//  转转贪吃蛇
//
//  Created by 邱峰 on 14-2-26.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <GameKit/GameKit.h>

//   Protocol to notify external
//   objects when Game Center events occur or
//   when Game Center async tasks are completed
@protocol GameKitHelperProtocol<NSObject>

-(void) onScoresSubmitted:(BOOL)successful;

@end


@interface GameKitHelper : NSObject

@property (nonatomic, assign)
id<GameKitHelperProtocol> delegate;

// This property holds the last known error
// that occured while using the Game Center API's
@property (nonatomic, readonly) NSError* lastError;

+ (id) sharedGameKitHelper;

// Player authentication, info
-(void) authenticateLocalPlayer;

// Scores
-(void) submitScore:(int)score;

@end
