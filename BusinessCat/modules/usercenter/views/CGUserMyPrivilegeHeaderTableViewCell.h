//
//  CGUserMyPrivilegeHeaderTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGUserMyPrivilegeHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;

- (void)getLevelWithNumber:(NSString *)number;
@end
