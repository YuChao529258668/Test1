//
//  CGSettingEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGSettingEntity : NSObject
@property (nonatomic, assign) NSInteger disturb;//免打扰
@property (nonatomic, assign) NSInteger fontSize;//字体大小
@property (nonatomic, assign) NSInteger nightMode;//夜间模式
@property (nonatomic, assign) NSInteger noPic;//省流量无图模式
@property (nonatomic, assign) NSInteger vibration;//震动
@property (nonatomic, assign) NSInteger voice;//声音
@property (nonatomic, assign) NSInteger message;//接受新消息
@property (nonatomic, assign) NSInteger knowledgeMsg;//知识消息
@property (nonatomic, assign) NSInteger everydayMsg;//每日消息
@property (nonatomic, assign) NSInteger rewardMsg;//打赏消息
@property (nonatomic, assign) NSInteger auditMsg;//审核消息
@property (nonatomic, assign) NSInteger exitMsg;//退出消息
@property (nonatomic, copy) NSString *officialTel;//官方电话
@property (nonatomic, copy) NSString *successfulInvitation;//成功邀请
@property (nonatomic, copy) NSString *timeLimit;//限时优惠
@property (nonatomic, copy) NSString *tiXianFee;//提现手续费
@property (nonatomic, copy) NSString *toolImg;//岗位工具图
@end
