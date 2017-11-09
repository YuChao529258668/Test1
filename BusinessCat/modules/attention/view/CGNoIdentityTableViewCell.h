//
//  CGNoIdentityTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowledgeBaseEntity.h"

@interface CGNoIdentityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *viewPromptLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
-(void)update:(KnowledgeBaseEntity *)entity;
@end
