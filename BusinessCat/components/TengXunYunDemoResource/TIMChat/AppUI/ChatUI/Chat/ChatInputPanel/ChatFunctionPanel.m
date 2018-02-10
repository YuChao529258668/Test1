//
//  ChatFunctionPanel.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/21.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatFunctionPanel.h"

@implementation ChatFunctionPanel

- (instancetype)init
{
    if (self = [super init])
    {
//        _contentHeight = 105;
        _contentHeight = 105*2;
    }
    return self;
}
- (void)addOwnViews
{
    _image = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    _image.imageSize = CGSizeMake(60, 60);
    _image.margin = UIEdgeInsetsMake(10, 0, 0, 10);
    _image.titleLabel.textAlignment = NSTextAlignmentCenter;
    _image.titleLabel.font = kAppMiddleTextFont;
    [_image setTitleColor:kGrayColor forState:UIControlStateNormal];
    [_image setTitle:@"图片" forState:UIControlStateNormal];
    [_image setImage:[UIImage imageNamed:@"input_image"] forState:UIControlStateNormal];
    [_image addTarget:self action:@selector(onClickImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_image];

    _photo = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    _photo.imageSize = CGSizeMake(60, 60);
    _photo.margin = UIEdgeInsetsMake(10, 0, 0, 10);
    _photo.titleLabel.textAlignment = NSTextAlignmentCenter;
    _photo.titleLabel.font = kAppMiddleTextFont;
    [_photo setTitleColor:kGrayColor forState:UIControlStateNormal];
    [_photo setTitle:@"拍摄" forState:UIControlStateNormal];
    
    [_photo setImage:[UIImage imageNamed:@"input_photo"] forState:UIControlStateNormal];
    [_photo addTarget:self action:@selector(onClickPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photo];
    
    _file = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    _file.imageSize = CGSizeMake(60, 60);
    _file.margin = UIEdgeInsetsMake(10, 0, 0, 10);
    _file.titleLabel.textAlignment = NSTextAlignmentCenter;
    _file.titleLabel.font = kAppMiddleTextFont;
    [_file setTitleColor:kGrayColor forState:UIControlStateNormal];
    [_file setTitle:@"文件" forState:UIControlStateNormal];
    
    [_file setImage:[UIImage imageNamed:@"input_file"] forState:UIControlStateNormal];
    [_file addTarget:self action:@selector(onClickFile:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_file];

    _video = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    _video.imageSize = CGSizeMake(60, 60);
    _video.margin = UIEdgeInsetsMake(10, 0, 0, 10);
    _video.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_video setTitleColor:kGrayColor forState:UIControlStateNormal];
    _video.titleLabel.font = kAppMiddleTextFont;
    [_video setTitle:@"小视频" forState:UIControlStateNormal];
    [_video setImage:[UIImage imageNamed:@"input_video"] forState:UIControlStateNormal];
    [_video addTarget:self action:@selector(onClickVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_video];
    
    _meeting = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    _meeting.imageSize = CGSizeMake(60, 60);
    _meeting.margin = UIEdgeInsetsMake(10, 0, 0, 10);
    _meeting.titleLabel.textAlignment = NSTextAlignmentCenter;
    _meeting.titleLabel.font = kAppMiddleTextFont;
    [_meeting setTitleColor:kGrayColor forState:UIControlStateNormal];
    [_meeting setTitle:@"继续开会" forState:UIControlStateNormal];
    [_meeting setImage:[UIImage imageNamed:@"chat_icon_toolbar_meet"] forState:UIControlStateNormal];
    [_meeting addTarget:self action:@selector(onClickMeeting:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_meeting];

    _vote = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    _vote.imageSize = CGSizeMake(60, 60);
    _vote.margin = UIEdgeInsetsMake(10, 0, 0, 10);
    _vote.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_vote setTitleColor:kGrayColor forState:UIControlStateNormal];
    _vote.titleLabel.font = kAppMiddleTextFont;
    [_vote setTitle:@"投票" forState:UIControlStateNormal];
    [_vote setImage:[UIImage imageNamed:@"chat_icon_toolbar_toupiao"] forState:UIControlStateNormal];
    [_vote addTarget:self action:@selector(onClickVote:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_vote];

}

- (void)onClickImage:(UIButton *)btn
{
    if ([_chatDelegate respondsToSelector:@selector(onChatInputSendImage:)])
    {
        [_chatDelegate onChatInputSendImage:self];
    }
}

- (void)onClickPhoto:(UIButton *)btn
{
    if ([_chatDelegate respondsToSelector:@selector(onChatInputTakePhoto:)])
    {
        [_chatDelegate onChatInputTakePhoto:self];
    }
}

- (void)onClickFile:(UIButton *)btn
{
    if ([_chatDelegate respondsToSelector:@selector(onChatInputSendFile:)])
    {
        [_chatDelegate onChatInputSendFile:self];
    }
}

- (void)onClickVideo:(UIButton *)btn
{
    if ([_chatDelegate respondsToSelector:@selector(onChatInputRecordVideo:)])
    {
        [_chatDelegate onChatInputRecordVideo:self];
    }
}

- (void)onClickMeeting:(UIButton *)btn {
    if ([_chatDelegate respondsToSelector:@selector(onChatInputMeeting:)])
    {
        [_chatDelegate onChatInputMeeting:self];
    }
}
- (void)onClickVote:(UIButton *)btn {
    if ([_chatDelegate respondsToSelector:@selector(onChatInputVote:)])
    {
        [_chatDelegate onChatInputVote:self];
    }
}


- (void)relayoutFrameOfSubViews
{
//    [self alignSubviews:@[_image, _photo, _video, _file] horizontallyWithPadding:0 margin:0 inRect:self.bounds];
    float w = self.bounds.size.width;
    float h = self.bounds.size.height;
    CGRect line1 = CGRectMake(0, 0, w, h/2);
    CGRect line2 = CGRectMake(0, h/2, w/2, h/2);
    [self alignSubviews:@[_meeting, _image, _photo, _video] horizontallyWithPadding:0 margin:0 inRect:line1];
    [self alignSubviews:@[_file, _vote] horizontallyWithPadding:0 margin:0 inRect:line2];
}


@end
