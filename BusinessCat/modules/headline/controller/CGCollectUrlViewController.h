//
//  CGCollectUrlViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/8/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void (^CGCollectUrlViewBlock)(NSString*text);
@interface CGCollectUrlViewController : CTBaseViewController
-(instancetype)initWithText:(NSString *)text block:(CGCollectUrlViewBlock)release;
@end
