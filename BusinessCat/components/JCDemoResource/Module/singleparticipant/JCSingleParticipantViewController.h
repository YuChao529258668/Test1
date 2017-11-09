//
//  SingleViewController.h
//  UltimateShow
//
//  Created by 沈世达 on 17/4/19.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleParticipantViewDelegate <NSObject>

// 点击事件回调
- (void)didSelectView;

@end

@interface JCSingleParticipantViewController : UIViewController

@property (nonatomic, weak) id<SingleParticipantViewDelegate> delegate;

- (void)reloadSingleParticpantWithUserId:(NSString *)userId;

- (void)stopSingleParticpant;

@end
