//
//  YCMeetingRoomListCell.h
//  BusinessCat
//
//  Created by 余超 on 2018/3/29.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCMeetingRoom.h"

@interface YCMeetingRoomListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) YCMeetingRoom *room;

@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
@property (weak, nonatomic) IBOutlet UILabel *roomNameL;
+ (float)hight;
+ (NSString *)notificationName;

@property (nonatomic, assign) BOOL isToday;


@end


@interface YCMeetingRoomListCellLabel : UILabel

@end


