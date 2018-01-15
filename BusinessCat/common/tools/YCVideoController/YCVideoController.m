//
//  YCVideoController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/12.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCVideoController.h"

//#import <TXLiteAVSDK_UGC/TXLivePlayer.h>
#import <TXLiteAVSDK_UGC/TXVodPlayer.h>

// 播放在线视频，参考 TCVideoPreviewViewController，封装 TXLivePlayer


@interface YCVideoController ()<TXVodPlayListener>
@property (nonatomic,strong) TXVodPlayer *vodPlayer;
@property (nonatomic,assign) BOOL  hasStarted; // 是否开始播放，不是正在播放
@property (nonatomic,assign) float duration; // 时长

@property (nonatomic,assign) CGRect oldFrame;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong) NSMutableArray<TXVodPlayer *> *players;
@property (nonatomic,strong) NSArray *players2;

@end

@implementation YCVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.currentLabel.textColor = [UIColor whiteColor];
    self.totalLabel.textColor = [UIColor whiteColor];

    self.navigationController.navigationBar.hidden = YES;
//    [UIApplication sharedApplication].statusBarHidden
    
    [self.view sendSubviewToBack:self.videoView];

//    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.slider.continuous = NO;
    [self showIndicatorView:NO];
}

- (void)viewDidLayoutSubviews {
    self.oldFrame = self.view.frame;
}

-(void)dealloc {
    [_vodPlayer removeVideoWidget];
}

#pragma mark -

- (void)createPlayersWithVideoUrls:(NSMutableArray<NSString *> *)videoUrls {
    self.players = [NSMutableArray arrayWithCapacity:videoUrls.count];
    
    [videoUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TXVodPlayer *player = [[TXVodPlayer alloc] init];
        player.isAutoPlay = NO;
        [player setRenderMode:RENDER_MODE_FILL_EDGE];
        player.vodDelegate = self;
        [self.players addObject:player];
    }];
    self.players.firstObject.isAutoPlay = YES;
}

- (void)setVideoUrls:(NSMutableArray<NSString *> *)videoUrls {
    _videoUrls = videoUrls;
    
    if (videoUrls.count > 0) {
        [self createPlayersWithVideoUrls:videoUrls];
    }
}

- (void)showIndicatorView:(BOOL)show {
    if (show) {
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
    } else {
        self.indicatorView.hidden = YES;
        [self.indicatorView stopAnimating];
    }
}

- (NSString *)textForSeconds:(int)seconds {
    __block NSString *string;

    [YCTool HMSForSeconds:seconds block:^(NSInteger h, NSInteger m, NSInteger s) {
        if (h > 0) {
            string = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", h, m, s];
        } else {
            string = [NSString stringWithFormat:@"%02ld:%02ld", m, s];
        }
    }];
    return string;
}


#pragma mark - TXVodPlayListener

- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param {
    NSDictionary* dict = param;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            float duration = [dict[EVT_PLAY_DURATION] floatValue];
            
            if (duration > 0) {
                float progress = [dict[EVT_PLAY_PROGRESS] floatValue];
                [self.slider setValue:progress + 0.5];
                
                self.currentLabel.text = [self textForSeconds:progress];
            }
            
            if (duration > 0 && self.slider.maximumValue != duration) {
                self.slider.minimumValue = 0;
                self.slider.maximumValue = duration;
                self.totalLabel.text = [self textForSeconds:duration];
                self.duration = duration;
            }
            
            //            [self showIndicatorView:NO];
            
        } else if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            [self showIndicatorView:NO];
            
            // 拿不到数据
            //            float duration = [dict[EVT_PLAY_DURATION] floatValue];
            //            if (duration > 0 && self.slider.maximumValue != duration) {
            //                self.slider.minimumValue = 0;
            //                self.slider.maximumValue = duration;
            //            }
        } else if (EvtID == PLAY_EVT_PLAY_LOADING) {
            //            float duration = [dict[EVT_PLAY_DURATION] floatValue];
            //            if (duration > 0 && self.slider.maximumValue != duration) {
            //                self.slider.minimumValue = 0;
            //                self.slider.maximumValue = duration;
            //            }
        } else if(EvtID == PLAY_EVT_PLAY_END) {
            
            NSInteger next = [self.players indexOfObject:player] + 1;
            NSInteger lastIndex = self.players.count - 1;
            
            if (next > lastIndex) {
                self.playBtn.selected = NO;
                self.hasStarted = NO;
            } else {
                 // 停止当前的
                [_vodPlayer stopPlay];
                [_vodPlayer removeVideoWidget];

                 // 播放下一个
                _vodPlayer = self.players[next];
                [_vodPlayer setupVideoWidget:self.videoView insertIndex:0];
                [_vodPlayer resume];

                // 缓冲下一个的下一个
                next ++;
                if (next <= lastIndex) {
                    [self.players[next] startPlay:self.videoUrls[next]];
                }
                
            }
        }
    });
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary*)param {
    
}


#pragma mark - Actions

- (IBAction)clickBackBtn:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)clickPlayBtn:(id)sender {
    
    if (self.hasStarted) {
        if (self.vodPlayer.isPlaying) {
            [_vodPlayer pause];
        } else {
            [_vodPlayer resume];
        }
    } else {
        // 移除最后一个
        [_vodPlayer stopPlay];
        [_vodPlayer removeVideoWidget];

        _vodPlayer = self.players.firstObject;
        
        _vodPlayer.isAutoPlay = YES;
        [_vodPlayer setupVideoWidget:self.videoView insertIndex:0];
        
        //返回: 0 = OK
        int failue = [_vodPlayer startPlay:self.videoUrls.firstObject];
        
        if (!failue) {
            [self showIndicatorView:YES];
            self.hasStarted = YES;
            
            // 缓冲下一个
            if (self.videoUrls.count > 1) {
                [self.players[1] startPlay:self.videoUrls[1]];
            }

        } else {
            [CTToast showWithText:@"播放失败"];
            return;
        }
    }
    
    self.playBtn.selected = !self.playBtn.isSelected;
}

- (IBAction)sliderValueChange:(id)sender {
    float value = self.slider.value;
    [self.vodPlayer seek:value];
}

- (IBAction)clickFullScreenBtn:(UIButton *)sender {
    BOOL selected = !sender.isSelected;
    sender.selected = selected;
    
    if (selected) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.view.frame = [UIScreen mainScreen].bounds;
        }];
    } else {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(0);
            self.view.frame = self.oldFrame;
        }];
    }
}

@end
