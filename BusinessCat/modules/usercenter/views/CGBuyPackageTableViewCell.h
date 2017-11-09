//
//  CGBuyPackageTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGBuyPackageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;

@end
