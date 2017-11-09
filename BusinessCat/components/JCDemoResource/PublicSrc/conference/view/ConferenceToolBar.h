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
    ConferenceToolBarButtonVideo = 0,     //摄像头开关
    ConferenceToolBarButtonCamera,        //摄像头前后切换
    ConferenceToolBarButtonVolume,        //本地声音开关
    ConferenceToolBarButtonMicrophone,    //麦克风
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

@end
