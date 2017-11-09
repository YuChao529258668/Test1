//
//  CGReloadView.h
//  CGSays
//
//  Created by mochenyang on 2016/10/11.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  网络或其他错误需要点击加载的控件

#import <UIKit/UIKit.h>
typedef void (^CGReloadViewBlock)(void);

@interface CGReloadView : UIView{
    
}

//初始化，使用block回调供外部进行相关的下一步操作
-(instancetype)initWithFrame:(CGRect)frame block:(CGReloadViewBlock)block;

@end
