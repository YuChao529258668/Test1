//
//  BaseMeetingReformer.h
//  UltimateShow
//
//  Created by young on 17/3/24.
//  Copyright © 2017年 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JCApi/JCApi.h>

@protocol BaseMeetingDelegate <NSObject>

- (void)joinSuccess;

- (void)joinFailedWithReason:(ErrorReason)reason;

- (void)leaveWithReason:(ErrorReason)reason;

@end


@interface JCBaseMeetingReformer : NSObject <JCEngineDelegate>

@property (nonatomic, weak) id<BaseMeetingDelegate> delegate;

@property (nonatomic) JoinMode mode;
//默认音频发送状态为关闭
@property (nonatomic, readonly, getter=isAudioEnabled) BOOL audioEnabled;

//视频模式下，默认视频发送状态为打开
@property (nonatomic, readonly, getter=isVideoEnabled) BOOL videoEnabled;

- (BOOL)joinWithRommId:(NSString *)roomId displayName:(NSString *)name;

- (int)leave;

- (int)setAudioEnabled:(BOOL)enabled completion:(void (^)(BOOL isAudioEnabled))completion;

- (void)setVideoEnabled:(BOOL)enabled completion:(void (^)(BOOL isVideoEnabled))completion;

- (void)setMuteEnabled:(BOOL)enabled;

- (void)switchCamera;

@end
