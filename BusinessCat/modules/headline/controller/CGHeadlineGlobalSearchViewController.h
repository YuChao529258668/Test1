//
//  CGHeadlineGlobalSearchViewController.h
//  CGSays
//
//  Created by zhu on 16/11/12.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
//带界面的语音识别控件
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import <iflyMSC/iflyMSC.h>

@interface CGHeadlineGlobalSearchViewController : CTBaseViewController
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString* action;
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger infoAction;//知识搜索
@property (nonatomic, assign) BOOL isHtml5;
@property (nonatomic, copy) NSString *attentionType;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *selectIndex;
@property (nonatomic, copy) NSString *subType;
@property (nonatomic, assign) NSInteger searchType;//0其他界面 1雷达界面 2体验
@end
