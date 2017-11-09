//
//  CGReloadView.m
//  CGSays
//
//  Created by mochenyang on 2016/10/11.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGReloadView.h"

@interface CGReloadView(){
 
    CGReloadViewBlock reloadBlock;
    
}

@end

@implementation CGReloadView

-(instancetype)initWithFrame:(CGRect)frame block:(CGReloadViewBlock)block{
    self = [super initWithFrame:frame];
    if(self){
        reloadBlock = block;
        UIButton *button = [[UIButton alloc]initWithFrame:self.bounds];
        [button setTitle:@"点击重新加载" forState:UIControlStateNormal];
        [button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

-(void)clickAction{
    if(reloadBlock){
        reloadBlock();
    }
    [self removeFromSuperview];
}

@end
