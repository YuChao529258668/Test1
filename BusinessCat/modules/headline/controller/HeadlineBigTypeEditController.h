//
//  HeadlineBigTypeEditController.h
//  CGSays
//
//  Created by mochenyang on 2016/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void (^CGHeadlineEditBlock)(int index);
typedef void (^CGHeadlineEditCancelBlock)(NSError *error);

@interface HeadlineBigTypeEditController : CTBaseViewController{
    CGHeadlineEditBlock editBlock;
    CGHeadlineEditCancelBlock cancelBlock;
}


-(instancetype)initWithSuccess:(CGHeadlineEditBlock)success cancel:(CGHeadlineEditCancelBlock)cancel;

@end
