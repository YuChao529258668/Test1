//
//  YCCreateMeetingTimeCell.h
//  BusinessCat
//
//  Created by 余超 on 2018/3/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCCreateMeetingTimeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *hourL;

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (nonatomic, assign) NSInteger cellItem;
@property (nonatomic, assign) NSInteger clickIndex;
+ (CGSize)itemSize;
+ (float)height;
+ (NSString *)notificationName;
- (void)shouldHighlight:(BOOL)b;

@end
