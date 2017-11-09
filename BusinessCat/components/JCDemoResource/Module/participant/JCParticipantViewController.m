//
//  ParticipantViewController.m
//  UltimateShow
//
//  Created by Nathan Zheng on 2017/3/21.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCParticipantViewController.h"
#import <JCApi/JCApi.h>
#import "JCParticipantCell.h"

@interface JCParticipantViewController () <JCEngineDelegate> {
    JCEngineManager *_confManager;
    
    NSMutableArray<NSString *> *_participantDataSource; //会议成员的数据源，保存成员的userId    
}

//展示会议成员列表的视图
//@property (nonatomic, strong) UITableView *participantTableView;

//默认用ParticipantCell
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) void(^cellConfigBlock) (id cell, NSString *userId);

@end

@implementation JCParticipantViewController

#pragma mark - setter and getter

- (void)setWantsHighResolution:(BOOL)wantsHighResolution
{
    if (_wantsHighResolution != wantsHighResolution) {
        _wantsHighResolution = wantsHighResolution;
        
        __weak typeof(self) weakSelf = self;
        _cellConfigBlock = ^(id cell, NSString *userId) {
            JCParticipantCell *tempCell = (JCParticipantCell *)cell;
            tempCell.userId = userId;
            tempCell.wantsHighResolution = weakSelf.wantsHighResolution;
        };
    }
}

- (UITableView *)participantTableView {
    if (!_participantTableView) {
        _participantTableView = [[UITableView alloc] init];
        _participantTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _participantTableView.backgroundColor = [UIColor clearColor];
        _participantTableView.separatorColor = [UIColor clearColor];
        _participantTableView.dataSource = self;
        _participantTableView.delegate = self;
        [_participantTableView registerClass:[JCParticipantCell class] forCellReuseIdentifier:@"ParticipantCellId"];
    }
    return _participantTableView;
}

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _visibleCellCount = 4;
        
        _confManager = [JCEngineManager sharedManager];
        [_confManager setDelegate:self];
        
        _participantDataSource = [NSMutableArray array];
        
        _wantsHighResolution = NO;
        
        _cellIdentifier = @"ParticipantCellId";
        
        __weak typeof(self) weakSelf = self;
        _cellConfigBlock = ^(id cell, NSString *userId) {
            JCParticipantCell *tempCell = (JCParticipantCell *)cell;
            tempCell.userId = userId;
            tempCell.wantsHighResolution = weakSelf.wantsHighResolution;
        };
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ParticipantViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.participantTableView];
    self.participantTableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JCEngine delegate
//成员加入会议
- (void)onParticipantJoin:(NSString *)userId {
    //更新数据源
    [_participantDataSource addObject:userId];
    
    if ([self isViewLoaded]) {
        NSInteger row = [_participantDataSource indexOfObject:userId];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [_participantTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

//成员离开会议
- (void)onParticipantLeft:(ErrorReason)eventReason userId:(NSString *)userId {
    if ([_participantDataSource containsObject:userId]) {
        //更新数据源
        NSInteger row = [_participantDataSource indexOfObject:userId];
        [_participantDataSource removeObject:userId];
        
        if ([self isViewLoaded]) {
            //删除cell
            [_participantTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
}

//成员属性状态更新
- (void)onParticipantUpdated:(NSString *)userId {
    if ([self isViewLoaded] && [_participantDataSource containsObject:userId]) {
        
        BOOL isHost = [_confManager getParticipantWithUserId:userId].isHost;
        NSUInteger index = [_participantDataSource indexOfObject:userId];
        if (isHost && index != 0) {
            [self reload];
            return;
        }
        
        NSInteger row = [_participantDataSource indexOfObject:userId];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [_participantTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _participantDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    NSString *userId = [_participantDataSource objectAtIndex:indexPath.row];
    
    if (_cellConfigBlock) {
        _cellConfigBlock(cell, userId);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return _participantTableView.bounds.size.height / _visibleCellCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate) {
        NSString *userid = nil;
        if (indexPath.row >= 0 && indexPath.row < _participantDataSource.count ) {
            userid = [_participantDataSource objectAtIndex:indexPath.row];
        }
        [_delegate didSelectRowForUserId:userid];
    }
}

#pragma mark - public function

- (void)setCellWithIdentifier:(NSString *)identifier configureBlock:(void (^)(id cell, NSString *userId))block {
    if (!identifier || identifier.length == 0 || !block) {
        return;
    }
    
    _cellIdentifier = identifier;
    _cellConfigBlock = block;
}

- (void)reload {
    [_participantDataSource removeAllObjects];
    
    // 加入会议成功后，获取JCRoomModel对象
    JCRoomModel *confInfo = [_confManager getRoomInfo];
    // 获取成员列表，并逐一遍历成员的id
    for (JCParticipantModel *model in confInfo.participants) {
        // 将所有成员的id保存到数组中
        [_participantDataSource addObject:model.userId];
    }
    
    [_participantTableView reloadData];
}

- (void)stopShow {
    for (NSString *userId in _participantDataSource) {
        [_confManager cancelVideoRequestWithUserId:userId pictureSize:_wantsHighResolution ? VideoPictureSizeSmall : VideoPictureSizeMin];
    }
}

@end
