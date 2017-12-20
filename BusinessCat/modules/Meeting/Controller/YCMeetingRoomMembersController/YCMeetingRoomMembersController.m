//
//  YCMeetingRoomMembersController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//


// 用于会议界面 RoomViewController，显示 成员 tab

#import "YCMeetingRoomMembersController.h"
#import "YCMeetingRoomMembersCell.h"
#import "YCMeetingState.h"
#import "YCMeetingBiz.h"

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
@property (nonatomic,strong) UIView *enableVoiceBtn; // 全部禁音
@property (nonatomic,strong) UIView *enableVideoBtn; // 全部禁频
@property (nonatomic,strong) UIView *changeCompereBtn; // 更换主持
@property (nonatomic,strong) UIView *addUserBtn; // 增加成员
@property (nonatomic,strong) UIView *requestInteractBtn; // 申请互动
@property (nonatomic,strong) UIView *endInteractBtn; // 结束互动




@property (nonatomic,strong) YCMeetingState *meetingState; //会议状态，摄像头是否打开等等
@property (nonatomic,strong) NSArray<YCMeetingUser *> *users; // 保存 meetingState 的成员

@end

@implementation YCMeetingRoomMembersController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    [self setupBar];
//    self.view.backgroundColor = [UIColor redColor];
    
//    if ([self isMeetingCreator]) {
//        [self readStateFile];
//    }
    
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
    UIColor *color = [CTCommonUtil convert16BinaryColor:@"#777777"];
    
    if (self.isMeetingCreator) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:color];
        [bar addSubview:btn];
        [btn addTarget:self action:@selector(clickEnableVideoBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"全员禁频" forState:UIControlStateNormal];
        [btn setTitle:@"全员视频" forState:UIControlStateSelected];
        self.enableVideoBtn = btn;
        
        btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:color];
        [bar addSubview:btn];
        [btn addTarget:self action:@selector(clickEnableVoiceBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"全员禁音" forState:UIControlStateNormal];
        [btn setTitle:@"全员音频" forState:UIControlStateSelected];
        self.enableVoiceBtn = btn;
        
        btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:color];
        [bar addSubview:btn];
        [btn addTarget:self action:@selector(clickChangeCompereBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"更换主持" forState:UIControlStateNormal];
        self.changeCompereBtn = btn;
        
        btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:color];
        [bar addSubview:btn];
        [btn addTarget:self action:@selector(clickAddUserBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"增加成员" forState:UIControlStateNormal];
        self.addUserBtn = btn;
        
    } else {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:color];
        [bar addSubview:btn];
        [btn addTarget:self action:@selector(clickRequestBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"请求互动" forState:UIControlStateNormal];
        self.requestInteractBtn = btn;
        
        btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:color];
        [bar addSubview:btn];
        [btn addTarget:self action:@selector(clickEndInteractBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"结束互动" forState:UIControlStateNormal];
        self.endInteractBtn = btn;
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
        self.changeCompereBtn.frame = CGRectMake(0, 0, kMembersBtnWidth, kMembersBtnHeight);
        self.addUserBtn.frame = CGRectMake(0, 0, kMembersBtnWidth, kMembersBtnHeight);
        self.requestInteractBtn.frame = CGRectMake(0, 0, kMembersBtnWidth, kMembersBtnHeight);
        self.endInteractBtn.frame = CGRectMake(0, 0, kMembersBtnWidth, kMembersBtnHeight);
        
        float x = self.view.frame.size.width / 4;
        float centerY = kMembersToolbarHeight / 2;
        float i = 0.5;
        self.enableVoiceBtn.center = CGPointMake(x * i ++, centerY);
        self.enableVideoBtn.center = CGPointMake(x * i ++, centerY);
        self.changeCompereBtn.center = CGPointMake(x * i ++, centerY);
        self.addUserBtn.center = CGPointMake(x * i ++, centerY);
        
        self.requestInteractBtn.center = CGPointMake(x * 0.5, centerY);
        self.endInteractBtn.center = CGPointMake(x * 1.5, centerY);
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingUser *user = self.users[indexPath.row];
    YCMeetingRoomMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCMeetingRoomMembersCell" forIndexPath:indexPath];

    cell.nameLabel.text = user.userName;
    cell.positionLabel.text = user.position;
    [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:user.userIcon] placeholderImage:[UIImage imageNamed:@"work_head"]];

    cell.endBtn.hidden = YES; // 结束互动按钮
    cell.allowBtn.hidden = YES; // 允许互动按钮
    cell.stateLabel.hidden = YES; // 开会中、未进入、已离开
    cell.requestingLabel.hidden = YES; // 申请互动中
    cell.interactingLabel.hidden = YES; // 互动中

    // 如果是会议主持人
    if (self.isMeetingCreator) {
        // 已进入会议
        if (user.state == 1) {
            // 交互按钮
            if (user.interactionState) { // 允许互动
                cell.endBtn.hidden = NO; // 显示 结束互动按钮
            } else {
                cell.allowBtn.hidden = NO;
            }
        } else {
            [cell setUserState:user.state];
            cell.stateLabel.hidden = NO;
        }
        
        if (indexPath.row == 0) {
            cell.endBtn.hidden = YES; // 结束互动按钮
            cell.allowBtn.hidden = YES; // 允许互动按钮
            cell.stateLabel.hidden = YES; // 开会中、未进入、已离开
            cell.requestingLabel.hidden = YES; // 申请互动中
            cell.interactingLabel.hidden = YES; // 互动中
        }

    } else { // 不是主持人
        
        // 已进入会议
        if (user.state == 1) {
            // 交互按钮
            if (user.interactionState == 1) { // 允许互动
                cell.interactingLabel.hidden = NO;
            } else if (user.interactionState == 2) { // 申请互动中
                cell.requestingLabel.hidden = NO;
            } else {
                [cell setUserState:user.state];
                cell.stateLabel.hidden = NO;
            }
        } else {
            [cell setUserState:user.state];
            cell.stateLabel.hidden = NO;
        }
        
    }

    return cell;
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
    // 主持人是否进入会议。否则提示稍后申请
    if ([self isCompereExist]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"是否申请互动？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requeestInteraction];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:sure];
        [ac addAction:cancel];
        [self presentViewController:ac animated:YES completion:nil];
    } else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"主持人未进入会议，请稍后申请" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:nil];
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:sure];
//        [ac addAction:cancel];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (void)clickEndInteractBtn {
    [self updateUserInteractingState:0 withUserID:[ObjectShareTool currentUserID]];
}

- (void)clickEnableVoiceBtn {
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:@"all" soundState:@"0" videoState:nil interactionState:nil compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
        [weakself sendUpdateStatesCommandWithUserID:[ObjectShareTool currentUserID]];
    } fail:^(NSError *error) {
        [CTToast showWithText:@"全员禁音失败"];
    }];
}

- (void)clickEnableVideoBtn {
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:@"all" soundState:nil videoState:@"0" interactionState:nil compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
        [weakself sendUpdateStatesCommandWithUserID:[ObjectShareTool currentUserID]];
    } fail:^(NSError *error) {
        [CTToast showWithText:@"全员禁频失败"];
    }];
}

- (void)clickChangeCompereBtn {
    [CTToast showWithText:@"未选择主持人"];
}

- (void)clickAddUserBtn {
    
}


- (BOOL)isCompereExist {
    BOOL exist = NO;
    NSArray *users = [[JCEngineManager sharedManager]getRoomInfo].participants;
    for (JCParticipantModel *model in users) {
        if ([model.userId isEqualToString:self.meetingCreatorID]) {
            return YES;
        }
    }
    return exist;
}

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

- (void)sendRequestInteractionCommand {
    NSString *userID = [ObjectShareTool currentUserID];
    NSString *content = [NSString stringWithFormat:@"%@,%@", self.meetingID, userID];
    BOOL success = [[JCEngineManager sharedManager] sendData:kYCRequestInteractionKey content:content toReceiver:self.meetingCreatorID];
    if (success == JCOK) {
        [self updateUserInteractingState:2 withUserID:userID];
    } else {
        [CTToast showWithText:@"发送互动申请失败"];
    }
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
        [weakself.tableView reloadData];
        [weakself updateAbility];
    } fail:^(NSError *error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
}

- (void)updateUserInteractingState:(long)interactState withUserID:(NSString *)userID {
    NSString *state = [NSString stringWithFormat:@"%ld", interactState];
    __weak typeof(self) weakself = self;
    
    [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:userID soundState:nil videoState:nil interactionState:state compereState:nil userState:nil userAdd:nil userDel:nil success:^(YCMeetingState *state) {
        weakself.meetingState = state;
        weakself.users = weakself.meetingState.meetingUserList;
        [weakself.tableView reloadData];
        [weakself sendUpdateStatesCommandWithUserID:userID];
    } fail:^(NSError *error) {
        [CTToast showWithText:[NSString stringWithFormat:@"修改互动状态失败 : %@", error]];
    }];
}

// 更新服务器并且群发命令
- (void)onUserLeft:(NSString *)userID {
    __weak typeof(self) weakself = self;
    NSString *state = @"0";
    NSString *firstID = [[JCEngineManager sharedManager] getRoomInfo].participants.firstObject.userId;
    
    if ([firstID isEqualToString:[ObjectShareTool currentUserID]]) {
        [[YCMeetingBiz new] meetingUserWithMeetingID:self.meetingID userId:userID soundState:state videoState:state interactionState:state compereState:nil userState:@"2" userAdd:nil userDel:nil success:^(YCMeetingState *state) {
            weakself.meetingState = state;
            weakself.users = weakself.meetingState.meetingUserList;
            [weakself.tableView reloadData];
            [weakself sendUpdateStatesCommandWithUserID:userID];
        } fail:^(NSError *error) {
            [CTToast showWithText:[NSString stringWithFormat:@"修改互动状态失败 : %@", error]];
        }];

    }
}

- (void)updateAbility {
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
        self.onStateChangeBlock(user.interactionState);
    }
}

@end
