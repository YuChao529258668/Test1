//
//  CGInterfaceDetailTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/31.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGProductDetailsVersionEntity.h"
typedef void (^CGInterfaceDetailViewBlock)(CGProductDetailsVersionEntity *entity);
typedef void (^CGInterfaceDetailPushViewBlock)();
@interface CGInterfaceDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *leftBgView;
@property (weak, nonatomic) IBOutlet UIView *rightBgView;
@property (weak, nonatomic) IBOutlet UIView *centerBgView;

-(void)update:(CGProductDetailsVersionEntity *)entity block:(CGInterfaceDetailViewBlock)block pushBlock:(CGInterfaceDetailPushViewBlock)pushBlock;
@end
