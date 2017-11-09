//
//  CompanyTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/2/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionHead.h"

@interface CompanyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dataNumber;
@property (weak, nonatomic) IBOutlet UILabel *allDataNumber;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
-(void)updateItem:(AttentionHead *)entity;
@end
