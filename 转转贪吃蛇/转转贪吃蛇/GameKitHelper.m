//
//  GameKitHelper.m
//  转转贪吃蛇
//
//  Created by 邱峰 on 14-2-26.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "GameKitHelper.h"
#import "cocos2d.h"

@interface GameKitHelper ()
<GKGameCenterControllerDelegate>
{
    BOOL _gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper

#pragma mark Singleton stuff

+(id) sharedGameKitHelper
{
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer
{
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:mailqiufeng@gmail.com"]];
    
    GKLocalPlayer* localPlayer =[GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler =^(UIViewController *viewController,
      NSError *error) {
        
        [self setLastError:error];
        
        if ([CCDirector sharedDirector].isPaused)
            [[CCDirector sharedDirector] resume];
        
        if (localPlayer.authenticated) {
            _gameCenterFeaturesEnabled = YES;
        }
        else if(viewController)
        {
            [[CCDirector sharedDirector] pause];
            [self presentViewController:viewController];
        }
        else
        {
            _gameCenterFeaturesEnabled = NO;
        }
    };
}

#pragma mark Property setters

-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES completion:nil];
}

-(void) sumitAchievement
{
//    GKAchievement* gkAchievement=[[GKAchievement  alloc] initWithIdentifier:<#(NSString *)#> forPlayer:<#(NSString *)#>]
//    gkAchievement.
}

-(void) submitScore:(int)score
{
    //1: Check if Game Center
    //   features are enabled
    if (!_gameCenterFeaturesEnabled) {
        CCLOG(@"Player not authenticated");
        return;
    }
    
    
    //2: Create a GKScore object
    GKScore* gkScore =[[[GKScore alloc] initWithCategory:@"com.tac.snake.highScores"] autorelease];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:^(NSError* error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
        
        //[self showLeaderboard];
        
         if ([_delegate respondsToSelector:@selector(onScoresSubmitted:)])
         {
             [_delegate onScoresSubmitted:success];
         }
     }];
}

- (void) showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil)
    {
      //  leaderboardController.leaderboardDelegate = [self getRootViewController];
        [self presentModalViewController: leaderboardController animated: YES];
    }
}


@end