//
//  CGBuyMethodPaymentTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGPayMethodEntity.h"

@interface CGBuyMethodPaymentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
-(void)update:(CGPayMethodEntity *)entity;
@end
