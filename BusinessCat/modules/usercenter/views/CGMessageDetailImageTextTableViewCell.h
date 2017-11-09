//
//  CGMessageDetailImageTextTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGMessageDetailEntity.h"

@interface CGMessageDetailImageTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
-(void)update:(CGMessageDetailListEntity *)entity;
@end
