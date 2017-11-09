//
//  VideoDisplayView.m
//  UltimateShow
//
//  Created by Nathan Zheng on 2017/1/13.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCVideoDisplayView.h"

@interface JCVideoDisplayView ()
{
    UIView *_renderView;
    UIImageView *_videoOffStatusView;
}

@end

@implementation JCVideoDisplayView

- (UIView *)renderView
{
    return _renderView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self initView];
}

- (void)initView
{
    if (!_renderView) {
        _renderView = [[UIView alloc] init];
        [self addSubview:_renderView];
    }
    
    if (!_videoOffStatusView) {
        _videoOffStatusView = [[UIImageView alloc] init];
        _videoOffStatusView.hidden = YES;
        _videoOffStatusView.contentMode = UIViewContentModeCenter;
        _videoOffStatusView.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0];
        [self addSubview:_videoOffStatusView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_renderView) {
        _renderView.frame = self.bounds;
    }
    
    if (_videoOffStatusView) {
        _videoOffStatusView.frame = self.bounds;
    }
}

- (void)showVideoOffViewOfSize:(VideoOffImageSize)size
{
    NSString *imageName = @"";
    switch (size) {
        case VideoOffImageSize24:
            imageName = @"status_camera_off_24";
            break;
        case VideoOffImageSize40:
            imageName = @"status_camera_off_40";
            break;
        case VideoOffImageSize50:
            imageName = @"status_camera_off_50";
            break;
        default:
            imageName = @"status_camera_off_24";
            break;
    }
    
    _videoOffStatusView.image = [UIImage imageNamed:imageName];
    _videoOffStatusView.hidden = NO;
}

- (void)hideVideoOffView
{
    _videoOffStatusView.hidden = YES;
}

@end
