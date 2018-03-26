//
//  CustomChatUIViewController.m
//  TIMChat
//
//  Created by wilderliao on 16/6/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "CustomChatUIViewController.h"

#import "YCMeetingBiz.h"
#import "RoomViewController.h"

@interface CustomChatUIViewController ()

@end

@implementation CustomChatUIViewController

#pragma mark - 适配旧代码

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMeetingBtn];
    self.tableView.backgroundColor = [YCTool colorOfHex:0xf6fafc];
}

// 好友信息、群信息
//- (void)setupRightBtn {
//    BOOL isUser = [_receiver isC2CType];
//    UIImage *person = [UIImage imageNamed:@"person"];
//    person = [person imageWithTintColor:[UIColor blackColor]];
//    UIImage *group = [UIImage imageNamed:@"group"];
//    group = [group imageWithTintColor:[UIColor blackColor]];
//
////    UIImage *norimage =  isUser ? [UIImage imageNamed:@"person"] :  [UIImage imageNamed:@"group"];
//    UIImage *norimage =  isUser ? person :  group;
////    UIImage *higimage =  isUser ? [UIImage imageNamed:@"person_hover"] :  [UIImage imageNamed:@"group_hover"];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, norimage.size.width, norimage.size.height)];
//    [btn setImage:norimage forState:UIControlStateNormal];
////    [btn setImage:higimage forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(onClickChatSetting) forControlEvents:UIControlEventTouchUpInside];
//
//    CGRect frame = btn.frame;
//    frame.origin.x = [UIScreen mainScreen].bounds.size.width - frame.size.width - 8;
//    frame.origin.y = 30;
//    btn.frame = frame;
//    [self.navi addSubview:btn];
//}

// 跳转到会议界面
- (void)setupMeetingBtn {
    UIImage *image = [UIImage imageNamed:@"news_icon_meetting"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickMeetingBtn) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = btn.frame;
    frame.origin.x = [UIScreen mainScreen].bounds.size.width - frame.size.width - 8;
    frame.origin.y = 24;
    btn.frame = frame;
    [self.navi addSubview:btn];
}

- (void)clickMeetingBtn {
//    [CTToast showWithText:@"点击会议室按钮"];
    NSLog(@"点击会议室按钮");
    
    NSString *meetingId = _conversation.receiver;
    __weak typeof(self) weakself = self;
    
    [[YCMeetingBiz new] meetingEntranceWithMeetingID:meetingId Success:^(int state, NSString *password, NSString *message, NSString *AccessKey, NSString *SecretKey, NSString *BucketName, NSString *q) {
        
        // 状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束
        if (state == 1 || state == 3) {
            [weakself goToVideoMeetingWithRoomID:nil meetingID:meetingId state:state AccessKey:AccessKey SecretKey:SecretKey BucketName:BucketName q:q];
        } else {
            [CTToast showWithText:message];
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark -


//如果要使用自己的输入面板，可以重写这个函数
//- (void)addInputPanel
//{
//}

//添加右上角按钮
- (void)addChatSettingItem
{
    //用户在这里自定义右上角按钮，不实现本函数则右上角没有按钮
    BOOL isUser = [_receiver isC2CType];
    
    UIImage *norimage =  isUser ? [UIImage imageNamed:@"person"] :  [UIImage imageNamed:@"group"];
    UIImage *higimage =  isUser ? [UIImage imageNamed:@"person_hover"] :  [UIImage imageNamed:@"group_hover"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, norimage.size.width, norimage.size.height)];
    [btn setImage:norimage forState:UIControlStateNormal];
    [btn setImage:higimage forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onClickChatSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
}

//右上角按钮
- (void)onClickChatSetting
{
    //用户自己实现需要的操作，在demo中，这里是跳转到聊天对象的资料页
    
    //如果是创建群，直接进入聊天界面时，_receiver是临时创建的群，这里需要在ongroupAdd之后，重新获取一次详细群信息
    IMAGroup *group = [[IMAGroup alloc] initWith:_receiver.userId];
    NSInteger index = [[IMAPlatform sharedInstance].contactMgr.groupList indexOfObject:group];
    if (index >= 0 && index < [IMAPlatform sharedInstance].contactMgr.groupList.count)
    {
        _receiver = [[IMAPlatform sharedInstance].contactMgr.groupList objectAtIndex:index];
    }
    
    if ([_receiver isC2CType])
    {
        IMAUser *user = (IMAUser *)_receiver;
        if ([[IMAPlatform sharedInstance].contactMgr isMyFriend:user])
        {
            FriendProfileViewController *vc = [[FriendProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else
        {
            StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
    }
    else if ([_receiver isGroupType])
    {
        IMAGroup *user = (IMAGroup *)_receiver;
        
        if ([user isPublicGroup])
        {
            
            GroupProfileViewController *vc = [[GroupProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else if ([user isChatGroup])
        {
            ChatGroupProfileViewController *vc = [[ChatGroupProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else if ([user isChatRoom])
        {
            ChatRoomProfileViewController *vc = [[ChatRoomProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else
        {
            // do nothing
        }
    }
}


#pragma mark - 会议

//        状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束
- (void)goToVideoMeetingWithRoomID:(NSString *)rid meetingID:(NSString *)mid state:(long)state AccessKey:(NSString *)AccessKey SecretKey:(NSString *)SecretKey BucketName:(NSString *)BucketName q:(NSString *)q {
    if ([YCJCSDKHelper isLoginForVideoCall]) {
        RoomViewController *roomVc = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
        roomVc.roomId = rid;
        roomVc.displayName = [ObjectShareTool sharedInstance].currentUser.username;
        roomVc.meetingID = mid;
        roomVc.meetingState = state;
        roomVc.isReview = state == 3? YES: NO;
        roomVc.AccessKey = AccessKey;
        roomVc.SecretKey = SecretKey;
        roomVc.BucketName = BucketName;
        roomVc.q = q;
        [self.navigationController pushViewController:roomVc animated:YES];
    } else {
        [CTToast showWithText:@"会议功能尚未登录，请稍后再试"];
        [YCJCSDKHelper loginMultiCallWithUserID:[ObjectShareTool sharedInstance].currentUser.uuid];
    }
}

@end
