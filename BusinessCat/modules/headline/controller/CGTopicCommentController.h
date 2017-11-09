//
//  CGTopicCommentController.h
//  CGSays
//
//  Created by mochenyang on 2016/10/13.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGCommentEntity.h"
#import "CGInfoDetailEntity.h"

@interface CGTopicCommentController : CTBaseViewController

-(instancetype)initWithComment:(CGCommentEntity *)comment detail:(CGInfoDetailEntity *)detail showCommentView:(BOOL)showCommentView;

@end
