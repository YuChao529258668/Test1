//
//  ParticipantCell.h
//  UltimateShow
//
//  Created by young on 16/12/6.
//  Copyright © 2016年 young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCVideoDisplayView.h"

@interface JCParticipantCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;

//显示成员昵称
@property (nonatomic, strong) UILabel *nameLabel;

//渲染成员视频
@property (nonatomic, strong) JCVideoDisplayView *videoView;

//成员是否为host的状态标志
@property (nonatomic, strong) UIImageView *hostStatusView;

//成员发言状态标志
@property (nonatomic, strong) UIImageView *microphoneStatusView;

//设置成员的userId，并且显示该成员的昵称和渲染该成员的视频
@property (nonatomic, copy) NSString *userId;

//设置视频请求的分辨率，默认为NO，请求的分辨率低的视频
@property (nonatomic) BOOL wantsHighResolution;

@end
