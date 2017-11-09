//
//  CGHeadlineGlobalSearchDetailViewController.h
//  CGSays
//
//  Created by zhu on 16/11/12.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void (^CGHeadlineGlobalSearchDetailClearBlock)(BOOL clearKeyword);
typedef void (^CGHeadlineGlobalVoiceSearchBlock)(NSString *keyWord);
@interface CGHeadlineGlobalSearchDetailViewController : CTBaseViewController{
  CGHeadlineGlobalSearchDetailClearBlock clearBlock;
  CGHeadlineGlobalVoiceSearchBlock voiceBlock;
}
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, copy) NSString *selectIndex;
@property (nonatomic, assign) NSInteger searchType;
-(instancetype)initWithClear:(CGHeadlineGlobalSearchDetailClearBlock)cancel voiceSearchBlock:(CGHeadlineGlobalVoiceSearchBlock)voiceSearchBlock;
@end
