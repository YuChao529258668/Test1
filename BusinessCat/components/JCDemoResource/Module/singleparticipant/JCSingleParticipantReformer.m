//
//  SingleParticipantReformer.m
//  UltimateShow
//
//  Created by 沈世达 on 17/4/19.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCSingleParticipantReformer.h"
#import "JCVideoDisplayView.h"

@interface JCSingleParticipantReformer ()
{
    JCEngineManager *_confManager;
    NSMutableArray<NSString *> *_participantDataSource; //会议中所有成员的数据源，保存成员的userId
    JCVideoDisplayView *_preview;
}

@end

@implementation JCSingleParticipantReformer

- (instancetype) init {
    
    if (self = [super init]) {
        _confManager = [JCEngineManager sharedManager];
        [_confManager setDelegate:self];
    }
    return self;
}

- (void)bindRenderView:(JCVideoDisplayView *)view
{
    if (_preview != view) {
        _preview = view;
    }
}

- (void)reloadWithUserId:(NSString *)userId
{
    JCParticipantModel * model = [_confManager getParticipantWithUserId:userId];

    
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
}

- (void)stop
{

}

@end
