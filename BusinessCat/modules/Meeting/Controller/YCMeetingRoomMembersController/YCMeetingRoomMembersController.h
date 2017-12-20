//
//  YCMeetingRoomMembersController.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CGMeeting.h"
//#import "JCWhiteBoardViewController.h"

@interface YCMeetingRoomMembersController : UIViewController

@property (nonatomic,strong) NSString *meetingCreatorID;// 主持人 id ，申请互动用到
@property (nonatomic,assign) BOOL isMeetingCreator; // 当前用户是否主持人
@property (nonatomic,strong) NSString *meetingID;

//@property (nonatomic,strong) JCWhiteBoardViewController *whiteBoardVC;
@property (nonatomic,copy) void (^onStateChangeBlock)(long interactState);


// 解析并更新所有人状态
//- (void)updateStates:(NSString *)stateStr;

//- (void)sendUpdateStatesCommand;
//- (void)sendAllowInteractionCommand;
//- (void)sendEndInteractionCommand;
//- (void)sendQueryInteractionStateCommand;


- (void)getMeetingUser;
- (void)updateUserInteractingState:(long)interactState withUserID:(NSString *)userID;
// 更新服务器并且群发命令
- (void)onUserLeft:(NSString *)userID;

@end
