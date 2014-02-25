//
//  UseData.h
//  转转贪吃蛇
//
//  Created by 邱峰 on 13-12-30.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface UserData : NSObject

+(UserData*) sharedUserData;
+(void) purge;

-(void) setNewRecord:(int)record inModel:(GameModel)model;
-(int) getRecordInModel:(GameModel)model;
-(BOOL) isNewRecord:(int)score inModel:(GameModel)model;


-(void) setThisTimeScore:(int)score inModel:(GameModel)model;

-(int) getThisTimeScore;

-(GameModel)getThisTimeModel;

-(BOOL) isNeedBackgroundMusic;
-(BOOL) isNeedEffect;
-(void) setIsNeedBackgroundMusic:(BOOL)is;
-(void) setIsNeedEffect:(BOOL)is;

-(void) setDefaultSetting;

@end
