//
//  YCVideoController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/12.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCVideoController.h"

@interface YCVideoController ()<TXLivePlayListener>
@property (nonatomic,strong) TXLivePlayer *livePlayer;
@property (nonatomic,assign) BOOL  hasStarted; // 是否开始播放，不是正在播放
@property (nonatomic,assign) float duration; // 时长

@property (nonatomic,assign) CGRect oldFrame;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation YCVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.livePlayer = [[TXLivePlayer alloc] init];
    self.livePlayer.delegate = self;
    
    self.currentLabel.textColor = [UIColor whiteColor];
    self.totalLabel.textColor = [UIColor whiteColor];

    self.navigationController.navigationBar.hidden = YES;
//    [UIApplication sharedApplication].statusBarHidden
    
    [_livePlayer setupVideoWidget:CGRectZero containView:self.videoView insertIndex:0];
    [self.view sendSubviewToBack:self.videoView];
    [_livePlayer setRenderMode:RENDER_MODE_FILL_EDGE];

//    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.slider.continuous = NO;
    [self showIndicatorView:NO];
}

- (void)viewDidLayoutSubviews {
    self.oldFrame = self.view.frame;
}

-(void)dealloc {
    [_livePlayer removeVideoWidget];
}

#pragma mark -

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


#pragma mark - TXLivePlayListener

- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary*)param {
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
//            [self.slider setValue:0];
//            [self stopVideoPreview:YES];
//            [self startVideoPreview:YES];
            self.playBtn.selected = NO;
            self.hasStarted = NO;
        }
    });

}

- (void)onNetStatus:(NSDictionary*) param {
    
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
    self.playBtn.selected = !self.playBtn.isSelected;
    
    if (self.hasStarted) {
        if (self.livePlayer.isPlaying) {
            [_livePlayer pause];
        } else {
            [_livePlayer resume];
        }
    } else {
        [self showIndicatorView:YES];
        [_livePlayer startPlay:self.videoPath type:PLAY_TYPE_VOD_MP4];// 点播类型
        self.hasStarted = YES;
    }
}

- (IBAction)sliderValueChange:(id)sender {
    float value = self.slider.value;
    [self.livePlayer seek:value];
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
