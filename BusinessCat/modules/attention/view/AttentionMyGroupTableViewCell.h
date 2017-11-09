//
//  AttentionMyGroupTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionMyGroupEntity.h"

@interface AttentionMyGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataNumber;
@property (weak, nonatomic) IBOutlet UILabel *allCountLabel;
-(void)update:(AttentionMyGroupEntity *)entity;
@end
