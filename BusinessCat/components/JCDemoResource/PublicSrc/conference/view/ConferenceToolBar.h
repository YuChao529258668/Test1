//
//  ConferenceToolBar.h
//  UltimateShow
//
//  Created by young on 17/1/17.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConferenceToolBar;

typedef NS_ENUM(NSUInteger, ConferenceToolBarButtonType) {
    ConferenceToolBarButtonVideo = 1,     //摄像头开关
    ConferenceToolBarButtonCamera,        //摄像头前后切换
    ConferenceToolBarButtonVolume,        //本地声音开关
    ConferenceToolBarButtonMicrophone,    //麦克风
    
    ConferenceToolBarButtonREC,    // 录制
    ConferenceToolBarButtonLive,    // 直播
    ConferenceToolBarButtonChange,    // 修改会议
    ConferenceToolBarButtonEnd,    // 结束会议
//    ConferenceToolBarButtonDoodle,        //涂鸦
//    ConferenceToolBarButtonSplitScreen    //分屏
};


@protocol ConferenceToolBarDelegate <NSObject>
/**
 按钮的代理事件
 
 @param toolBar             ConferenceToolBar对象
 @param button              UIButton对象
 @param buttonType          提供这几种模式，@ref ConferenceToolBarButtonType
 */
- (void)conferenceToolBar:(ConferenceToolBar *)toolBar clickButton:(UIButton *)button buttonType:(ConferenceToolBarButtonType)type;

@end

@interface ConferenceToolBar : UIView

@property (nonatomic, weak) id<ConferenceToolBarDelegate> delegate;
// 按钮的数组
@property (nonatomic, readonly, strong) NSArray<UIButton *> *buttons;



+ (instancetype)bar;

@property (weak, nonatomic) IBOutlet UIButton *microphoneBtn;// 麦克风
@property (weak, nonatomic) IBOutlet UIButton *volumeBtn;// 扬声器
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;// 视频
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;// 切换摄像头
@property (weak, nonatomic) IBOutlet UIButton *RECBtn;// 录制
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;// 直播
@property (weak, nonatomic) IBOutlet UIButton *changeBtn; // 修改会议
@property (weak, nonatomic) IBOutlet UIButton *endBtn;// 结束会议

@property (weak, nonatomic) IBOutlet UILabel *microphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
//@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;
@property (weak, nonatomic) IBOutlet UILabel *RECLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint; // 中间白色视图的高度约束


// 修改按钮状态后要调用
- (void)updateLabels;





@end
