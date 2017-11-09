//
//  CGUserChoseTimeViewController.h
//  CGSays
//
//  Created by zhu on 16/11/4.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGUserorganizaApplyEntity.h"

typedef void (^CGUserChoseTimeBlock)(NSString *result);
@interface CGUserChoseTimeViewController : CTBaseViewController{
  CGUserChoseTimeBlock resultBlock;
}
-(instancetype)initWithBlock:(CGUserChoseTimeBlock)block;
@property (nonatomic, strong) CGUserorganizaApplyEntity *info;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isDiscover;
@end
