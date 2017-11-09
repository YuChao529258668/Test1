//
//  CGCopyrightTipsView.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoDetailEntity.h"

typedef void (^CGCopyrightTipsBlock)(NSString *url);
@interface CGCopyrightTipsView : UIView
- (instancetype)initWithInfo:(CGInfoDetailEntity *)info block:(CGCopyrightTipsBlock)block;
-(void)dismiss;
@end
