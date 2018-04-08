//
//  YCCreateMeetingTimeCell.m
//  BusinessCat
//
//  Created by 余超 on 2018/3/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCCreateMeetingTimeCell.h"

@interface YCCreateMeetingTimeCell()
@property (nonatomic, strong) NSMutableArray<UIButton *> *btns;

@end


@implementation YCCreateMeetingTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    NSNumber *n1 = @(-1);
//    NSNumber *n2 = @YES;
    
    self.btns = [NSMutableArray arrayWithCapacity:4];
    [self.btns addObject:self.btn0];
    [self.btns addObject:self.btn1];
    [self.btns addObject:self.btn2];
    [self.btns addObject:self.btn3];
}

- (IBAction)clickBtn:(UIButton *)sender {
    self.clickIndex = sender.tag;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[self.class notificationName]  object:self];
}

#pragma mark -

+ (NSString *)notificationName {
    return @"YCCreateMeetingTimeCellClickNotification";
}

+ (float)height {
    return 158;
}

+ (CGSize)itemSize {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float width = 0;
    
    if (screenWidth < 375) {
        width = 38;
    } else if (screenWidth == 375) {
        width = 40;
    } else {
        width = 44;
    }
    return CGSizeMake(width, [self height]);
}

- (void)setTimeCellSelection:(YCTimeCellSelection *)timeCellSelection {
    _timeCellSelection = timeCellSelection;
    
    NSNumber *num;
    for (int i = 0; i < 4; i++) {
        num = timeCellSelection.selections[i];
        if (num.intValue > 0) { // 选中的
            self.btns[i].backgroundColor = [YCTool colorWithRed:61 green:186 blue:253 alpha:1];
        }
        if (num.intValue == 0) { // 可选的
            self.btns[i].backgroundColor = [YCTool colorOfHex:0xDCE6F0];
        }
        if (num.intValue == -1) {// 被占用的
            self.btns[i].backgroundColor = CTThemeMainColor;
        }
        if (num.intValue == -2) {// 过时的
//            self.btns[i].backgroundColor = [UIColor darkGrayColor];
            self.btns[i].backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_cell_bg"]];

        }
    }
}

- (void)shouldHighlight:(BOOL)b btnIndex:(NSInteger)index {
    if (b) {
        self.btns[index].backgroundColor = [YCTool colorWithRed:61 green:186 blue:253 alpha:1];
    } else {
        self.btns[index].backgroundColor = [YCTool colorOfHex:0xDCE6F0];
    }
}

@end

#pragma mark -

@implementation YCTimeCellSelection

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selections = @[@0, @0, @0, @0].mutableCopy;
    }
    return self;
}

@end

