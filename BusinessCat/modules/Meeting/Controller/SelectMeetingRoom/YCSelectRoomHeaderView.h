//
//  YCSelectRoomHeaderView.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCSelectRoomHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *triangleBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

+ (instancetype)headerView;
+ (float)headerViewHeight;
@end
