//
//  CGAttentionSearchKeyWordViewController.h
//  CGSays
//
//  Created by zhu on 2017/3/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
//带界面的语音识别控件
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import <iflyMSC/iflyMSC.h>

@interface CGAttentionSearchKeyWordViewController : CTBaseViewController
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, assign) NSInteger isAttentionIndex;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, assign) NSInteger type;
@end
