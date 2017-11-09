//
//  HeadLineDelConfirmView.h
//  CGSays
//
//  Created by mochenyang on 2016/10/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条隐藏不感兴趣内容弹出的确认框

#import <UIKit/UIKit.h>

typedef void (^CGHeadlineDelBlock)(int closeType);
typedef void (^CGHeadlineCancelBlock)(void);

//显示箭头的位置
typedef enum HeadlineColseShowPosition {
    HeadlineColseShowPositionCenter  = 0,
    HeadlineColseShowPositionRight
} HeadlineColseShowPosition;

@interface HeadLineDelConfirmView : UIView{
    
}

//初始化 x:弹出的开始位置x y:弹出的开始位置y
-(instancetype)initWithX:(float)x y:(float)y del:(CGHeadlineDelBlock)del cancel:(CGHeadlineCancelBlock)cancel;

//弹出
-(void)showInView:(UIView *)view position:(HeadlineColseShowPosition)position y:(float)y;

@end
