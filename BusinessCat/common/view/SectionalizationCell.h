//
//  SectionalizationCell.h
//  CGSays
//
//  Created by zhu on 2017/3/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupJoinEntity.h"
#import "CGInfoHeadEntity.h"
typedef void (^SectionalizationBlock)(BOOL isSubscribe);
@interface SectionalizationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *monitoringButton;
-(void)groupInfo:(JoinEntity *)entity headInfo:(CGInfoHeadEntity *)headEntity;
-(void)headInfo:(CGInfoHeadEntity *)entity isSubscribe:(BOOL)isSubscribe block:(SectionalizationBlock )block;
@end
