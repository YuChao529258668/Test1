//
//  YCBookMeetingController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/19.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCBookMeetingController.h"
#import "YCDatePickerViewController.h"
#import "YCSelectMeetingRoomController.h"
#import "YCSelectMeetingTimeController.h"
#import "CGSelectContactsViewController.h"

#import "YCCreateMeetingUserCell.h"

#import "YCMeetingBiz.h"
#import "YCMeetingRoom.h"

//选择会议室后，检查日期是否可用，更新会议费用
//选择日期后，检查日期是否可用，更新会议费用，更新时长
//如果时长不可用，选择有效时长后，更新时长，要修改日期，更新会议费用，
//选择会议类型，更新会议费用

@interface YCBookMeetingController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *meetingTitleTF;
@property (weak, nonatomic) IBOutlet UILabel *createrLabel;
@property (weak, nonatomic) IBOutlet UIButton *meetingRoomBtn;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *meetingTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *meetingCostLabel;
@property (weak, nonatomic) IBOutlet UIButton *meetingTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *meetingJoinerCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *createMeetingBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBeginDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectEndDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *meetingRoomNameL;
@property (weak, nonatomic) IBOutlet UIButton *jianTouBtn;
@property (weak, nonatomic) IBOutlet UIButton *tickBtn; // 打钩


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint; // 表视图底部距离约束
@property (weak, nonatomic) IBOutlet UIButton *modifyMeetingBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelMeetingBtn;

@property (nonatomic,strong) NSDate *beginDate;
@property (nonatomic,strong) NSDate *endDate;
@property (nonatomic,strong) NSArray<YCMeetingRoom *> *companyRooms; // 用户公司的会议室
@property (nonatomic,strong) NSArray<YCMeetingRoom *> *otherRooms; // 生意猫会议室

@property (nonatomic,strong) YCMeetingRoom *room; // 即将创建的 room，保存必要的信息，默认是 后台给的 default room
@property (nonatomic,strong) NSMutableArray<YCMeetingUser *> *users; // 参与开会的人
@property (nonatomic,assign) int meetingType; // 会议类型 0：音频，1：视频
@property (nonatomic,strong) YCMeetingUser *currentMeetingUser; // 自己

@end


@implementation YCBookMeetingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //    self.navigationItem.titleView.tintColor = [UIColor blackColor];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    
    if (self.style == YCBookMeetingControllerStyleCreate) {
        [self configViewForCreateMeeting];
    }
    if (self.style == YCBookMeetingControllerStylePreview) {
        [self configViewForPreviewMeetingDetail];
    }
    if (self.style == YCBookMeetingControllerStyleModify) {
        [self configViewForModifyMeeting];
    }
    
    self.meetingTitleTF.returnKeyType = UIReturnKeyDone;
    self.meetingTitleTF.delegate = self;
    [self setupTableView];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Meeting" bundle:nil];
        self = (YCBookMeetingController *)[sb instantiateViewControllerWithIdentifier:@"YCBookMeetingController"];
        NSDate *now = [NSDate date];
        NSDate *after = [NSDate dateWithTimeInterval:30*60+59 sinceDate:now];
        self.beginDate = now;
        self.endDate = after;
        self.style = YCBookMeetingControllerStyleCreate;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Helper

- (void)updateMeetingDuration {
    NSString *duration = [NSString stringWithFormat:@"%d 分钟", [self calculateMeetingDurationInMinute]] ;
    [self.meetingTimeBtn setTitle:duration forState:UIControlStateNormal];
    [self.meetingTimeBtn.titleLabel setTextColor:[UIColor blackColor]];
}

// 计算时长，单位分钟
- (int)calculateMeetingDurationInMinute {
    int minute = [self.endDate timeIntervalSinceDate:self.beginDate] / 60;
    return minute;
}

// 选择会议室后才能计算费用
- (float)calculateMeetingCostWithMeetingRoom:(YCMeetingRoom *)room countOfUsers:(NSInteger)count {
//        收费会议室：按会议类型+参会人数+时长进行计算费用，显示为：预计最多N元
//        免费/包月会议室时：直接显示为免费

    // 费用(0免费 1付费 2包月)
    if (room.roomcharge == 0 || room.roomcharge == 2) {
        return 0;
    }
    
    // 单价。会议类型 0：音频，1：视频
    float price = (self.meetingType == 0)? room.costvoice: room.costvideo;
    // 时长
    int minutes = [self calculateMeetingDurationInMinute];
    return price * count * minutes; // 价格*人数*时长
}

- (void)updateMeetingCost {
    [self updateMeetingCostWithMeetingRoom:self.room countOfUsers:self.users.count];
}

- (void)updateMeetingCostWithMeetingRoom:(YCMeetingRoom *)room countOfUsers:(NSInteger)count  {
    float cost = [self calculateMeetingCostWithMeetingRoom:room countOfUsers:count];
    self.meetingCostLabel.text = [NSString stringWithFormat:@"预计最多 %@ 元", @(cost)];
    [self.meetingCostLabel setTextColor:[UIColor redColor]];
}

- (void)convertModels:(NSArray<CGUserCompanyContactsEntity *> *)array {
    // CGUserCompanyContactsEntity 转 YCMeetingUser
    self.users = [NSMutableArray arrayWithObject:self.currentMeetingUser];
    
    for (CGUserCompanyContactsEntity *contact in array) {
        if ([contact.userId isEqualToString:self.currentMeetingUser.userid]) {
            continue;
        }
        YCMeetingUser *muser = [YCMeetingUser new];
        muser.userName = contact.userName;
        muser.userid = contact.userId;
        muser.userIcon = contact.userIcon;
        muser.position = contact.position;
        [self.users addObject:muser];
    }
}

- (void)setupCurrentMeetingUser {
    YCMeetingUser *muser = [YCMeetingUser new];
    CGUserEntity *user = [ObjectShareTool sharedInstance].currentUser;
    muser.userName = user.nickname;
    muser.userid = user.uuid;
    muser.userIcon = user.portrait;
    muser.position = [user defaultPosition];
    self.currentMeetingUser = muser;
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = [YCCreateMeetingUserCell cellHeight];
    [self.tableView registerNib:[UINib nibWithNibName:@"YCCreateMeetingUserCell" bundle:nil] forCellReuseIdentifier:@"YCCreateMeetingUserCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCellReduceBtnClick:) name:[YCCreateMeetingUserCell reducceNotificationName] object:nil];
}

#pragma mark - Config

// 配置创建会议预约
- (void)configViewForCreateMeeting {
    self.title = @"预约会议";
    self.modifyMeetingBtn.hidden = YES;
    self.cancelMeetingBtn.hidden = YES;
    self.tickBtn.hidden = YES;
    [self.createMeetingBtn setBackgroundColor:CTThemeMainColor];
    
    [self setupCurrentMeetingUser];
    self.users = [NSMutableArray arrayWithObject:self.currentMeetingUser];
    
    [self setDefaultMeetingCreater];
    [self updateMeetingDate];
    
    // 时长
    [self updateMeetingDuration];

    // 类型。会议类型 0：音频，1：视频
    self.meetingType = 0;
    [self.meetingTypeBtn setTitle:@"音频" forState:UIControlStateNormal];
    
    
    // 获取会议室列表
    [self getMeetingRoomListWithSuccess:^(NSArray *companyRooms, NSArray *otherRooms) {
        self.companyRooms = companyRooms;
        self.otherRooms = otherRooms;
        // 设置默认会议室
        self.room = [self getDefaultMeetingRoom];
        self.meetingRoomNameL.text = self.room.roomname;
        // 费用
        [self updateMeetingCostWithMeetingRoom:self.room countOfUsers:self.users.count];
        // 验证会议时间是否有效
        [self checkMeetingDateValid];
    }];
}

// 配置修改预约
- (void)configViewForModifyMeeting {
    // 会议状态 0:未开始     1：进行中     2：已结束      3：已取消
    if (self.meeting.meetingState == 0) {
        self.title = @"修改预约(未开始)";
        [self.modifyMeetingBtn setTitle:@"修改预约" forState:UIControlStateNormal];
        [self.cancelMeetingBtn setTitle:@"取消会议" forState:UIControlStateNormal];
    }
    
    if (self.meeting.meetingState == 1) {
        self.title = @"修改预约(进行中)";
        [self.modifyMeetingBtn setTitle:@"修改人员" forState:UIControlStateNormal];
        [self.cancelMeetingBtn setTitle:@"结束会议" forState:UIControlStateNormal];

        self.meetingTitleTF.enabled = NO;
        self.meetingRoomBtn.enabled = NO;
        self.selectBeginDateBtn.enabled = NO;
        self.selectEndDateBtn.enabled = NO;
        self.meetingTimeBtn.enabled = NO;
        self.meetingTypeBtn.enabled = NO;
    }
    self.createMeetingBtn.hidden = YES;
    self.tickBtn.hidden = YES;
    [self.modifyMeetingBtn setBackgroundColor:CTThemeMainColor];
    [self.cancelMeetingBtn setBackgroundColor:CTThemeMainColor];

    
    // 会议主题
    self.meetingTitleTF.text = self.meeting.meetingName;
    // 召集人
    self.createrLabel.text = self.meeting.meetingCreatorName;
    // 会议室
    self.meetingRoomNameL.text = self.meeting.roomName;
    // 日期
    self.beginDate = [NSDate dateWithTimeIntervalSince1970:self.meeting.startTime.doubleValue/1000];
    self.endDate = [NSDate dateWithTimeIntervalSince1970:self.meeting.endTime.doubleValue/1000];
    
    // 时长
    [self.meetingTimeBtn setTitle:self.meeting.meetingDuration forState:UIControlStateNormal];
    // 费用
    self.meetingCostLabel.text = [self.meeting caculateMeetingCostStr];
    // 类型
    self.meetingType = self.meeting.meetingType;
    NSString *title = (self.meetingType == 0)? @"语音": @"视频";
    [self.meetingTypeBtn setTitle:title forState:UIControlStateNormal];
    // 参会人员
    self.users = self.meeting.meetingUserList.mutableCopy;
    [self.tableView reloadData];
}

// 配置会议详情
- (void)configViewForPreviewMeetingDetail {
    self.meetingTitleTF.enabled = NO;
    self.meetingRoomBtn.enabled = NO;
    self.selectBeginDateBtn.enabled = NO;
    self.selectEndDateBtn.enabled = NO;
    self.meetingTimeBtn.enabled = NO;
    self.meetingTypeBtn.enabled = NO;
    
    self.createMeetingBtn.hidden = YES;
    self.modifyMeetingBtn.hidden = YES;
    self.cancelMeetingBtn.hidden = YES;
    self.jianTouBtn.hidden = YES;
    self.tickBtn.hidden = NO;
    self.tableViewBottomConstraint.constant = 0;
    
    // 会议状态   0:未开始     1：进行中     2：已结束      3：已取消
    NSArray *titles = @[@"会议详情(未开始)", @"会议详情(进行中)", @"会议详情(已结束)", @"会议详情(已取消)"];
    self.title = titles[self.meeting.meetingState];

    // 会议主题
    self.meetingTitleTF.text = self.meeting.meetingName;
    // 召集人
    self.createrLabel.text = self.meeting.meetingCreatorName;
    // 会议室
    self.meetingRoomNameL.text = self.meeting.roomName;
    // 日期
    self.beginDate = [NSDate dateWithTimeIntervalSince1970:self.meeting.startTime.doubleValue/1000];
    self.endDate = [NSDate dateWithTimeIntervalSince1970:self.meeting.endTime.doubleValue/1000];
    
    // 时长
    [self.meetingTimeBtn setTitle:self.meeting.meetingDuration forState:UIControlStateNormal];
    // 费用
    self.meetingCostLabel.text = [self.meeting caculateMeetingCostStr];
    // 类型
    self.meetingType = self.meeting.meetingType;
    NSString *title = (self.meetingType == 0)? @"语音": @"视频";
    [self.meetingTypeBtn setTitle:title forState:UIControlStateNormal];
    // 参会人员
    self.users = self.meeting.meetingUserList.mutableCopy;
    [self.tableView reloadData];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Action

- (IBAction)meetingRoomBtnClick:(id)sender {
    YCSelectMeetingRoomController *vc = [YCSelectMeetingRoomController new];
    vc.companyRooms = self.companyRooms;
    vc.otherRooms = self.otherRooms;
    vc.didSelectRoom = ^(YCMeetingRoom *room) {
        self.room = room;
        self.meetingRoomNameL.text = room.roomname;
        [self updateMeetingCost];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)meetingTimeBtnClick:(UIButton *)sender {
    YCSelectMeetingTimeController *vc = [YCSelectMeetingTimeController new];
    vc.room = self.room;
//    NSLog(@"会议有效时间 %@", NSStringFromSelector(_cmd));
    vc.didSelectTime = ^(YCAvailableMeetingTime *time) {
        self.beginDate = [NSDate dateWithTimeIntervalSince1970: time.timeB.doubleValue / 1000];
        self.endDate = [NSDate dateWithTimeIntervalSince1970: time.timeE.doubleValue / 1000];
        [self updateMeetingDate];
        [self updateMeetingCost];
        [self updateMeetingDuration];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)meetingTypeBtnClick:(id)sender {
    // 会议类型 0：音频，1：视频
    UIAlertController *ac = [[UIAlertController alloc]init];
    UIAlertAction *voice = [UIAlertAction actionWithTitle:@"音频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.meetingTypeBtn setTitle:@"音频" forState:UIControlStateNormal];
        self.meetingType = 0;
        [self updateMeetingCost];
    }];
    [ac addAction:voice];
    
    UIAlertAction *vedio = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.meetingTypeBtn setTitle:@"视频" forState:UIControlStateNormal];
        self.meetingType = 1;
        [self updateMeetingCost];
    }];
    [ac addAction:vedio];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)selectBeginDateBtnClick:(UIButton *)sender {
    YCDatePickerViewController *vc = [YCDatePickerViewController picker];
    vc.minimumDate = [NSDate date];

    vc.onDecitdeDate = ^(NSDate *date) {
        self.beginDate = date;
        [self updateMeetingBeginDate:date];
        [self updateMeetingDuration];
        [self updateMeetingCost];
        [self checkMeetingDateValid];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)selectEndDateBtnClick:(UIButton *)sender {
    YCDatePickerViewController *vc = [YCDatePickerViewController picker];
    vc.minimumDate = self.beginDate;
    vc.currentDate = self.endDate;
    vc.onDecitdeDate = ^(NSDate *date) {
        self.endDate = date;
        [self updateMeetingEndDate:date];
        [self updateMeetingDuration];
        [self updateMeetingCost];
        [self checkMeetingDateValid];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)addPeopleBtnClick:(UIButton *)sender {
    CGSelectContactsViewController *vc = [[CGSelectContactsViewController alloc]init];
    vc.titleForBar = @"选择人员";
    vc.completeBtnClickBlock = ^(NSMutableArray<CGUserCompanyContactsEntity *> *contacts) {
        [self convertModels:contacts];
        [self updateMeetingCost];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)createMeetingBtnClick:(UIButton *)sender {
    NSString *meetingName = self.meetingTitleTF.text;
    if ([CTStringUtil stringNotBlank: meetingName] == NO) {
        NSLog(@"名字为空");
        return;
    }
    
    if (self.users.count < 2) {
        return;
    }
    
    NSString *users = self.users[1].userid;
    for (int i = 2; i < self.users.count; i ++) {
        users = [users stringByAppendingFormat:@",%@", self.users[i].userid];
    }
    
    NSString *meetingID = self.meeting? self.meeting.meetingId : @"";
    
    [[YCMeetingBiz new] bookMeetingWithMeetingID:meetingID MeetingType:self.meetingType MeetingName:meetingName users:users roomID:self.room.roomid beginDate:self.beginDate endDate:self.endDate Success:^(id data){
        [CTToast showWithText:@"预约成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
        
    }];
}

- (IBAction)modifyMeetingBtnClick:(id)sender {
    
}

- (IBAction)cancelMeetingBtnClick:(id)sender {
    
}

//- (void)setMeeting:(CGMeeting *)meeting {
//    _meeting = meeting;
//    self.meetingType = meeting.meetingType;
//    self.beginDate = [NSDate dateWithTimeIntervalSince1970:meeting.startTime.doubleValue/1000];
//    self.endDate = [NSDate dateWithTimeIntervalSince1970:meeting.endTime.doubleValue/1000];
//}

- (void)handleCellReduceBtnClick:(NSNotification *)noti {
    YCCreateMeetingUserCell *cell = noti.object;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.users removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingUser *user = self.users[indexPath.row];
    YCCreateMeetingUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCCreateMeetingUserCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = user.userName;
    cell.positionLabel.text = user.position;
    [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:user.userIcon] placeholderImage:[UIImage imageNamed:@"work_head"]];
    
    if (self.style == YCBookMeetingControllerStyleCreate) {
        if (indexPath.row == 0) {
            cell.reduceBtn.hidden = YES;
        } else {
            cell.reduceBtn.hidden = NO;
        }
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark -

- (void)updateMeetingDate {
    [self updateMeetingBeginDate:self.beginDate];
    [self updateMeetingEndDate:self.endDate];
}

- (void)updateMeetingBeginDate:(NSDate *)date {
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy年MM月dd日";
    self.beginDateLabel.text = [f stringFromDate:date];
    f.dateFormat = @"hh:mm";
    self.beginTimeLabel.text = [f stringFromDate:date];
}

- (void)updateMeetingEndDate:(NSDate *)date {
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy年MM月dd日";
    self.endDateLabel.text = [f stringFromDate:date];
    f.dateFormat = @"hh:mm";
    self.endTimeLabel.text = [f stringFromDate:date];
}

- (void)setDefaultMeetingCreater {
    NSString *name = [ObjectShareTool sharedInstance].currentUser.nickname;
    if (!name || name.length == 0) {
        name = [ObjectShareTool sharedInstance].currentUser.username;
    }
    self.createrLabel.text = name;
}

- (YCMeetingRoom *)getDefaultMeetingRoom {
    for (YCMeetingRoom *room in self.companyRooms) {
        if (room.roomDefault) {
            return room;
        }
    }
    for (YCMeetingRoom *room in self.otherRooms) {
        if (room.roomDefault) {
            return room;
        }
    }
    return nil;
}

- (void)setMeetingTime:(YCMeetingRoom *)room {
//    会议时长值显示由会议室可用时间接口返回显示：
//http://doc.cgsays.com:50123/index.php?s=/1&page_id=394
//    如果返回state<>1，代表时间有问题，需红色显示
    if (room.state != 1) {
        [self.meetingTimeBtn.titleLabel setTextColor:[UIColor redColor]];
    } else {
        [self.meetingTimeBtn.titleLabel setTextColor:[UIColor blackColor]];
    }
    
    [self.meetingTimeBtn setTitle:[NSString stringWithFormat:@"%@分钟", room.freetime] forState:UIControlStateNormal];
    
}

- (void)checkMeetingDateValid {
    // 检查时间是否有效。得到结果后只需修改meetingTimeBtn的标题，不用修改其他数据。如果无效，用户会再点击meetingTimeBtn选择有效时间段。
    [[YCMeetingBiz new] checkMeetingDateValidWithBeginDate:self.beginDate endDate:self.endDate meetingID:self.room.roomid OnSuccess:^(NSString *message, int state, NSString *recommendTime) {
        // 如果返回state<>0，代表时间有问题，需红色显示. 状态:0可使用,1被预约,2超过限时
        if (state == 0) {
            [self.meetingTimeBtn setTitle:message forState:UIControlStateNormal];
            [self.meetingTimeBtn.titleLabel setTextColor:[UIColor blackColor]];
        } else {
            [self.meetingTimeBtn setTitle:message forState:UIControlStateNormal];
            [self.meetingTimeBtn.titleLabel setTextColor:[UIColor redColor]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@, error  = %@", NSStringFromSelector(_cmd), error.description);
    }];
}


#pragma mark - Data

// http://doc.cgsays.com:50123/index.php?s=/1&page_id=386
- (void)getMeetingRoomListWithSuccess:(void(^)(NSArray *companyRooms, NSArray *otherRooms))success {
    [[YCMeetingBiz new] getMeetingRoomListWithSuccess:^(NSArray *companyRooms, NSArray *otherRooms) {
        if (success) {
            success(companyRooms, otherRooms);
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)getMeetingDetail {
    [[YCMeetingBiz new] getMeetingDetailWithMeetingID:self.meeting.meetingId success:^(CGMeeting *meeting) {
        self.meeting = meeting;
        [self configViewForPreviewMeetingDetail];
    } fail:^(NSError *error) {
        
    }];
}


@end
