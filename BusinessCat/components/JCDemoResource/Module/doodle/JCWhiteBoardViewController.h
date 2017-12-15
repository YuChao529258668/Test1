//
//  WhiteBoardViewController.h
//  UltimateShow
//
//  Created by young on 17/1/3.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCDoodleToolbar.h"
#import "JCColourToolbar.h"



@interface JCWhiteBoardViewController : UIViewController

//涂鸦操作的工具栏
@property (nonatomic, strong) JCDoodleToolbar *doodletoolbar;

//选画笔颜色的工具栏
@property (nonatomic, strong) JCColourToolbar *colorsToolbar;

//总的页数，默认总数为1页
@property (nonatomic) NSUInteger pageCount;

//默认当前为第0页
@property (nonatomic) NSUInteger currentPage;

//默认背景色为白色
@property (nonatomic, copy) UIColor *backgroundColor;

//默认为nil
@property (nonatomic, strong) UIImage *backgroundImage;

//当多页时，可以设置每一页的背景色
- (void)setBackgroundColors:(NSArray<UIColor *> *)colors;

//当多页时，可以设置每一页的背景图
- (void)setBackgroundImages:(NSArray<UIImage *> *)images;

//清除轨迹
- (void)cleanAllPath;

- (void)updatePageLabel;

@property (nonatomic,strong) NSString *meetingID;

//// 更新要显示的课件
//- (void)updateMeetingFile;

//// 双击变成全屏或恢复
//- (void)handleDoubleTap;

@end
