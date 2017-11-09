//
//  PreviewReformer.m
//  UltimateShow
//
//  Created by young on 17/3/27.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCPreviewReformer.h"
#import "JCVideoDisplayView.h"

@implementation JCPreviewReformer
{
    JCEngineManager *_confManager;
    
    JCVideoDisplayView *_preview;
    UILabel *_nameLabel;
    
    NSString *_currentUserId;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _confManager = [JCEngineManager sharedManager];
        [_confManager setDelegate:self];
    }
    return self;
}

- (void)onParticipantLeft:(ErrorReason)eventReason userId:(NSString *)userId
{
    if (![userId isEqualToString:_currentUserId]) {
        return;
    }
    
    JCParticipantModel *model = [_confManager getRoomInfo].participants.firstObject;
        [self reloadWithUserId:model.userId];
}

- (void)onParticipantUpdated:(NSString *)userId
{
    if (![userId isEqualToString:_currentUserId]) {
        return;
    }

    JCParticipantModel * model = [_confManager getParticipantWithUserId:userId];
    BOOL canReceiveVideo = model.isVideoUpload;
    if (canReceiveVideo) {
        [_preview hideVideoOffView];
    } else {
        [_preview showVideoOffViewOfSize:VideoOffImageSize50];
    }
}

- (void)bindPreview:(JCVideoDisplayView *)view
{
    if (_preview != view) {
        _preview = view;
    }
}

- (void)bindNameLabel:(UILabel *)label
{
    if (_nameLabel != label) {
        _nameLabel = label;
    }
}

- (void)reloadWithUserId:(NSString *)userId
{
    if (_currentUserId) {
        [self stop];
    }
    
    JCParticipantModel * model = [_confManager getParticipantWithUserId:userId];
    
    if (_nameLabel) {
        _nameLabel.text = model.displayName;
    }
    
    if (_preview) {
        //能收到该成员的视频数据
        BOOL canReceiveVideo = model.isVideoUpload;
        
        if (canReceiveVideo) {
            [_preview hideVideoOffView];
        } else {
            [_preview showVideoOffViewOfSize:VideoOffImageSize50];
        }
        
        //预览窗口视频分辨率请求JCVideoPictureSizeLarge
        [_confManager requestVideoWithUserId:userId pictureSize:VideoPictureSizeLarge];
        
        //_preview.renderView开始选中的成员视频的渲染, 必须在会议结束（会议界面释放前）要调用stopRender释放资源
        [_confManager startRender:_preview.renderView userId:userId mode:RenderFullScreen completed:^{
            
        }];
    }
    
    _currentUserId = userId;
}

- (void)stop
{
    if (_nameLabel) {
        _nameLabel.text = nil;
    }
    
    if (_preview) {
        //取消请求JCVideoPictureSizeLarge
        [_confManager cancelVideoRequestWithUserId:_currentUserId pictureSize:VideoPictureSizeLarge];
        //_preview.renderView停止成员视频的渲染
        [_confManager stopRender:_preview.renderView];
    }
    
    _currentUserId = nil;
}

@end
