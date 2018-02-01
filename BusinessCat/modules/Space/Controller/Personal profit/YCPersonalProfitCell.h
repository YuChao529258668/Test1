//
//  YCPersonalProfitCell.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/31.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCPersonalProfitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;
@property (weak, nonatomic) IBOutlet UILabel *incomeL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;

+ (float)cellHeight;
+ (float)cellWidth;
@end
