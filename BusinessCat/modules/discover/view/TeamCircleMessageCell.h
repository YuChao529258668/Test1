//
//  TeamCircleMessageCell.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/6/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamCircleMessageModel.h"

@interface TeamCircleMessageCell : UITableViewCell

-(void)updateItem:(TeamCircleMessageModel *)entity;

@end
