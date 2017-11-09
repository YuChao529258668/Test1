//
//  ThemeTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/2/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionHead.h"

@interface ThemeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *alldataNumber;
@property (weak, nonatomic) IBOutlet UILabel *DataNumber;
-(void)updateItem:(AttentionHead *)entity;
@end
