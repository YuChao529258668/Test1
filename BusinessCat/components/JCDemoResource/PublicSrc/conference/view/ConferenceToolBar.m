//
//  ConferenceToolBar.m
//  UltimateShow
//
//  Created by young on 17/1/17.
//  Copyright © 2017年 young. All rights reserved.
//

#import "ConferenceToolBar.h"

#define kToolBarButtonCount 4
#define kToolBarButtonWidth 44
#define kToolBarButtonHeight 44
#define kToolBarButtonSpacing 28

@interface ConferenceToolBar ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ConferenceToolBar

- (IBAction)clickCloseBtn:(id)sender {
    self.hidden = YES;
}

+ (instancetype)bar {
    ConferenceToolBar *bar = [[NSBundle mainBundle] loadNibNamed:@"ConferenceToolBar" owner:nil options:nil].lastObject;
    return bar;
}

- (NSArray<UIButton *> *)buttons
{
    return _buttonArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initButtons];
        [self configSubviews];
        [self updateLabels];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self initButtons];
    [self configSubviews];
    [self updateLabels];
    
}

- (void)initButtons
{
    _buttonArray = [NSMutableArray array];
    
    NSArray *normalImages = @[@"video_videobtn_normal",
                              @"video_turn",
                              @"video_volume_highlight",
                              @"video_speech_normal"];

    NSArray *selectImages = @[@"video_videobtn_highlight",
                              @"video_turn",
                              @"video_volume_normal",
                              @"video_speech_highlight"];

//    NSArray *normalImages = @[@"camera_off",
//                              @"camera_switch_normal",
//                              @"volume_on",
//                              @"microphone_off"];
    
//    NSArray *highlightImages = @[@"camera_off_highlighted",
//                                 @"camera_switch_highlighted",
//                                 @"volume_on_highlighted",
//                                 @"microphone_off_highlighted"];
    
//    NSArray *selectImages = @[@"camera_on",
//                              @"",
//                              @"volume_off",
//                              @"microphone_on"];
    
//    NSArray *selecthighlightImages = @[@"camera_on_highlighted",
//                                       @"",
//                                       @"volume_off_highlighted",
//                                       @"microphone_on_highlighted"];
    
    for (int i = 0; i < kToolBarButtonCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:highlightImages[i]] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:selectImages[i]] forState:UIControlStateSelected];
//        [button setImage:[UIImage imageNamed:selecthighlightImages[i]] forState:UIControlStateSelected | UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [_buttonArray addObject:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat totalWidth = kToolBarButtonWidth * kToolBarButtonCount + kToolBarButtonSpacing * (kToolBarButtonCount - 1);
    
//    CGSize size = self.bounds.size;
    
    [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.frame = CGRectMake((size.width - totalWidth) / 2 + idx * (kToolBarButtonWidth + kToolBarButtonSpacing),
//                               (size.height - kToolBarButtonHeight) / 2,
//                               kToolBarButtonWidth,
//                               kToolBarButtonHeight);
        
//        float x = self.superview.frame.size.width - 15 - 26;
        float y = (10 + 26) * idx;
        obj.frame = CGRectMake(0, y, 26, 26);
    }];
}

- (IBAction)click:(UIButton *)button
{
//    if (_delegate) {
//        [_delegate conferenceToolBar:self clickButton:button buttonType:[_buttonArray indexOfObject:button]];
//    }
    
    if (_delegate) {
        [_delegate conferenceToolBar:self clickButton:button buttonType:button.tag];
        [self updateLabels];
    }

}

- (void)updateLabels {
    // isSelected 是改变后的按钮状态
    self.microphoneLabel.text = !self.microphoneBtn.isSelected? @"禁语音": @"语音中";
    self.volumeLabel.text = self.volumeBtn.isSelected? @"禁扬声": @"扬声中";
    self.videoLabel.text = !self.videoBtn.isSelected? @"禁视频": @"视频中";
    
    self.RECLabel.text = !self.RECBtn.isSelected? @"待录制": @"录制中";
    self.liveLabel.text = !self.liveBtn.isSelected? @"待直播": @"直播中";
}

- (void)configSubviews {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.contentView.layer.cornerRadius = 6;
    self.contentView.clipsToBounds = YES;

    
    float scale = 0.9;
    CGPoint center = self.contentView.center;
    self.contentView.transform = CGAffineTransformMakeScale(scale, scale);
    self.contentView.center = center;

    
    self.microphoneBtn.tag = ConferenceToolBarButtonMicrophone;
    self.volumeBtn.tag = ConferenceToolBarButtonVolume;
    self.videoBtn.tag = ConferenceToolBarButtonVideo;
    
    self.cameraBtn.tag = ConferenceToolBarButtonCamera;
    self.RECBtn.tag = ConferenceToolBarButtonREC;
    self.liveBtn.tag = ConferenceToolBarButtonLive;
    
    self.changeBtn.tag = ConferenceToolBarButtonChange;
    self.endBtn.tag = ConferenceToolBarButtonEnd;
    
    self.videoBtn.selected = YES;
    
    
    _buttonArray = [NSMutableArray array];
    
    [_buttonArray addObject:self.microphoneBtn];
    [_buttonArray addObject:self.volumeBtn];
    [_buttonArray addObject:self.videoBtn];
    [_buttonArray addObject:self.cameraBtn];
    
    [_buttonArray addObject:self.RECBtn];
    [_buttonArray addObject:self.liveBtn];
    [_buttonArray addObject:self.changeBtn];
    [_buttonArray addObject:self.endBtn];
    
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.textColor = [UIColor darkGrayColor];
        }
    }
}



@end
