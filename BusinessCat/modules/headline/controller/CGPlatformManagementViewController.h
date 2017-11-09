//
//  CGPlatformManagementViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void (^CGPlatformManagementBlock)(NSString *success);
@interface CGPlatformManagementViewController : CTBaseViewController
//type 0 知识校正 1素材校正 2文库校正
-(instancetype)initWithInfoId:(NSString *)infoId type:(NSInteger)type array:(NSMutableArray *)array time:(NSInteger)time block:(CGPlatformManagementBlock)block;
@end
