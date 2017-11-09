//
//  CGDiscoverPartSeeAddressTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGPartSeeAddressEntity.h"
typedef void(^ButtomClickBlock)(UIButton *sender);
@interface CGDiscoverPartSeeAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, strong) CGPartSeeAddressEntity *entity;
@property (nonatomic,copy) ButtomClickBlock buttonBlock;
- (void)didSelectedButtonIndex:(ButtomClickBlock)block;
@end
