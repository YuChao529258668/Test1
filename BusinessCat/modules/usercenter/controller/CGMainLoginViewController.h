//
//  CGMainLoginViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/2.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void (^CGLoginSuccessBlock)(CGUserEntity *user);
typedef void (^CGLoginCancelBlock)(NSError *error);
@interface CGMainLoginViewController : CTBaseViewController

-(instancetype)initWithBlock:(CGLoginSuccessBlock)success fail:(CGLoginCancelBlock)fail;

@property (nonatomic, assign) BOOL shouldHideNavi;

@end
