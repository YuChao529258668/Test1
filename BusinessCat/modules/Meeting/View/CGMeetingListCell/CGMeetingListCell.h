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


// 编译错误 提示找不到 CGMeetingListCellButtonModell 类
// 参与会议的用户信息
//@interface CGMeetingListCellButtonModell : NSObject
//@property (nonatomic,strong) NSString *title;
//@property (nonatomic,strong) NSString *modelID;
//@end


// Cell
@interface CGMeetingListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *meetingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *button; // 点击发送通知,通知里的参数是 cell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//@property (nonatomic,strong) NSString *modelID;
//@property (nonatomic,strong) NSArray<CGMeetingListCellButtonModell *> *btnModels;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSIndexPath *indexPath;


- (void)setCountLabelTextWithNumber:(NSString *)count;
- (void)setTimeLabelTextWithTimeInterval:(NSString *)interval;
+ (float)cellHeight;

@end





