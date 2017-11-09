//
//  CGTopicMainViewController.h
//  CGSays
//
//  Created by mochenyang on 2016/9/29.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGTopicToolBar.h"
#import "CGInfoDetailEntity.h"
#import <MJRefresh.h>
#import "CGInfoHeadEntity.h"

@interface CGTopicMainViewController : CTBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet CGTopicToolBar *toolbar;
@property(nonatomic,retain)CGInfoDetailEntity *detail;
@property (nonatomic, strong) CGInfoHeadEntity *info;
-(instancetype)initWithDetail:(CGInfoDetailEntity *)detail;

@end
