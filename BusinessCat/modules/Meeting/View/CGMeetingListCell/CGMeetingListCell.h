//
//  CGMeetingListCell.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

// 按钮点击事件，通知里的object是 cell
#define kCGMeetingListCellBtnClickNotification @"kCGMeetingListCellBtnClickNotification"


@interface CGMeetingListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *meetingTypeLabel; // 会议名字
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *button; // 点击发送通知,通知里的参数是 cell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSIndexPath *indexPath;

- (void)setImageName:(NSString *)name;
- (void)setCountLabelTextWithNumber:(NSUInteger)count;
- (void)setTimeLabelTextWithTimeInterval:(NSString *)interval;
+ (float)cellHeight;

@end





