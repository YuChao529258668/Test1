//
//  YCMeetingRoomListTimeCell.h
//  BusinessCat
//
//  Created by 余超 on 2018/3/29.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YCMeetingRoom.h"

@interface YCMeetingRoomListTimeCell : UICollectionViewCell

//@property (nonatomic, strong) YCMeetingRoom *room;


@property (weak, nonatomic) IBOutlet UILabel *hourL;
@property (weak, nonatomic) IBOutlet UIView *timeL;
@property (weak, nonatomic) IBOutlet UIView *darkTimeL;

@property (nonatomic, strong) NSValue *timeViewFrame;
@property (nonatomic, strong) NSValue *darkTimeViewFrame;

@property (nonatomic, assign) NSInteger cellItem;

+ (CGSize)itemSize;

+ (float)height;

+ (float)space;

+ (float)yellowMaxHeight;

@end
