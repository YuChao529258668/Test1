//
//  CGEnterpriseMemberHeaderTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGCorporateMemberEntity.h"

@interface CGEnterpriseMemberHeaderTableViewCell : UITableViewCell

-(void)update:(CGCorporateMemberEntity *)item type:(int)type;

@end
