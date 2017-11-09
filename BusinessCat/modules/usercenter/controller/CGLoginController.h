//
//  CGLoginController.h
//  CGSays
//
//  Created by mochenyang on 2016/10/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGFristOpenView.h"
#import "CGUserFireViewController.h"

typedef void (^CGLoginSuccessBlock)(CGUserEntity *user);
typedef void (^CGLoginCancelBlock)(NSError *error);

@interface CGLoginController : CTBaseViewController
@property (nonatomic, assign) NSInteger isChangePhone;//修改手机
-(instancetype)initWithBlock:(CGLoginSuccessBlock)success fail:(CGLoginCancelBlock)fail;

@end
