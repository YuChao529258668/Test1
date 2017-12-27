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

@end

@implementation ConferenceToolBar

- (NSArray<UIButton *> *)buttons
{
    return _buttonArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButtons];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initButtons];
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
    
    CGFloat totalWidth = kToolBarButtonWidth * kToolBarButtonCount + kToolBarButtonSpacing * (kToolBarButtonCount - 1);
    
    CGSize size = self.bounds.size;
    
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

- (void)click:(UIButton *)button
{
    if (_delegate) {
        [_delegate conferenceToolBar:self clickButton:button buttonType:[_buttonArray indexOfObject:button]];
    }
}


@end
