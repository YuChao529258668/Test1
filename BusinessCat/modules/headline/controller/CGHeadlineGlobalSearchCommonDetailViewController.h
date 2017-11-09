//
//  CGHeadlineGlobalSearchCommonDetailViewController.h
//  CGSays
//
//  Created by zhu on 2016/11/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

typedef void (^CGHeadlineGlobalSearchCommonDetailClearBlock)(BOOL clearKeyword);
typedef void (^CGHeadlineGlobalSearchCommonVoiceSearchBlock)(NSString *keyWord);
@interface CGHeadlineGlobalSearchCommonDetailViewController : CTBaseViewController{
  CGHeadlineGlobalSearchCommonDetailClearBlock clearBlock;
  CGHeadlineGlobalSearchCommonVoiceSearchBlock voiceBlock;
}
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *action; //全局搜索
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger infoAction;//知识搜索
@property (nonatomic, copy) NSString *subType;
@property (nonatomic, assign) BOOL isH5;
@property (nonatomic, assign) NSInteger searchType;
-(instancetype)initWithClear:(CGHeadlineGlobalSearchCommonDetailClearBlock)cancel voiceSearchBlock:(CGHeadlineGlobalSearchCommonVoiceSearchBlock)voiceSearchBlock;
@end
