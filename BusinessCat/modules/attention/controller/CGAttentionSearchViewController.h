//
//  CGAttentionSearchViewController.h
//  CGSays
//
//  Created by zhu on 2017/3/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void (^CGAttentionSearchDetailClearBlock)(BOOL clearKeyword);

@interface CGAttentionSearchViewController : CTBaseViewController{
  CGAttentionSearchDetailClearBlock clearBlock;
}
-(instancetype)initWithClear:(CGAttentionSearchDetailClearBlock)cancel;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, assign) NSInteger isAttentionIndex;
@property (nonatomic, copy) NSString *action;
@end
