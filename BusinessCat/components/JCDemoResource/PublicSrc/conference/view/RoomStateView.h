//
//  RoomStateView.h
//  BusinessCat
//
//  Created by 余超 on 2018/4/20.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoomStateViewDelegate;


@interface RoomStateView : UIView

@property (nonatomic, weak) id<RoomStateViewDelegate> delegate;
@property (nonatomic, strong) NSDate *beginDate;

@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;

@property (weak, nonatomic) IBOutlet UILabel *topStateL;
@property (weak, nonatomic) IBOutlet UIImageView *stateIV;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *countDownL;

@property (nonatomic, assign) int state;

+ (instancetype)view;

- (void)updateOnlineCount:(NSInteger)count;
- (void)updateTotalCount:(NSInteger)count;

- (void)showWelcomeViewWithName:(NSString *)name show:(BOOL)show;

- (void)stopTimer;

@end


@protocol RoomStateViewDelegate<NSObject>
- (void)clickBackBtnOfStateView:(RoomStateView *)view;
- (void)stateView:(RoomStateView *)view clickBarBtn:(UIButton *)btn atIndex:(NSInteger)index;
- (void)clickPlayBtn;
@end
