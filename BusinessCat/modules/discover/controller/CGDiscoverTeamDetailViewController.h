//
//  CGDiscoverTeamDetailViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/19.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CellLayout.h"

typedef void (^CGDiscoverTeamDetailUpdateBlock)(CellLayout* cellLayout);
typedef void (^CGDiscoverTeamDetailDeleteBlock)(CellLayout* cellLayout);
@interface CGDiscoverTeamDetailViewController : CTBaseViewController
@property (nonatomic, assign) NSInteger index;
-(instancetype)initWithScoopID:(NSString *)scoopID updateBlock:(CGDiscoverTeamDetailUpdateBlock)updateBlock deleteBlock:(CGDiscoverTeamDetailDeleteBlock)deleteBlock;
@end
