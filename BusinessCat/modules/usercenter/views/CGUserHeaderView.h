//
//  CGUerHeaderView.h
//  CGSays
//
//  Created by zhu on 16/10/17.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGUserEntity.h"
#import "CGUserStatistics.h"

@interface CGUserHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *userIcon;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *privilegeView;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (weak, nonatomic) IBOutlet UIView *levelView;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *experienceBtn;
@property (weak, nonatomic) IBOutlet UIButton *fileBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIButton *privilegeBtn;
@property (weak, nonatomic) IBOutlet UILabel *levelTextLabel;



+ (instancetype)userHeaderView;
+ (float)height;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (void)info:(CGUserEntity *)userInfo;
@end
