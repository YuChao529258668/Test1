//
//  CGSectionalizationView.h
//  CGSays
//
//  Created by zhu on 2017/3/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"
typedef void (^CGSectionalizationViewBlock)(BOOL isMonitoring);
@interface CGSectionalizationView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(instancetype)initWithBlock:(CGSectionalizationViewBlock)block;
-(void)showWithEntity:(CGInfoHeadEntity *)entity;
+ (instancetype)userHeaderView;
@end
