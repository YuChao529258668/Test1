//
//  YCCreateMeetingTimeCell.h
//  BusinessCat
//
//  Created by 余超 on 2018/3/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCTimeCellSelection;

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

@property (nonatomic, strong) YCTimeCellSelection *timeCellSelection;

- (void)shouldHighlight:(BOOL)b btnIndex:(NSInteger)index;

@end


#pragma mark -

@interface YCTimeCellSelection : NSObject
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selections;// 0, 1, -1, -2

@end

