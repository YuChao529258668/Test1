//
//  ZbarController.h
//  Coyoo
//
//  Created by Calon Mo on 16/5/9.
//  Copyright © 2016年 Coyoo. All rights reserved.
//

#import "CTBaseViewController.h"

typedef void (^ZbarControllerBlock)(NSString *data);
typedef void (^ZbarControllerCancelBlock)(void);

@interface ZbarController : CTBaseViewController{
    ZbarControllerBlock scanBlock;
    ZbarControllerCancelBlock cancelBlock;
}

-(id)initWithBlock:(ZbarControllerBlock)block cancel:(ZbarControllerCancelBlock)cancel;//登陆界面调用此函数初始化
@end
