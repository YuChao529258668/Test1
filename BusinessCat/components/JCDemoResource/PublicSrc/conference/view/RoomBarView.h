//
//  RoomBarView.h
//  BusinessCat
//
//  Created by 余超 on 2018/4/17.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoomBarViewDelegate;


@interface RoomBarView : UIView

@property (nonatomic, weak) id<RoomBarViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UIButton *soundBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
+ (instancetype)view;

- (void)updateOnlineCount:(NSInteger)count;
- (void)updateTotalCount:(NSInteger)count;

- (void)showWelcomeViewWithName:(NSString *)name show:(BOOL)show;

@end


@protocol RoomBarViewDelegate<NSObject>
- (void)clickBackBtn;
- (void)clickBarBtn:(UIButton *)btn atIndex:(NSInteger)index;
@end
