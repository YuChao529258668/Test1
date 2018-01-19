//
//  YCMeetingRoomMembersController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//


// 用于会议界面 RoomViewController，显示 成员 tab

#import "YCMeetingRoomMembersController.h"
#import "CGSelectContactsViewController.h"
#import "YCCompereCommandController.h"
#import "YCMeetingRoomMembersCell.h"
#import "YCMeetingState.h"
#import "YCMeetingBiz.h"
#import "YCJusTalkIMTool.h"

#define kMembersToolbarHeight 44
#define kMembersToolbarWidth  [UIScreen mainScreen].bounds.size.width
#define kMembersBtnWidth 78
#define kMembersBtnHeight 29

#pragma mark - 命令

// - (int)sendData:(NSString *)key content:(NSString *)content toReceiver:(NSString *)userId;
// - (void)onDataReceive:(NSString *)key content:(NSString *)content fromSender:(NSString *)userId;

// 命令 key
//NSString * const kJCCommandType = @"JC_Command_Type";

// 申请互动
NSString * const kYCRequestInteractionKey = @"YC_Request_Interacton";
// 允许互动。发送命令后要发送 kYCUpdateStatesKey 命令
NSString * const kYCAllowInteractionKey = @"YC_Allow_Interaction";
// 结束互动。发送命令后要发送 kYCUpdateStatesKey 命令
NSString * const kYCEndInteractionKey = @"YC_End_Interaction";
// 查询状态。加入成功或者有人加入会议时调用。然后收到命令时要发送 kYCUpdateStatesKey 命令
NSString * const kYCQueryStateKey = @"YC_Query_State";
// 更新状态。返回所有人的互动状态
NSString * const kYCUpdateStatesKey = @"YC_Update_States";

//请求发言
NSString * const kYCRequestSpeak = @"YC_REQUEST_SPEAK";
NSString * const kYCAgreeSpeak = @"YC_AGREE_SPEAK";
NSString * const kYCDisagreeSpeak = @"YC_DISAGREE_SPEAK";

//请求涂鸦
NSString * const kYCRequestDoodle = @"YC_REQUEST_DOODLE";
NSString * const kYCAgreeDoodle = @"YC_AGREE_DOODLE";
NSString * const kYCDisagreeDoodle = @"YC_DISAGREE_DOODLE";


@interface YCMeetingRoomMembersController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) NSMutableArray<NSNumber *> *interactionStates; //  交互状态，是否允许交互。 @YES
@property (nonatomic,strong) UIView *toolBar; // 底部工具栏
@property (nonatomic,strong) UIButton *enableVoiceBtn; // 全部禁音
@property (nonatomic,strong) UIButton *enableVideoBtn; // 全部禁频
@property (nonatomic,strong) UIButton *changeCompereBtn; // 更换主持
@property (nonatomic,strong) UIButton *addUserBtn; // 增加成员
@property (nonatomic,strong) UIButton *requestInteractBtn; // 申请互动
@property (nonatomic,strong) UIButton *endInteractBtn; // 结束互动

@property (nonatomic,strong) NSMutableArray<UITableViewRowAction *> *rowActions;



@property (nonatomic,strong) YCMeetingState *meetingState; //会议状态，摄像头是否打开等等
@property (nonatomic,strong) NSArray<YCMeetingUser *> *users; // 保存 meetingState 的成员

@end

@implementation YCMeetingRoomMembersController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupRowActions];
    [self setupTableView];
    [self setupBar];
//    self.view.backgroundColor = [UIColor redColor];
    
//    if ([self isMeetingCreator]) {
//        [self readStateFile];
//    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self configBtns:self.isReview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableView {
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = [YCMeetingRoomMembersCell cellHeight];
    [self.tableView registerNib:[UINib nibWithNibName:@"YCMeetingRoomMembersCell" bundle:nil] forCellReuseIdentifier:@"YCMeetingRoomMembersCell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMeetingUser)];
    [self.tableView.mj_header beginRefreshing];

    // 点击事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCellAllowNotification:) name:[YCMeetingRoomMembersCell allowNotificationName] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCellEndNotification:) name:[YCMeetingRoomMembersCell endNotificationName] object:nil];
}

- (void)setupRowActions {
    NSMutableArray *rowActions = [NSMutableArray array];
    self.rowActions = rowActions;
    
    __weak typeof(self) weakself = self;

    // 修改成员
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"       " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        self.tableView.editing = NO;
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"是否删除成员？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *userID = weakself.users[indexPath.row].userid;
            [[YCMeetingBiz new] meetingUserWithMeetingID:weakself.meetingID userId:nil soundState:nil videoState:nil interactionState:nil compereState:nil userState:nil userAdd:nil userDel:userID success:^(YCMeetingState *state) {
                weakself.meetingState = state;
                weakself.users = state.meetingUserList;
                [weakself.tableView reloadData];
                [weakself sendUpdateStatesCommandWithUserID:userID];
                if (weakself.onMembersChangeBlock) {
                    weakself.onMembersChangeBlock(state.meetingUserList);
                }
            } fail:^(NSError *error) {
                [CTToast showWithText:[NSString stringWithFormat:@"删除成员失败 : %@", error]];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:sure];
        [ac addAction:cancel];
        [weakself presentViewController:ac animated:YES completion:nil];
    }];
    UIImage *dimage = [YCMeetingRoomMembersCell deleteUserImage];
    delete.backgroundColor = [UIColor colorWithPatternImage:dimage];
    
    // 更改主持人
    UITableViewRowAction *change = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"       " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        self.tableView.editing = NO;
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"是否设置该成员为主持人？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            __weak typeof(self) weakself = self;
            NSString *userID = weakself.users[indexPath.row].userid;

            [[YCMeetingBiz new] meetingUserWithMeetingID:weakself.meetingID userId:nil soundState:nil videoState:nil interactionState:nil compereState:userID userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
                weakself.meetingState = state;
                weakself.users = state.meetingUserList;
                [weakself sendUpdateStatesCommandWithUserID:userID];
                [weakself updateIsMeetingCreatorAndCompereID];
                [weakself.tableView reloadData];
            } fail:^(NSError *error) {
                [CTToast showWithText:[NSString stringWithFormat:@"更改主持人失败 : %@", error]];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:sure];
        [ac addAction:cancel];
        [weakself presentViewController:ac animated:YES completion:nil];
    }];
    UIImage *cimage = [YCMeetingRoomMembersCell changeCompereImage];
    change.backgroundColor = [UIColor colorWithPatternImage:cimage];
    
    [rowActions addObject:delete];
    [rowActions addObject:change];
}

- (void)setupBar {
    UIView *bar = [UIView new];
    self.toolBar = bar;
    [self.view addSubview:bar];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"work_line_1"]];
    iv.backgroundColor = [UIColor redColor];
    iv.contentMode = UIViewContentModeScaleToFill;
    iv.tag = 999;
    [bar addSubview:iv];
    
    UIFont *font = [UIFont systemFontOfSize:13];
    UIColor *color = [CTCommonUtil convert16BinaryColor:@"#dddddd"]; // 灰色
    
    if (self.isMeetingCreator) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = font;
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:color];
        [bar addSubview:btn];
        [btn addTarget:self action:@selector(clickEnableVideoBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"全员禁频" forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"video_vi_normal"] forState:UIControlStateSelected];
//        [btn setImage:[UIImage imageNamed:@"video_vi_highlight"] forState:UIControlStateNormal];
        [btn setTitle:@"全员视频" forState:UIControlStateSelected];
        btn.layer.cornerRadius = 4;
        btn.clipsToBounds = YES;
        self.enableVideoBtn = btn;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = font;
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:color];
        [bar addSubview:btn];
        [btn addTarget:self action:@selector(clickEnableVoiceBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"全员禁音" forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"video_sound_normal"] forState:UIControlStateSelected];
//        [btn setImage:[UIImage imageNamed:@"video_sound_highlight"] forState:UIControlStateNormal];
        [btn setTitle:@"全员音频" forState:UIControlStateSelected];
        btn.layer.cornerRadius = 4;
        btn.clipsToBounds = YES;
        self.enableVoiceBtn = btn;
        
//        btn = [UIButton buttonWithType:UIButtonTypeCustom];
////        btn.titleLabel.font = font;
////        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        [btn setBackgroundColor:color];
//        [bar addSubview:btn];
//        [btn addTarget:self action:@selector(clickChangeCompereBtn) forControlEvents:UIControlEventTouchUpInside];
////        [btn setTitle:@"更换主持" forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"video_pr"] forState:UIControlStateNormal];
//        self.changeCompereBtn = btn;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.titleLabel.font = font;
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setBackgroundColor:color];
        [bar addSubview:btn];
        [btn addTarget:self action:@selector(clickAddUserBtn) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:@"增加成员" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"video_add"] forState:UIControlStateNormal];
        self.addUserBtn = btn;
        
    } else {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:CTThemeMainColor];
        [bar addSubview:btn];
        [btn addTarget:self action:@selector(clickRequestBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"请求互动" forState:UIControlStateNormal];
        [btn setTitle:@"结束互动" forState:UIControlStateSelected];
        [btn setTitle:@"正在申请" forState:UIControlStateDisabled];
        btn.layer.cornerRadius = 4;
        btn.clipsToBounds = YES;
        self.requestInteractBtn = btn;
        
//        btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.titleLabel.font = font;
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setBackgroundColor:color];
//        [bar addSubview:btn];
//        [btn addTarget:self action:@selector(clickEndInteractBtn) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:@"结束互动" forState:UIControlStateNormal];
//        self.endInteractBtn = btn;
    }
    
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        frame.size.height = frame.size.height - kMembersToolbarHeight;
        self.tableView.frame = frame;
    }
    
    {
        CGRect frame = self.view.frame;
        float y = frame.size.height - kMembersToolbarHeight;
        self.toolBar.frame = CGRectMake(0, y, kMembersToolbarWidth, kMembersToolbarHeight);
        
        UIImageView *iv = [self.toolBar viewWithTag:999];
        iv.frame = CGRectMake(0, 0, kMembersToolbarWidth, 1);
        
        self.enableVoiceBtn.frame = CGRectMake(0, 0, kMembersBtnWidth, kMembersBtnHeight);
        self.enableVideoBtn.frame = CGRectMake(0, 0, kMembersBtnWidth, kMembersBtnHeight);
//        self.changeCompereBtn.frame = CGRectMake(0, 0, kMembersBtnWidth, kMembersBtnHeight);
        self.addUserBtn.frame = CGRectMake(0, 0, 50, kMembersBtnHeight);
        
        self.requestInteractBtn.frame = CGRectMake(0, 0, 78, kMembersBtnHeight);
//        self.endInteractBtn.frame = CGRectMake(0, 0, kMembersBtnWidth, kMembersBtnHeight);
        
//        float x = self.view.frame.size.width / 4;
//        float x = kMembersBtnWidth / 2 + 15;
        float centerY = kMembersToolbarHeight / 2;
//        float i = 1;
        self.enableVoiceBtn.center = CGPointMake(kMembersBtnWidth * 0.5 + 1 * 15, centerY);
        self.enableVideoBtn.center = CGPointMake(kMembersBtnWidth * 1.5 + 2 * 15, centerY);
//        self.changeCompereBtn.center = CGPointMake(x * i ++, centerY);
        self.addUserBtn.center = CGPointMake(kMembersToolbarWidth-50/2-15, centerY);
        
        self.requestInteractBtn.center = CGPointMake(78 * 0.5 + 20, centerY);
//        self.endInteractBtn.center = CGPointMake(x * 1.5, centerY);
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingUser *user = self.users[indexPath.row];
    YCMeetingRoomMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCMeetingRoomMembersCell" forIndexPath:indexPath];

//    cell.positionLabel.text = user.position;
//    [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:user.userIcon] placeholderImage:[UIImage imageNamed:@"work_head"]];
    [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:user.userIcon] placeholderImage:[UIImage imageNamed:@"work_head"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [cell setAvart:image withUserState:user.state];
    }];


    cell.endBtn.hidden = YES; // 结束互动按钮
    cell.allowBtn.hidden = YES; // 允许互动按钮
    cell.stateLabel.hidden = YES; // 开会中、未进入、已离开
    cell.requestingLabel.hidden = YES; // 申请互动中
    cell.interactingLabel.hidden = YES; // 互动中
    cell.compereLabel.hidden = YES; // 主持人
    
    BOOL audioState = [[[JCEngineManager sharedManager] getParticipantWithUserId:user.userid] isAudioUpload];
    [cell updateSpeakingImageWithUserState:user.state audioState:audioState];
    //    cell.nameLabel.text = user.userName;
    NSString *test = [NSString stringWithFormat:@"%@ 互动: %@ 语音: %@ 麦克风: %@", user.userName, @(user.interactionState), @(user.soundState), @(audioState)];
    cell.nameLabel.text = test;

    // 如果是会议主持人
    if (self.isMeetingCreator) {
        // 已进入会议
        if (user.state == 1) {
            if (user.compere) {
                cell.compereLabel.hidden = NO; // 主持人
            } else {
                // 交互按钮
//                if (user.interactionState == 1) { // 允许互动
//                    cell.endBtn.hidden = NO; // 显示 结束互动按钮
//                }  else if (user.interactionState == 2) { // 申请互动中
//                    cell.requestingLabel.hidden = NO; // 申请互动中
//                } else {
//                    cell.allowBtn.hidden = NO;
//                }
                if (user.interactionState == 1) { // 允许互动
                    cell.interactingLabel.hidden = NO;
                } else if (user.interactionState == 2) { // 申请互动中
                    cell.requestingLabel.hidden = NO;
                } else {
                    // 参会中
                    [cell setUserState:user.state];
                    cell.stateLabel.hidden = NO;
                }
            }
        } else {
            // 未进入、已离开
            [cell setUserState:user.state];
            cell.stateLabel.hidden = NO;
        }

    } else { // 不是主持人
        
        // 已进入会议
        if (user.state == 1) {
            // 显示主持人
            if (user.compere) {
                cell.compereLabel.hidden = NO;
            } else {
                if (user.interactionState == 1) { // 允许互动
                    cell.interactingLabel.hidden = NO;
                } else if (user.interactionState == 2) { // 申请互动中
                    cell.requestingLabel.hidden = NO;
                } else {
                    // 参会中
                    [cell setUserState:user.state];
                    cell.stateLabel.hidden = NO;
                }
            }
        } else {
            // 未进入、已离开
            [cell setUserState:user.state];
            cell.stateLabel.hidden = NO;
        }
        
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isReview) {
        return;
    }
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        return;
    }
    
    if (!self.isMeetingCreator) {
        return;
    }
    
    __weak typeof(self) weakself = self;
    YCCompereCommandController *vc = [YCCompereCommandController controllerWithMeetingState:self.meetingState user:self.users[row]];
    vc.completeBlock = ^{
        [weakself getMeetingUser];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowActions;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // 能否侧滑
    if (self.isMeetingCreator) {
        if (indexPath.row == 0) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}


#pragma mark - Action

// 允许互动
- (void)handleCellAllowNotification:(NSNotification *)noti {
    YCMeetingRoomMembersCell *cell = (YCMeetingRoomMembersCell *)noti.object;
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    YCMeetingUser *user = self.users[ip.row];
    [self updateUserInteractingState:1 withUserID:user.userid];
}

// 结束互动
- (void)handleCellEndNotification:(NSNotification *)noti {
    YCMeetingRoomMembersCell *cell = (YCMeetingRoomMembersCell *)noti.object;
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    YCMeetingUser *user = self.users[ip.row];
    [self updateUserInteractingState:0 withUserID:user.userid];
}

// 点击底部申请互动
- (void)clickRequestBtn {
    // 结束互动
    if (self.requestInteractBtn.isSelected) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"是否结束互动？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updateUserInteractingState:0 withUserID:[ObjectShareTool currentUserID]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:sure];
        [ac addAction:cancel];
        [self presentViewController:ac animated:YES completion:nil];
    } else {
        // 申请互动
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"是否申请互动？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requeestInteraction];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:sure];
        [ac addAction:cancel];
        [self presentViewController:ac animated:YES completion:nil];
    }
//    self.requestInteractBtn.selected = !self.requestInteractBtn.isSelected;
}

- (void)clickEndInteractBtn {
    [self updateUserInteractingState:0 withUserID:[ObjectShareTool currentUserID]];
}

// 全员禁止按钮
- (void)clickEnableVoiceBtn {
    NSString *message = self.enableVoiceBtn.isSelected? @"取消 全员禁音？": @"开启 全员禁音？";
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        NSString *soundState = @"1";
        NSString *failStr = @"取消全员禁音失败";
        UIColor *color = [CTCommonUtil convert16BinaryColor:@"#dddddd"];
        BOOL selected = !self.enableVoiceBtn.isSelected;
        if (selected) {
            soundState = @"0";
            color = CTThemeMainColor;
            failStr = @"全员禁音失败";
        }
        
        __weak typeof(self) weakself = self;
        [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:@"all" soundState:soundState videoState:nil interactionState:nil compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
            [weakself sendUpdateStatesCommandWithUserID:[ObjectShareTool currentUserID]];
            weakself.enableVoiceBtn.selected = selected;
            weakself.enableVoiceBtn.backgroundColor = color;
        } fail:^(NSError *error) {
            [CTToast showWithText: failStr];
        }];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)clickEnableVideoBtn {
    NSString *message = self.enableVideoBtn.isSelected? @"取消 全员禁频？": @"开启 全员禁频？";
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        NSString *videoState = @"1";
        NSString *failStr = @"取消全员禁频失败";
        UIColor *color = [CTCommonUtil convert16BinaryColor:@"#dddddd"];
        BOOL selected = !self.enableVideoBtn.isSelected;
        if (selected) {
            videoState = @"0";
            color = CTThemeMainColor;
            failStr = @"全员禁频失败";
        }
        
        __weak typeof(self) weakself = self;
        [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:@"all" soundState:nil videoState:videoState interactionState:nil compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
            [weakself sendUpdateStatesCommandWithUserID:[ObjectShareTool currentUserID]];
            weakself.enableVideoBtn.selected = selected;
            weakself.enableVideoBtn.backgroundColor = color;
        } fail:^(NSError *error) {
            [CTToast showWithText:failStr];
        }];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];

}

- (void)clickChangeCompereBtn {
    [CTToast showWithText:@"未选择主持人"];
}

- (void)clickAddUserBtn {
    CGSelectContactsViewController *vc = [[CGSelectContactsViewController alloc]init];
    vc.titleForBar = @"选择人员";
    vc.maxSelectCount = 50;
    vc.contacts = [self convertYCMeetingUsersToCGUserCompanyContactsEntitys:self.users];
    vc.completeBtnClickBlock = ^(NSMutableArray<CGUserCompanyContactsEntity *> *contacts) {
        NSArray *users = [self convertCGUserCompanyContactsEntitysToYCMeetingUsers:contacts];
        [self onAddUserFinish:users];
    };
//    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)onAddUserFinish:(NSArray<YCMeetingUser *> *)users {
    NSMutableArray<NSString *> *oldUsers = [NSMutableArray arrayWithCapacity:self.users.count];// 旧的
    NSMutableArray<NSString *> *newUsers = [NSMutableArray arrayWithCapacity:users.count];// 新的
    NSMutableArray<NSString *> *userAdd = [NSMutableArray array];// 新增的
    NSMutableArray<NSString *> *userDel = [NSMutableArray array];// 删掉的
    NSString *userAddString;// 逗号连接所有 id
    NSString *userDelString;// 逗号连接所有 id

    for (YCMeetingUser *user in self.users) {
        [oldUsers addObject:user.userid];
    }
    
    for (YCMeetingUser *user in users) {
        [newUsers addObject:user.userid];
    }
    
    // 新集合没有的就是被删掉的
    for (NSString *uid in oldUsers) {
        if (![newUsers containsObject:uid]) {
            [userDel addObject:uid];
        }
    }
    [userDel removeObject:[ObjectShareTool currentUserID]];

    // 旧集合没有的就是增加的
    for (NSString *uid in newUsers) {
        if (![oldUsers containsObject:uid]) {
            [userAdd addObject:uid];
        }
    }
    
//    userAdd = userAdd.count == 0? nil: userAdd;
//    userDel = userDel.count == 0? nil: userDel;
//    if (!userAdd && !userDel) {
//        return;
//    }
    
    if (userAdd.count) {
        userAddString = [userAdd componentsJoinedByString:@","];
    }
    if (userDel.count) {
        userDelString = [userDel componentsJoinedByString:@","];
    }
    
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:nil soundState:nil videoState:nil interactionState:nil compereState:nil userState:nil userAdd:userAddString userDel:userDelString success:^(YCMeetingState *state) {
        weakself.meetingState = state;
        weakself.users = state.meetingUserList;
        [weakself.tableView reloadData];
        if (weakself.onMembersChangeBlock) {
            weakself.onMembersChangeBlock(state.meetingUserList);
        }
        [[YCJusTalkIMTool new] sendMeetingInviteTo:userAdd withMeetingID:weakself.meetingID  avatarUrl:state.ycCompere.userIcon userName:state.ycCompere.userName groupID:state.groupId meetingState:state.meetingState roomID:state.conferenceNumber q:weakself.q];
    } fail:^(NSError *error) {
        [CTToast showWithText:[NSString stringWithFormat:@"修改成员失败 : %@", error]];
    }];
    
}

- (NSArray *)convertCGUserCompanyContactsEntitysToYCMeetingUsers:(NSArray<CGUserCompanyContactsEntity *> *)array {
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:array.count];
    
    for (CGUserCompanyContactsEntity *contact in array) {
        YCMeetingUser *muser = [YCMeetingUser new];
        muser.userName = contact.userName;
        muser.userid = contact.userId;
        muser.userIcon = contact.userIcon;
        muser.position = contact.position;
        [users addObject:muser];
    }
    return users;
}

- (NSMutableArray *)convertYCMeetingUsersToCGUserCompanyContactsEntitys:(NSArray<YCMeetingUser *> *)users {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:users.count];
    
    for (YCMeetingUser *user in users) {
        CGUserCompanyContactsEntity *contact = [CGUserCompanyContactsEntity new];
        contact.userName = user.userName;
        contact.userId = user.userid;
        contact.userIcon = user.userIcon;
        contact.position = user.position;
        [array addObject:contact];
    }
    return array;
}


//- (BOOL)isCompereExist {
//    BOOL exist = NO;
//    NSArray *users = [[JCEngineManager sharedManager]getRoomInfo].participants;
//    for (JCParticipantModel *model in users) {
//        if ([model.userId isEqualToString:self.meetingCreatorID]) {
//            return YES;
//        }
//    }
//    return exist;
//}

- (void)requeestInteraction {
    if (!self.meetingCreatorID) {
        [CTToast showWithText:@"申请互动失败：主持人 ID 为空"];
        return;
    }
    
    [self sendRequestInteractionCommand];
}

#pragma mark - Command

// 解析并更新所有人状态
//- (void)updateStates:(NSString *)stateStr {
////    [self.tableView reloadData];
//    NSDictionary *dic = [self dictionaryWithJsonString:stateStr];
//    NSLog(@"会议状态 = %@", dic);
//    NSUInteger count = self.users.count;
//    self.interactionStates = [NSMutableArray arrayWithCapacity:count];
//    [self.users enumerateObjectsUsingBlock:^(YCMeetingUser * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.interactionStates addObject: dic[user.userid]];
//    }];
//}

- (void)sendUpdateStatesCommandWithUserID:(NSString *)userID {
    NSString *content = [NSString stringWithFormat:@"%@,%@", self.meetingID, userID];
    [[JCEngineManager sharedManager] sendData:kYCUpdateStatesKey content:content toReceiver:nil];
}

+ (void)sendUpdateStatesCommandWithMeetingID:(NSString *)mid {
    NSString *content = [NSString stringWithFormat:@"%@", mid];
    [[JCEngineManager sharedManager] sendData:kYCUpdateStatesKey content:content toReceiver:nil];
}

- (void)sendRequestInteractionCommand {
    NSString *userID = [ObjectShareTool currentUserID];
    
//    NSString *content = [NSString stringWithFormat:@"%@,%@", self.meetingID, userID];
//    BOOL success = [[JCEngineManager sharedManager] sendData:kYCUpdateStatesKey content:content toReceiver:nil];
//    if (success == JCOK) {
//        [self updateUserInteractingState:2 withUserID:userID];
//    } else {
//        [CTToast showWithText:@"发送互动申请失败"];
//    }
    
    [self updateUserInteractingState:2 withUserID:userID];

}

//- (void)sendAllowInteractionCommand {
//    [[JCEngineManager sharedManager] sendData:kYCAllowInteractionKey content:self.meetingID toReceiver:self.meetingCreatorID];
//    [self sendUpdateStatesCommand];
//}
//
//- (void)sendEndInteractionCommand {
//    [[JCEngineManager sharedManager] sendData:kYCEndInteractionKey content:self.meetingID toReceiver:self.meetingCreatorID];
//    [self sendUpdateStatesCommand];
//}
//
//- (void)sendQueryInteractionStateCommand {
//    [[JCEngineManager sharedManager] sendData:kYCQueryStateKey content:self.meetingID toReceiver:self.meetingCreatorID];
//}


//#pragma mark - Json
//
//- (NSString *)getStateJsonString {
//    NSArray *states = self.interactionStates;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:self.meetingID forKey:@"meetingId"];
//
//    [self.users enumerateObjectsUsingBlock:^(YCMeetingUser * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
//        dic[user.userid] = states[idx];
//    }];
////    NSString *str = [@"" mj_JSONString];
////    str = [@{} mj_JSONString];
//    return [self dictionaryToJson:dic];
//}
//
//- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
//    if (jsonString == nil) {
//        return nil;
//    }
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
//    if(err) {
//        NSLog(@"json解析失败：%@",err);
//        return nil;
//    }
//    return dic;
//}
//
////字典转json格式字符串：
//- (NSString*)dictionaryToJson:(NSDictionary *)dic
//{
//    //NSJSONWritingPrettyPrinted  是有换位符的。
//    NSError *parseError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
//    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return str;
//}

//#pragma mark - 状态缓存
//
//- (void)createStateDirectory {
//    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *dirPath = [cache stringByAppendingPathComponent:@"meetingState"];
//    NSFileManager *manager = [NSFileManager defaultManager];
//    if (![manager fileExistsAtPath:dirPath]) {
//        BOOL fail = [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
//        if (fail) {
//            NSLog(@"会议状态目录创建失败");
//        }
//    }
//}
//
//- (void)readStateFile {
//    [self createStateDirectory];
//
//    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *dirPath = [cache stringByAppendingPathComponent:@"meetingState"];
//    NSString *filePath = [dirPath stringByAppendingPathComponent:self.meetingID];
//
//    NSFileManager *manager = [NSFileManager defaultManager];
//    if (![manager fileExistsAtPath:filePath]) {
//        NSUInteger count = self.users.count;
//        self.interactionStates = [NSMutableArray arrayWithCapacity:count];
//        for (int i = 0; i < count; i ++) {
//            [self.interactionStates addObject:@NO];
//        }
//        return;
//    }
//
//    NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    if (!jsonStr) {
//        NSLog(@"会议状态读取失败");
//        return;
//    }
//    NSDictionary *dic = [self dictionaryWithJsonString:jsonStr];
//    NSUInteger count = self.users.count;
//    self.interactionStates = [NSMutableArray arrayWithCapacity:count];
//
//    [self.users enumerateObjectsUsingBlock:^(YCMeetingUser * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.interactionStates addObject: dic[user.userid]];
//    }];
//
//}
//
//- (void)writeStateFile {
//    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *dirPath = [cache stringByAppendingPathComponent:@"meetingState"];
//    NSString *filePath = [dirPath stringByAppendingPathComponent:self.meetingID];
//
//    NSString *str = [self getStateJsonString];
//    BOOL fail = [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    if (fail) {
//        NSLog(@"会议状态写入失败");
//    }
//}


#pragma mark - Data

- (void)getMeetingUser {
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:nil soundState:nil videoState:nil interactionState:nil compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
        weakself.meetingState = state;
        weakself.users = weakself.meetingState.meetingUserList;
        [weakself.tableView.mj_header endRefreshing];
        
        if (weakself.onGetMeetingDateSuccessBlock) {
            weakself.onGetMeetingDateSuccessBlock(state.ycIsCompere);
        }
        
        if (state.meetingState != 1) { // 1 进行中
            [weakself checkMeetingState]; // 结束或取消会议
        } else {
            [weakself updateAbility];
            [weakself updateIsMeetingCreatorAndCompereID];
            [weakself checkWhetherHasBeenRemove];
            [weakself.tableView reloadData];
            [weakself updateRequestInteractionBtn];
        }
    } fail:^(NSError *error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
}

- (void)updateUserInteractingState:(long)interactState withUserID:(NSString *)userID {
    NSString *state = [NSString stringWithFormat:@"%ld", interactState];
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:userID soundState:state videoState:state interactionState:state compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {

//    [[YCMeetingBiz new] meetingUserWithMeetingID:weakself.meetingID userId:userID soundState:nil videoState:nil interactionState:state compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
        weakself.meetingState = state;
        weakself.users = weakself.meetingState.meetingUserList;
        [weakself.tableView reloadData];
        [weakself sendUpdateStatesCommandWithUserID:userID];
        [weakself updateRequestInteractionBtn];
    } fail:^(NSError *error) {
        [CTToast showWithText:[NSString stringWithFormat:@"修改互动状态失败 : %@", error]];
    }];
}

// 0或1，其他数字表示不修改
- (void)updateUserVoiceState:(long)voiceState videoState:(long)videoState withUserID:(NSString *)userID {
    NSString *voice;
    NSString *video;
    voice = voiceState == 0? @"0":nil;
    voice = voiceState == 1? @"1":nil;
    video = videoState == 0? @"0":nil;
    video = videoState == 1? @"1":nil;
    __weak typeof(self) weakself = self;
    
    [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:userID soundState:voice videoState:video interactionState:nil compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
        weakself.meetingState = state;
        weakself.users = weakself.meetingState.meetingUserList;
        [weakself.tableView reloadData];
        [weakself sendUpdateStatesCommandWithUserID:userID];
    } fail:^(NSError *error) {
        [CTToast showWithText:[NSString stringWithFormat:@"同步视频或音频状态失败 : %@", error]];
    }];
}

// 更新服务器并且群发命令
//- (void)onUserLeft:(NSString *)userID {
//    __weak typeof(self) weakself = self;
//    NSString *state = @"0";
//    NSString *firstID = [[JCEngineManager sharedManager] getRoomInfo].participants.firstObject.userId;
//
//    if ([firstID isEqualToString:[ObjectShareTool currentUserID]]) {
//        [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:userID soundState:state videoState:state interactionState:state compereState:nil userState:@"2" userAdd:nil userDel:nil success:^(YCMeetingState *state) {
//            weakself.meetingState = state;
//            weakself.users = weakself.meetingState.meetingUserList;
//            [weakself.tableView reloadData];
//            [weakself sendUpdateStatesCommandWithUserID:userID];
//        } fail:^(NSError *error) {
//            [CTToast showWithText:[NSString stringWithFormat:@"修改互动状态失败 : %@", error]];
//        }];
//
//    }
//}

- (void)updateAbility {
    // 更新当前用户的会议权限
    if (self.onStateChangeBlock) {
        YCMeetingUser *user = nil;
        
        for (YCMeetingUser *mu in self.users) {
            if ([mu.userid isEqualToString:[ObjectShareTool currentUserID]]) {
                user = mu;
                break;
            }
        }
        
        if ([self isMeetingCreator]) {
            user.interactionState = 1;
        }
        self.onStateChangeBlock(user.interactionState, user.soundState, user.videoState);
    }
    
    // 弹窗允许互动
    if (self.isMeetingCreator) {
        for (YCMeetingUser *user in self.users) {
            if (user.interactionState == 2) {
                [self showRequsetForInteractionWithUserID:user.userid];
            }
        }
    }
    
    [self checkAllVoiceOrVideoDisable];
}

- (void)checkAllVoiceOrVideoDisable {
    // 是否全员禁音或者全员禁频
    if (self.isMeetingCreator) {
        BOOL allVoiceDisable = YES;
        BOOL allVideoDisable = YES;
        for (YCMeetingUser *user in self.users) {
            if ([user.userid isEqualToString:[ObjectShareTool currentUserID]]) {
                continue;
            }
            if (user.soundState) {
                allVoiceDisable = NO;
                break;
            }
        }
        for (YCMeetingUser *user in self.users) {
            if ([user.userid isEqualToString:[ObjectShareTool currentUserID]]) {
                continue;
            }
            if (user.videoState) {
                allVideoDisable = NO;
                break;
            }
        }

        UIColor *color = [YCTool colorOfHex:0xdddddd];
        self.enableVoiceBtn.selected = allVoiceDisable;// normal 是 “禁止”，灰色，处于 非禁止状态
        self.enableVoiceBtn.backgroundColor = allVoiceDisable? CTThemeMainColor: color;
        
        self.enableVideoBtn.selected = allVideoDisable;
        self.enableVideoBtn.backgroundColor = allVideoDisable? CTThemeMainColor: color;

    }
}

- (void)showRequsetForInteractionWithUserID:(NSString *)userID {
    NSString *name = [self getNameWithUserID:userID];
    NSString *message = [NSString stringWithFormat:@"是否允许 %@ 互动？", name];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"允许" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateUserInteractingState:1 withUserID:userID];
    }];
    UIAlertAction *refuse = [UIAlertAction actionWithTitle:@"拒绝" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateUserInteractingState:0 withUserID:userID];
    }];
    
    [ac addAction:sure];
    [ac addAction:refuse];
    [self presentViewController:ac animated:YES completion:nil];
}

- (NSString *)getNameWithUserID:(NSString *)userID {
    NSString *name;
    for (YCMeetingUser *user in self.users) {
        if ([user.userid isEqualToString:userID]) {
            return user.userName;
        }
    }
    return name;
}

- (void)updateIsMeetingCreatorAndCompereID {
    YCMeetingState *state = self.meetingState;
    self.isMeetingCreator = state.ycIsCompere;
    self.meetingCreatorID = state.ycCompereID;
    
    // 更新底部工具栏
    // 如果由成员变成了主持人
    if (state.ycIsCompere && self.requestInteractBtn) {
        [self.requestInteractBtn removeFromSuperview];
        [self.endInteractBtn removeFromSuperview];
        [self.toolBar removeFromSuperview];
        self.requestInteractBtn = nil;
        self.endInteractBtn = nil;
        self.toolBar = nil;
        [self setupBar];
    }
    
    // 如果由主持人变成了成员
    if (!state.ycIsCompere && self.enableVoiceBtn) {
        [self.enableVoiceBtn removeFromSuperview];
        [self.enableVideoBtn removeFromSuperview];
        [self.changeCompereBtn removeFromSuperview];
        [self.addUserBtn removeFromSuperview];
        [self.toolBar removeFromSuperview];
        self.enableVoiceBtn = nil;
        self.enableVideoBtn = nil;
        self.changeCompereBtn = nil;
        self.addUserBtn = nil;
        self.toolBar = nil;
        [self setupBar];
    }
}

- (void)checkWhetherHasBeenRemove {
    BOOL remove = YES;
    
    for (YCMeetingUser *user in self.users) {
        if ([user.userid isEqualToString:[ObjectShareTool currentUserID]]) {
            remove = NO;
            break;
        }
    }
    
    if (remove) {
        if (self.onBeRemoveFromMeetingBlock) {
            self.onBeRemoveFromMeetingBlock();
        }
    }
}

- (void)checkMeetingState {
    if (self.onMeetingStateChangeBlock) {
        self.onMeetingStateChangeBlock(self.meetingState.meetingState);
    }
}

// 更新请求互动按钮
- (void)updateRequestInteractionBtn {
    for (YCMeetingUser *user in self.users) {
        if ([user.userid isEqualToString:[ObjectShareTool currentUserID]]) {
            if (user.interactionState == 0) {
                self.requestInteractBtn.selected = NO;
            } else if (user.interactionState == 1) {
                self.requestInteractBtn.selected = YES;
            } else {
                self.requestInteractBtn.enabled = NO;
            }
            break;
        }
    }

}

#pragma mark -

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (void)setIsReview:(BOOL)isReview {
    _isReview = isReview;
    
    [self configBtns:isReview];
}

- (void)configBtns:(BOOL)isReview {
    BOOL enable = !isReview;
    self.requestInteractBtn.userInteractionEnabled = enable;
    self.enableVideoBtn.userInteractionEnabled = enable;
    self.enableVoiceBtn.userInteractionEnabled = enable;
    self.addUserBtn.userInteractionEnabled = enable;
}

@end
