//
//  BaseMeetingReformer.m
//  UltimateShow
//
//  Created by young on 17/3/24.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCBaseMeetingReformer.h"

@interface JCBaseMeetingReformer ()
{
    JCEngineManager *_confManager;
}

@property (nonatomic, copy) void (^audioEnabledBlock)(BOOL isAudioEnabled);
@property (nonatomic, copy) void (^videoEnabledBlock)(BOOL isVideoEnabled);

@end

@implementation JCBaseMeetingReformer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _confManager = [JCEngineManager sharedManager];
        [_confManager setDelegate:self];
        _mode = JoinModeVideo;
        
        _audioEnabled = NO;
        _videoEnabled = YES;
    }
    return self;
}

#pragma mark - JCEngineDelegate
- (void)onJoinRoomSuccess
{
    if (_delegate && [_delegate respondsToSelector:@selector(joinSuccess)]) {
        [_delegate joinSuccess];
    }
}

- (void)onError:(ErrorReason)eventReason
{
    if (self.mode == JoinModeVideo) {
        [_confManager stopCamera];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(joinFailedWithReason:)]) {
        [_delegate joinFailedWithReason:eventReason];
    }
}

- (void)onLeftRoom:(ErrorReason)eventReason
{
    if (_delegate && [_delegate respondsToSelector:@selector(leaveWithReason:)]) {
        [_delegate leaveWithReason:eventReason];
    }
}

- (void)onParticipantUpdated:(NSString *)userId
{
    NSString *ownUserId = [_confManager getOwnUserId];
    if (!ownUserId) {
        ownUserId = [ObjectShareTool currentUserID];
    }
    if ([userId isEqualToString:ownUserId]) {
        JCParticipantModel *model = [[JCEngineManager sharedManager] getParticipantWithUserId:userId];
        
        if (model.isAudioUpload != self.isAudioEnabled) { //音频发送状态改变
            _audioEnabled = model.isAudioUpload;
            if (self.audioEnabledBlock) {
                self.audioEnabledBlock(self.isAudioEnabled);
            }
        } else if (model.isVideoUpload != self.isVideoEnabled) { //视频发送状态改变
            _videoEnabled = model.isVideoUpload;
            if (self.videoEnabledBlock) {
                self.videoEnabledBlock(self.isVideoEnabled);
            }
        }
    } else {
        
    }
}

- (BOOL)joinWithRommId:(NSString *)roomId displayName:(NSString *)name
{
    [_confManager setJoinMode:self.mode];
    int ret = [_confManager joinWithRoomId:roomId displayName:name];
    if (ret == JCOK && self.mode == JoinModeVideo) {
        [_confManager startCamera];
    }
    return ret == JCOK;
}

- (void)leave
{
    if (self.mode == JoinModeVideo) {
        [_confManager stopCamera];
    }
    
    [_confManager leave];
}

- (int)setAudioEnabled:(BOOL)enabled completion:(void (^)(BOOL isAudioEnabled))completion
{
    int success = [_confManager enableLocalAudioStream:enabled];
    self.audioEnabledBlock = completion;
    return success;
}

- (void)setVideoEnabled:(BOOL)enabled completion:(void (^)(BOOL isVideoEnabled))completion
{
    [_confManager enableLocalVideoStream:enabled];
    self.videoEnabledBlock = completion;
}

- (void)setMuteEnabled:(BOOL)enabled
{
    [_confManager enableAudioOutput:enabled];
}

- (void)switchCamera
{
    [_confManager switchCamera];
}
@end
