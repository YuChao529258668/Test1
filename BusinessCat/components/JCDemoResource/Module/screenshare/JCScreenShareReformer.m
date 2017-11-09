//
//  ScreenShareReformer.m
//  UltimateShow
//
//  Created by Nathan Zheng on 2017/3/24.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCScreenShareReformer.h"
#import <JCApi/JCApi.h>

@interface JCScreenShareReformer() <JCEngineDelegate>
{
    JCEngineManager *_confManager;
    
    UIView *_renderView;
    UILabel *_nameLabel;
    
    NSString *_currentUserId;
}
@end

@implementation JCScreenShareReformer

- (instancetype) init {
    
    if (self = [super init]) {
        _confManager = [JCEngineManager sharedManager];
        [_confManager setDelegate:self];
    }
    return self;
}

- (void)onRoomSceenShareStateChanged:(ErrorReason)eventReason
{
    if (eventReason == ScreenShareStart) {
        _currentUserId = [_confManager getRoomInfo].screenSharer.userId;
        if (_delegate) {
            [_delegate screenShareStart];
        }
    } else if (eventReason == ScreenShareStop) {
        if (_delegate) {
            [_delegate screenShareStop];
        }
    }
}

- (void)bindRenderView:(UIView *)view
{
    if (_renderView != view) {
        _renderView = view;
    }
}

- (void)bindNameLabel:(UILabel *)label
{
    if (_nameLabel != label) {
        _nameLabel = label;
    }
}

- (void)reload
{
    if (_nameLabel) {
        _nameLabel.text = [NSString stringWithFormat:@"%@-%@", [_confManager getRoomInfo].screenSharer.displayName, NSLocalizedString(@"screen share", nil)];
    }
    
    //屏幕共享的请求大视频VideoPictureSizeLarge
    [_confManager requestScreenVideoWithPictureSize:VideoPictureSizeLarge];
    //_renderView开始屏幕共享视频的渲染
    [_confManager startScreenRender:_renderView mode:RenderFullContent completed:^{
        
    }];
}

- (void)stop
{
    if (_nameLabel) {
        _nameLabel.text = nil;
    }
    
    [_confManager cancelScreenVideoRequestWithPictureSize:VideoPictureSizeLarge];
    //_renderView停止成员视频的渲染
    [_confManager stopRender:_renderView];
}

@end
