//
//  YCMeetingRoomListCell.m
//  BusinessCat
//
//  Created by 余超 on 2018/3/29.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCMeetingRoomListCell.h"
#import "YCMeetingRoomListTimeCell.h"

@interface YCMeetingRoomListCell()<UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray<NSValue *> *yellowFrames;

@end


@implementation YCMeetingRoomListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self caculateYellowFrame];
    [self configCollectionView];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = [YCMeetingRoomListTimeCell itemSize];
    layout.minimumInteritemSpacing = [YCMeetingRoomListTimeCell space];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YCMeetingRoomListTimeCell" bundle:nil] forCellWithReuseIdentifier:@"YCMeetingRoomListTimeCell"];
    self.collectionView.dataSource = self;
}

+ (float)hight {
    return 232+24;
}

- (void)setRoom:(YCMeetingRoom *)room {
    _room = room;

    self.roomNameL.text = room.roomName;
    [self updateBookBtn];
    [self caculateYellowFrame];
    [self.collectionView reloadData];
}

- (void)updateBookBtn {
    if (self.room.isFull) {
        [self.bookBtn setTitle:@"已满" forState:UIControlStateNormal];
        [self.bookBtn setBackgroundColor:[YCTool colorWithRed:157 green:157 blue:157 alpha:1]];
        self.bookBtn.userInteractionEnabled = NO;
        return;
    }
    
    [self.bookBtn setTitle:@"预订" forState:UIControlStateNormal];
    [self.bookBtn setBackgroundColor:CTThemeMainColor];
    self.bookBtn.userInteractionEnabled = YES;
}

- (void)caculateYellowFrame {
    float width = [YCMeetingRoomListTimeCell itemSize].width;
    float yellowMaxHeight = [YCMeetingRoomListTimeCell yellowMaxHeight];
    
    self.yellowFrames = [NSMutableArray arrayWithCapacity:24];
    
    for (int i = 0; i < 24; i++) {
        CGRect frame = CGRectMake(0, 0, width, 0);
        NSValue *v = [NSValue valueWithCGRect:frame];
        [self.yellowFrames addObject:v];
    }

    NSArray<YCMeetingOccupyTime *> *meetingTimeList = self.room.meetingTimeList;
    
    // 遍历时间段数组
    for (YCMeetingOccupyTime *time in meetingTimeList) {
        NSInteger startHour = time.startHour;// 开始小时
        NSInteger startM = time.startM;// 开始分钟
        NSInteger endHour = time.endHour;
        NSInteger endM = time.endM;
        
        if (startHour == endHour) {// 如果同一个小时
            CGRect frame = self.yellowFrames[startHour].CGRectValue;// 获取数组对应的元素
            frame.origin.y = startM/60.0 * yellowMaxHeight;// 修改 y，开始分钟/60分钟*最大高度
            frame.size.height = (endM - startM)/60.0 * yellowMaxHeight;//  修改高度，分钟数/60分钟*最大高度
            self.yellowFrames[startHour] = [NSValue valueWithCGRect:frame];// 放回数组里面
        } else {
            // 如果跨小时
            // 修改第一个小时
            CGRect frame = self.yellowFrames[startHour].CGRectValue;
            frame.origin.y = startM/60.0 * yellowMaxHeight;
            frame.size.height = yellowMaxHeight - frame.origin.y;
            self.yellowFrames[startHour] = [NSValue valueWithCGRect:frame];
            
            // 如果是中间的小时，高度就是最大高度
            while ((++startHour) < endHour) {
                CGRect frame = self.yellowFrames[startHour].CGRectValue;
                frame.size.height = yellowMaxHeight;// 修改高度
                self.yellowFrames[startHour] = [NSValue valueWithCGRect:frame];
            }
            
            // 修改最后一个小时
            frame = self.yellowFrames[endHour].CGRectValue;
            frame.size.height = endM/60.0 * yellowMaxHeight;// 修改高度
            self.yellowFrames[startHour] = [NSValue valueWithCGRect:frame];
        }
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCMeetingRoomListTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YCMeetingRoomListTimeCell" forIndexPath:indexPath];
    cell.cellItem = indexPath.item;
    cell.hourL.text = [NSString stringWithFormat:@"%ld", indexPath.item];
//    cell.room = self.room;
    cell.timeViewFrame = self.yellowFrames[indexPath.item];
    return cell;
}

- (IBAction)clickBookBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:[self.class notificationName] object:self];
}

+ (NSString *)notificationName {
    return @"YCMeetingRoomListCellClickNotification";
}

@end


#pragma mark - YCMeetingRoomListCellLabel

@implementation YCMeetingRoomListCellLabel

- (void)setText:(NSString *)text {
    text = [NSString stringWithFormat:@"  %@  ", text];
    [super setText:text];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
}

//- (void)drawRect:(CGRect)rect {
//
//}

@end

