//
//  SingleParticipantReformer.h
//  UltimateShow
//
//  Created by 沈世达 on 17/4/19.
//  Copyright © 2017年 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JCApi/JCApi.h>

@interface JCSingleParticipantReformer : NSObject<JCEngineDelegate>

- (void)bindRenderView:(UIView *)view;

- (void)reloadWithUserId:(NSString *)userId;

- (void)stop;

@end
