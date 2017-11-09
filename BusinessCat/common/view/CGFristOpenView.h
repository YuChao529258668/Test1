//
//  CGFristOpenView.h
//  CGSays
//
//  Created by zhu on 2017/1/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CGFristOpenViewBlock)(void);
@interface CGFristOpenView : UIView
-(instancetype)initWithBlock:(CGFristOpenViewBlock)block;
@end
