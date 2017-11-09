//
//  AttentionUnfoldTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/16.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionUnfoldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
-(void)update:(BOOL)isUnfold;
@end
