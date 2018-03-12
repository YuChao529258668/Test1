//
//  SplitScreenReformer.m
//  UltimateShow
//
//  Created by young on 17/3/20.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCSplitScreenReformer.h"

NSString * const kScreenShare = @"kScreenShare";

@implementation JCSplitScreenReformer
{
    JCEngineManager *_confManager;
    
    //分屏的数据源，保存成员的userId和屏幕共享等自定义字符串
    NSMutableArray<NSString *> *_splitScreenData;
    
    JCSplitScreenView *_splitScreenView;
    
    BOOL _needUpdate;
    
    BOOL _fullScreen;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _confManager = [JCEngineManager sharedManager];
        [_confManager setDelegate:self];
        _splitScreenData = [NSMutableArray array];
        _needUpdate = NO;
    }
    return self;
}

- (void)dealloc
{
    for (JCSplitScreenViewCell *cell in _splitScreenView.visibleCells) {
        if (cell.markStringId) {
            [_confManager stopRender:cell.renderView];
        }
    }
}

#pragma mark - JCEngineDelegate

- (void)onRoomSceenShareStateChanged:(ErrorReason)eventReason
{
    if (eventReason == ScreenShareStop && [_splitScreenData containsObject:kScreenShare]) {
        //取消屏幕共享视频分辨率JCVideoPictureSizeSmall的请求
        [_confManager cancelScreenVideoRequestWithPictureSize:VideoPictureSizeSmall];
        for (JCSplitScreenViewCell *cell in _splitScreenView.visibleCells) {
            if ([cell.markStringId isEqualToString:kScreenShare]) {
                [_confManager stopRender:cell.renderView];
                cell.markStringId = nil;
                break;
            }
        }
        
        if ([_confManager getRoomInfo].participants.count > 3) {
            [self reload];
        } else {
            NSInteger index = [_splitScreenData indexOfObject:kScreenShare];
            [_splitScreenData removeObject:kScreenShare];
            [_splitScreenView deleteItemAtIndex:index];
        }
    }
}

- (void)onParticipantJoin:(NSString *)userId
{
    if (!_needUpdate) {
        return;
    }
    
    NSInteger index = -1;
    for (NSInteger i = 0; i < _splitScreenData.count; i++) {
        if ([_splitScreenData[i] isEqualToString:userId]) {
            index = i;
            break;
        }
    }
    
//    if (_splitScreenData.count < 4) {
        [_splitScreenData addObject:userId];
        [_splitScreenView insertItemAtIndex:[_splitScreenData indexOfObject:userId]];
//    }
}

- (void)onParticipantLeft:(ErrorReason)eventReason userId:(NSString *)userId
{
    if (!_needUpdate) {
        return;
    }
    
    NSInteger index = -1;
    for (NSInteger i = 0; i < _splitScreenData.count; i++) {
        if ([_splitScreenData[i] isEqualToString:userId]) {
            index = i;
            break;
        }
    }
    
    for (JCSplitScreenViewCell *cell in _splitScreenView.visibleCells) {
        if ([cell.markStringId isEqualToString:userId]) {
            [_confManager stopRender:cell.renderView];
            cell.markStringId = nil;
            break;
        }
    }
    
    if ([_confManager getRoomInfo].participants.count > 3) {
        [self reload];
    } else {
        if (index != -1) {
            [_splitScreenData removeObjectAtIndex:index];
            [_splitScreenView deleteItemAtIndex:index];
            [self reload];
        }
    }
}

- (void)onParticipantUpdated:(NSString *)userId
{
    if (!_needUpdate) {
        return;
    }
    
    NSInteger index = -1;
    for (NSInteger i = 0; i < _splitScreenData.count; i++) {
        if ([_splitScreenData[i] isEqualToString:userId]) {
            index = i;
            break;
        }
    }

    if (index != -1) {
        [_splitScreenView reloadItemAtIndex:index];
    }
}

#pragma mark - SplitScreenViewDataSource

- (NSInteger)numberOfItemsInSplitScreenView:(JCSplitScreenView *)splitScreenView
{
    return _splitScreenData.count;
}

- (JCSplitScreenViewCell *)splitScreenView:(JCSplitScreenView *)splitScreenView cellForItemAtIndex:(NSInteger)index
{
    JCSplitScreenViewCell *cell = [_splitScreenView dequeueReusableCellForIndex:index];
    
    NSString *userId = [_splitScreenData objectAtIndex:index];
    
    if ([userId isEqualToString:kScreenShare]) {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@-%@", [[JCEngineManager sharedManager] getRoomInfo].screenSharer.displayName, NSLocalizedString(@"screen share", nil)];
        cell.microphoneView.hidden = YES;
        cell.videoOffView.hidden = YES;
        
        [[JCEngineManager sharedManager] requestScreenVideoWithPictureSize:VideoPictureSizeSmall];
        
        //表示屏幕共享的视频已经渲染在_renderView
        if ([cell.markStringId isEqualToString:kScreenShare]) {
            return cell;
        }
        
        //表示已经渲染了视频，现要渲染屏幕共享的视频，需要先停止渲染原来的视频
        if (cell.markStringId) {
            [[JCEngineManager sharedManager] stopRender:cell.renderView];
            cell.markStringId = nil;
        }
        
        [[JCEngineManager sharedManager] startScreenRender:cell.renderView mode:RenderFullScreen completed:^{
            
        }];
        
        cell.markStringId = userId;
    } else {
        JCParticipantModel *model = [[JCEngineManager sharedManager] getParticipantWithUserId:userId];
        
        cell.titleLabel.text = model.displayName;
        
        //能收到该成员的语音数据
        BOOL canReceiveAudio = model.isAudioUpload && model.isAudioForward;
        
        //能收到该成员的视频数据
        BOOL canReceiveVideo = model.isVideoUpload && model.isVideoForward;
        
        cell.microphoneView.hidden = !canReceiveAudio;
        cell.videoOffView.hidden = canReceiveVideo;
        
        //首先请求订阅视频，分屏显示的分辨率在中间档JCVideoPictureSizeSmall
        [[JCEngineManager sharedManager] requestVideoWithUserId:model.userId pictureSize:VideoPictureSizeSmall];
        
        //已经渲染了该成员的视频，无需重复渲染
        if ([cell.markStringId isEqualToString:model.userId]) {
            return cell;
        }
        
        //表示已经渲染了视频，现要渲染另一个成员的视频，需要先停止渲染原来成员的视频
        if (cell.markStringId) {
            [[JCEngineManager sharedManager] stopRender:cell.renderView];
            cell.markStringId = nil;
        }
        
        RenderMode mode = RenderFullScreen;
//        RenderMode mode = RenderFullContent;
//        RenderMode mode = RenderAuto;
        //开始渲染
        [[JCEngineManager sharedManager] startRender:cell.renderView userId:model.userId mode:mode completed:^{
            
        }];
        
        cell.markStringId = model.userId;
    }
    
    return cell;
}

- (void)didDoubleSelectRowAtIndex:(NSInteger)index
{
    if (_fullScreen) {
        [self reload];
    } else {
        NSString *userid = [self getUserId:index];
        [_splitScreenData removeAllObjects];
        [_splitScreenData addObject:userid];
        [_splitScreenView reloadData];
    }
    _fullScreen = !_fullScreen;
}

#pragma mark - public function

- (void)bindSplitScreenView:(JCSplitScreenView *)view
{
    if (_splitScreenView != view) {
        _splitScreenView = view;
        _splitScreenView.dataSource = self;
    }
}

- (void)reload
{
    _needUpdate = YES;
    
    //清空分屏的数据源
    [_splitScreenData removeAllObjects];
    
    JCRoomModel *confInfo = [_confManager getRoomInfo];
    
    for (JCParticipantModel *model in confInfo.participants) {
        [_splitScreenData addObject:model.userId];
//        if (_splitScreenData.count == 4) {
//            break;
//        }
    }
    
    //如果会议中有成员发起屏幕共享
    if (confInfo.screenSharer) {
//        if (_splitScreenData.count == 4) {
//            [_splitScreenData removeLastObject];
//        }
        
        [_splitScreenData addObject:kScreenShare];
    }
    
    [_splitScreenView reloadData];
}

- (void)stop
{
    for (NSString *userId in _splitScreenData) {
        if ([userId isEqualToString:kScreenShare]) {
            [_confManager cancelScreenVideoRequestWithPictureSize:VideoPictureSizeSmall];
        } else {
            [_confManager cancelVideoRequestWithUserId:userId pictureSize:VideoPictureSizeSmall];
        }
    }
    
    for (JCSplitScreenViewCell *cell in _splitScreenView.visibleCells) {
        if (cell.markStringId) {
            [_confManager stopRender:cell.renderView];
            cell.markStringId = nil;
        }
    }
}

- (NSString *)getUserId:(NSInteger)index
{
    NSString *userid = nil;
    if (index >= 0 && index < _splitScreenData.count ) {
        userid = [_splitScreenData objectAtIndex:index];
    }
    return userid;
}
@end
