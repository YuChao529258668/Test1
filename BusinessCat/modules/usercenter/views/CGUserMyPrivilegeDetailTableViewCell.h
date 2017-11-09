//
//  CGUserMyPrivilegeDetailTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGUserMyPrivilegeDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *TitleLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *numberLabel;
- (void)setTitleWithArray:(NSArray *)titleArray unitWithArray:(NSArray *)unitArray numberWithArray:(NSArray *)numberArray;
@end
