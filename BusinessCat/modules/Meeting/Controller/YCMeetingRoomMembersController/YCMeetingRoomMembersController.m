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
#import "YCJCSDKHelper.h"


#define kMembersToolbarHeight 44
#define kMembersToolbarWidth  [UIScreen mainScreen].bounds.size.width
#define kMembersPanBtnWidth 30

@interface YCMeetingRoomMembersController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<NSNumber *> *interactionStates; //  交互状态，是否允许交互。 @YES
@property (nonatomic,strong) UIView *toolBar; // 底部工具栏
@property (nonatomic,strong) UIButton *panBtn; // 画笔按钮，申请涂鸦

@end

@implementation YCMeetingRoomMembersController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    [self setupBar];
//    self.view.backgroundColor = [UIColor redColor];
    
    NSUInteger count = self.users.count;
    self.interactionStates = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        [self.interactionStates addObject:@NO];
    }
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.panBtn = btn;
    [bar addSubview:btn];
    [btn addTarget:self action:@selector(clickPanBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"icon_no_pan_normal"] forState:UIControlStateNormal];
    UIImage *image = [[UIImage imageNamed:@"icon_pan_highlight"] imageWithColor:[UIColor blackColor]];
    [btn setImage:image forState:UIControlStateSelected];
    btn.selected = YES;
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
        
        self.panBtn.frame = CGRectMake(15, (kMembersToolbarHeight - kMembersPanBtnWidth)/2, kMembersPanBtnWidth, kMembersPanBtnWidth);
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

    if (self.isMeetingCreator) {
        // 交互按钮
        if (self.interactionStates[indexPath.row].intValue == YES) { // 允许互动
            cell.endBtn.hidden = NO; // 显示 结束互动按钮
            cell.allowBtn.hidden = YES; // 隐藏 允许互动按钮
        } else {
            cell.endBtn.hidden =  YES;
            cell.allowBtn.hidden = NO;
        }
        
        if (indexPath.row == 0) {
            cell.endBtn.hidden =  YES;
            cell.allowBtn.hidden = YES;
        }
    } else {
        cell.endBtn.hidden =  YES;
        cell.allowBtn.hidden = YES;
    }
    
    return cell;
}


#pragma mark - Action

- (void)handleCellAllowNotification:(NSNotification *)noti {
    YCMeetingRoomMembersCell *cell = (YCMeetingRoomMembersCell *)noti.object;
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    // 允许互动
    cell.allowBtn.hidden = YES;
    cell.endBtn.hidden = NO;
    [self.interactionStates replaceObjectAtIndex:ip.row withObject:@YES];
    
    
    [[JCEngineManager sharedManager] sendData:kJCCommandType content:kYCAllowInteraction toReceiver:self.users[ip.row].userid];
}

- (void)handleCellEndNotification:(NSNotification *)noti {
    YCMeetingRoomMembersCell *cell = (YCMeetingRoomMembersCell *)noti.object;
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    // 允许互动
    cell.allowBtn.hidden = NO;
    cell.endBtn.hidden = YES;
    [self.interactionStates replaceObjectAtIndex:ip.row withObject:@NO];
    
    [[JCEngineManager sharedManager] sendData:kJCCommandType content:kYCEndInteraction toReceiver:self.users[ip.row].userid];

}

- (void)clickPanBtn {
    // 主持人是否进入会议。否则提示稍后申请
    if ([self canSendRequest]) {
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

- (BOOL)canSendRequest {
    return YES;
//    return NO;
}

- (void)requeestInteraction {
    if (!self.meetingCreatorID) {
        [CTToast showWithText:@"申请互动失败：主持人 ID 为空"];
        return;
    }
    
    [[JCEngineManager sharedManager] sendData:kJCCommandType content:kYCRequestInteraction toReceiver:self.meetingCreatorID];

}

@end
