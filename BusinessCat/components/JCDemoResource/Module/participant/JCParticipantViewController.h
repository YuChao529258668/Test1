//
//  ParticipantViewController.h
//  UltimateShow
//
//  Created by Nathan Zheng on 2017/3/21.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ParticipantViewDelegate <NSObject>

//cell点击事件回调
- (void)didSelectRowForUserId:(NSString *)userId;

@end

@interface JCParticipantViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<ParticipantViewDelegate> delegate;

//展示会议成员列表的视图
@property (nonatomic, strong) UITableView *participantTableView;

//一屏中可显示的cell数，默认为4个
@property (nonatomic) NSUInteger visibleCellCount;

//设置视频显示的分辨率，默认 NO，显示低分辨率
@property (nonatomic) BOOL wantsHighResolution;


/**
 * @brief  配置自定义cell，配置前先调用UITableView 的registerNib或registerClass注册自定义的cell
 *
 * @param  identifier  必须和注册自定义的cell时使用的cellId一致
 * @param  block 把userId传递给cell，自定义cell中使用userId来获取成员对象，然后可以展示成员的信息和渲染成员视频
 */
- (void)setCellWithIdentifier:(NSString *)identifier configureBlock:(void (^)(id cell, NSString *userId))block;

//刷新成员列表
- (void)reload;

//停止成员列表的视频请求
- (void)stopShow;

@end
