//
//  YCSelectMeetingRoomController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCSelectMeetingRoomController.h"

#import "YCSelectRoomHeaderView.h"
#import "YCSelectRoomFooterView.h"
#import "YCMeetingBiz.h"
#import "YCMeetingRoom.h"

@interface YCSelectMeetingRoomController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<YCMeetingCompanyRoom *> *companyRooms;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *isSectionDisplays;// 某个 section 是否展开显示

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn16;

@end

@implementation YCSelectMeetingRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.videoBtn.layer.cornerRadius = 4;
    self.videoBtn.clipsToBounds = YES;
    self.voiceBtn.layer.cornerRadius = 4;
    self.voiceBtn.clipsToBounds = YES;
//    [self.videoBtn sendActionsForControlEvents:UIControlEventTouchUpInside];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 32;
    self.tableView.sectionHeaderHeight = [YCSelectRoomHeaderView headerViewHeight];
    self.tableView.sectionFooterHeight = [YCSelectRoomFooterView height];
    [self.tableView registerNib:[UINib nibWithNibName:@"YCSelectRoomHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"YCSelectRoomHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YCSelectRoomFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"YCSelectRoomFooterView"];
//    self.tableView.editing = YES;
//    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickHeaderView:) name:[YCSelectRoomHeaderView notificationName] object:nil];
    
//    [self recoverSelection];
    [self getRoomList];
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    NSString *str;
//    if ([app_Name containsString:@"会议"]) {
//        str = @"会议";
//    } else {
//        str = @"会面";
//    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Meeting" bundle:nil];
        self = [sb instantiateViewControllerWithIdentifier:@"YCSelectMeetingRoomController"];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)recoverSelection {
    UIButton *btn;
    switch (self.count) {
        case 4:
            btn = self.btn4;
            break;
        case 8:
            btn = self.btn8;
            break;
        case 16:
            btn = self.btn16;
            break;
    }
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    if (self.count) {
        if (self.isVideo && self.count) {
            [self.videoBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        } else {
            [self.voiceBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        [self.videoBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.selectedRoom && self.companyRooms) {
        
        [self.companyRooms enumerateObjectsUsingBlock:^(YCMeetingCompanyRoom * _Nonnull companyRoom, NSUInteger section, BOOL * _Nonnull stop) {
            printf("section = %ld", section);
            [companyRoom.roomData enumerateObjectsUsingBlock:^(YCMeetingRoom * _Nonnull room, NSUInteger row, BOOL * _Nonnull stop2) {
                if ([room.roomId isEqualToString:self.selectedRoom.roomId]) {
                    NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:section];
                    [self.tableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [self tableView:self.tableView didSelectRowAtIndexPath:ip];
                    *stop = YES;
                    *stop2 = YES;
                }
            }];
            
        }];
        
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    return;
    
    if (indexPath.section == self.selectedIndexPath.section && indexPath.row == self.selectedIndexPath.row && self.selectedIndexPath) {
        self.selectedIndexPath = nil;
        self.selectedRoom = nil;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *markBtn = [cell viewWithTag:3];
        markBtn.selected = NO;

    } else {
        self.selectedIndexPath = indexPath;
        self.selectedRoom = self.companyRooms[indexPath.section].roomData[indexPath.row];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *markBtn = [cell viewWithTag:3];
        markBtn.selected = YES;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = nil;
    self.selectedRoom = nil;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *markBtn = [cell viewWithTag:3];
    markBtn.selected = NO;
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.companyRooms.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSectionDisplays[section].unsignedIntegerValue == 1) {
        return self.companyRooms[section].roomData.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingRoom *room;
    room = self.companyRooms[indexPath.section].roomData[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *nameL = [cell viewWithTag:1];
    UILabel *contentL = [cell viewWithTag:2];
    UIButton *markBtn = [cell viewWithTag:3];
    
    nameL.text = room.roomName;
    contentL.text = room.msg;// 所选时段空闲可用, 已被预约
    
    contentL.textColor = [YCTool colorOfHex:0x777777];
    if (room.state == 0) {
        contentL.textColor = [YCTool colorOfHex:0xff3e3e];
    }
    
    if (indexPath == self.selectedIndexPath) {
        markBtn.selected = YES;
    } else {
        markBtn.selected = NO;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YCSelectRoomHeaderView *view = (YCSelectRoomHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YCSelectRoomHeaderView"];
    view.nameLabel.text = self.companyRooms[section].name;
    view.section = section;
    BOOL isDisplay = self.isSectionDisplays[section].intValue == 1? YES: NO;
    [view setDisplay:isDisplay];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BOOL isDisplay = self.isSectionDisplays[section].intValue == 1? YES: NO;
    if (isDisplay) {
        YCSelectRoomFooterView *view = (YCSelectRoomFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YCSelectRoomFooterView"];
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    BOOL isDisplay = self.isSectionDisplays[section].intValue == 1? YES: NO;
    if (isDisplay) {
        return [YCSelectRoomFooterView height];
    } else {
        return 0;
    }
}

#pragma mark - Data

- (void)getRoomList {
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] getMeetingRoomListWithBeginDate:self.beginDate endDate:self.endDate Success:^(NSArray<YCMeetingCompanyRoom *> *companyRooms) {
        
        NSUInteger count = companyRooms.count;
        weakself.isSectionDisplays = [NSMutableArray arrayWithCapacity:count];
        [weakself.isSectionDisplays addObject:@1];
        for (int i = 1; i < count; i++) {
            [weakself.isSectionDisplays addObject:@0];
        }

        weakself.companyRooms = companyRooms;
        [weakself.tableView reloadData];
        [weakself recoverSelection];
    } fail:^(NSError *error) {
        
    }];
}


#pragma mark - Action

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickHeaderView:(NSNotification *)noti {
    YCSelectRoomHeaderView *view = noti.object;
    BOOL isDisplay = self.isSectionDisplays[view.section].intValue == 1? YES: NO;
    isDisplay = !isDisplay;
    self.isSectionDisplays[view.section] = @(isDisplay);
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:view.section] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadData];
}

- (IBAction)clickVideoBtn:(UIButton *)sender {
    self.voiceBtn.selected = NO;
    self.voiceBtn.backgroundColor = [UIColor clearColor];
    
    sender.selected = YES;
    sender.backgroundColor = CTThemeMainColor;
    self.isVideo = YES;
}
- (IBAction)clickVoiceBtn:(UIButton *)sender {
    self.videoBtn.selected = NO;
    self.videoBtn.backgroundColor = [UIColor clearColor];

    sender.selected = YES;
    sender.backgroundColor = CTThemeMainColor;
    self.isVideo = NO;
}

- (IBAction)clickBtn4:(UIButton *)sender {
    BOOL selected = !sender.isSelected;
    if (selected) {
        self.btn8.selected= NO;
        self.btn16.selected= NO;
        self.count = 4;
    } else {
        self.count = 0;
    }
    self.btn4.selected= selected;
}
- (IBAction)clickBtn8:(UIButton *)sender {
    BOOL selected = !sender.isSelected;
    if (selected) {
        self.btn4.selected= NO;
        self.btn16.selected= NO;
        self.count = 8;
    } else {
        self.count = 0;
    }
    self.btn8.selected= selected;
    
}
- (IBAction)clickBtn16:(UIButton *)sender {
    BOOL selected = !sender.isSelected;
    if (selected) {
        self.btn8.selected= NO;
        self.btn4.selected= NO;
        self.count = 16;
    } else {
        self.count = 0;
    }
    self.btn16.selected= selected;
    
}

- (IBAction)clickOKBtn:(id)sender {
    if (self.didSelectBlock) {
        self.didSelectBlock(self.selectedRoom, self.isVideo, self.count);
    }
    [self dismiss:nil];
}

@end
