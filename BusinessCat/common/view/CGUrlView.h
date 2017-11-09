//
//  CGUrlView.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/2.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGDiscoverReleaseSourceViewController.h"

typedef void (^CGUrlViewBlock)(NSString *title,NSString *icon);
@interface CGUrlView : UIView
@property (nonatomic, copy) NSString *url;
- (instancetype)initWithUrl:(NSString *)url block:(CGUrlViewBlock)block;
- (void)dismiss;
@end
