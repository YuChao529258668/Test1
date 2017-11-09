//
//  CGCommentView.h
//  CGSays
//
//  Created by mochenyang on 2016/10/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  统一封装的评论控件

#import <UIKit/UIKit.h>

typedef void (^CGCommentFinishInputBlock)(NSString *data);
typedef void (^CGCommentCancelBlock)(NSString *data);

@interface CGCommentView : UIView<UITextViewDelegate>{
    
}

//初始化，使用block的方式，把输入内容返回给外部
-(instancetype)initWithContent:(NSString *)content placeholder:(NSString *)placeholder finish:(CGCommentFinishInputBlock)finish cancel:(CGCommentCancelBlock)cancel;

//弹出控件
-(void)showInView:(UIView *)view;

@end
