//
//  ParticipantCell.m
//  UltimateShow
//
//  Created by young on 16/12/6.
//  Copyright © 2016年 young. All rights reserved.
//

#import "JCParticipantCell.h"
#import <JCApi/JCApi.h>

@interface JCParticipantCell ()

//用于标记是否已经渲染视频
@property (nonatomic, copy) NSString *markStringId;

@end

@implementation JCParticipantCell

- (void)setWantsHighResolution:(BOOL)wantsHighResolution {
    if (_wantsHighResolution != wantsHighResolution) {
        _wantsHighResolution = wantsHighResolution;
    }
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return _nameLabel;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5.0f;
        _backView.layer.borderWidth = 1.0f;
        _backView.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    return _backView;
}

- (JCVideoDisplayView *)videoView {
    if (!_videoView) {
        _videoView = [[JCVideoDisplayView alloc] init];
    }
    return _videoView;
}

- (UIImageView *)hostStatusView {
    if (!_hostStatusView) {
        _hostStatusView = [[UIImageView alloc] init];
        _hostStatusView.image = [UIImage imageNamed:@"status_host_on"];
    }
    return _hostStatusView;
}

- (UIImageView *)microphoneStatusView {
    if (!_microphoneStatusView) {
        _microphoneStatusView = [[UIImageView alloc] init];
        _microphoneStatusView.image = [UIImage imageNamed:@"status_microphone"];
    }
    return _microphoneStatusView;
}

- (void)dealloc {
    if (_markStringId) {
        [[JCEngineManager sharedManager] stopRender:_videoView.renderView];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.videoView];
        [self.backView addSubview:self.hostStatusView];
        [self.backView addSubview:self.microphoneStatusView];
        
        _wantsHighResolution = NO;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.videoView];
    [self.backView addSubview:self.hostStatusView];
    [self.backView addSubview:self.microphoneStatusView];
    
    _wantsHighResolution = NO;
    
}

- (void)layoutSubviews {
    CGRect cellRect = self.bounds;
    if (_nameLabel) {
        _nameLabel.frame = CGRectMake(0, 4, CGRectGetWidth(cellRect), 12);
        //与cell等宽，与cell上边距不变
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    if (_backView) {
        CGFloat bY = CGRectGetMaxY(_nameLabel.frame);
        _backView.frame = CGRectMake(0, bY, CGRectGetWidth(cellRect), CGRectGetHeight(cellRect) - bY);
        _backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    if (_videoView) {
        _videoView.frame = _backView.bounds;
        _videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    if (_hostStatusView) {
        _hostStatusView.frame = CGRectMake(3, 3, 24, 24);
        _hostStatusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    
    if (_microphoneStatusView) {
        CGFloat mY = _backView.bounds.size.height - 3 - 24;
        _microphoneStatusView.frame = CGRectMake(3, mY, 24, 24);
        //与cell左边距不变，与cell下边距不变
        _microphoneStatusView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.backView.layer.borderWidth = 1.5f;
        self.backView.layer.borderColor = [UIColor colorWithRed:3.0f/255.0f green:169.0f/255.0f blue:244.0f/255.0f alpha:1.0f].CGColor;
        self.nameLabel.textColor = [UIColor colorWithRed:3.0f/255.0f green:169.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    } else {
        self.backView.layer.borderWidth = 1.0f;
        self.backView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.nameLabel.textColor = [UIColor whiteColor];
    }
}

- (void)setUserId:(NSString *)userId {
    if (_userId != userId) {
        _userId = userId;
    }
    
    JCParticipantModel *model = [[JCEngineManager sharedManager] getParticipantWithUserId:userId];
    
    if (!model) {
        return;
    }
        
    _nameLabel.text = model.displayName;
    
    //能收到该成员的语音数据
    BOOL canReceiveAudio = model.isAudioUpload && model.isAudioForward;
    _microphoneStatusView.hidden = !canReceiveAudio;
    
    //能收到该成员的视频数据
    BOOL canReceiveVideo = model.isVideoUpload && model.isVideoForward;
    
    if (canReceiveVideo) {
        [_videoView hideVideoOffView];
    } else {
        [_videoView showVideoOffViewOfSize:VideoOffImageSize24];
    }
    
    _hostStatusView.hidden = !model.isHost;
    
    if ([[JCEngineManager sharedManager] getRoomInfo].mode == JCRoomModeHost) {
        _hostStatusView.image = [UIImage imageNamed:@"status_host_on"];
    } else {
        _hostStatusView.image = [UIImage imageNamed:@"status_host_off"];
    }
    
    //请求成员视频
    [[JCEngineManager sharedManager] requestVideoWithUserId:model.userId pictureSize:_wantsHighResolution ? VideoPictureSizeSmall : VideoPictureSizeMin];
    
    //markStringId和当前成员的userId相同，表示renderView已经渲染了该成员的视频，无需重复渲染
    if ([_markStringId isEqualToString:model.userId]) {
        return;
    }
    
    //markStringId存在表示renderView已经渲染了上一个成员的视频, 要先stop上一个视频的渲染
    if (_markStringId) {
        [[JCEngineManager sharedManager] stopRender:_videoView.renderView];
    }
    
    //开始渲染，必须在会议结束（该cell对象释放）要调用stopRender释放资源
    [[JCEngineManager sharedManager] startRender:_videoView.renderView userId:model.userId mode:RenderFullScreen completed:nil];
    
    _markStringId = userId;
    
}

@end
