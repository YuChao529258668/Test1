//
//  CGKnowledgeBaseTableTopViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowledgeBaseEntity.h"

typedef void (^CGKnowledgeBaseTableTopBlock)(NSInteger selectIndex);
@interface CGKnowledgeBaseTableTopViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
-(void)updata:(NSMutableArray *)array selectIndex:(NSInteger)selectIndex block:(CGKnowledgeBaseTableTopBlock)block;
@end
