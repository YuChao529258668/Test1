//
//  CGMessageDetailMoreGraphicTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGMessageDetailEntity.h"

@interface CGMessageDetailMoreGraphicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *IV;
@property (weak, nonatomic) IBOutlet UIView *bgLineView;
-(void)update:(CGMessageDetailEntity *)entity;
@end
