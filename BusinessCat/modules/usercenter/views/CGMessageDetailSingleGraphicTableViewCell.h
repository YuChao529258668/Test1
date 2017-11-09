//
//  CGMessageDetailSingleGraphicTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGMessageDetailEntity.h"

@interface CGMessageDetailSingleGraphicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *IV;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIView *bgView;

-(void)update:(CGMessageDetailEntity *)entity;
+(CGFloat)height:(CGMessageDetailEntity *)entity;
@end
