//
//  DiscoverPushView.h
//  CGSays
//
//  Created by zhu on 16/11/7.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DiscoverPushBlock)(int selectIndex);
typedef void (^DiscoverPushCancelBlock)(void);
@interface DiscoverPushView : UIView
@property (nonatomic, strong) UIView *grayView;;
//初始化 x:弹出的开始位置x y:弹出的开始位置y
-(instancetype)initWithFrame:(CGRect)frame title1:(NSString *)title1 title2:(NSString *)title2 selectIndex:(DiscoverPushBlock)index cancel:(DiscoverPushCancelBlock)cancel;

//弹出
-(void)showInView:(UIView *)view frame:(CGRect)frame;

-(void)closeMySelf;
@end
