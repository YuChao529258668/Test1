//
//  CGNavTypeSelector.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGNavTypeSelector.h"

#define CellHeight 50

@interface CGNavTypeSelector()

@property(nonatomic,copy)CGNavTypeSelectorBlock block;
@property(nonatomic,copy)CGNavTypeSelectorCancel cancel;

@property(nonatomic,retain)UIScrollView *whiteView;

@property(nonatomic,retain)NSMutableArray *dataArray;

@end

@implementation CGNavTypeSelector

-(instancetype)initWithFrame:(CGRect)frame showAtY:(float)showAtY dataArray:(NSMutableArray *)dataArray block:(CGNavTypeSelectorBlock)block cancel:(CGNavTypeSelectorCancel)cancel{
    self = [super initWithFrame:frame];
    if(self){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackgroundToCancel)];
        [self addGestureRecognizer:tap];
        self.block = block;
        self.cancel = cancel;
        self.dataArray = dataArray;
        float height = 0;
        if((dataArray.count * CellHeight) >= frame.size.height *3/4){
            height = frame.size.height*3/4;
        }else{
            height = CellHeight * dataArray.count;
        }
        self.whiteView = [[UIScrollView alloc]initWithFrame:CGRectMake(frame.size.width/2-SCREEN_WIDTH/2/2, showAtY, SCREEN_WIDTH/2, 0)];
        [self.whiteView setShowsVerticalScrollIndicator:NO];
        self.whiteView.clipsToBounds = YES;
        self.whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteView];
        self.whiteView.contentSize = CGSizeMake(0, CellHeight * dataArray.count);
        
        for(int i=0;i<self.dataArray.count;i++){
            CGHorrolEntity *item = dataArray[i];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, CellHeight *i, self.whiteView.frame.size.width, CellHeight)];
            [button addTarget:self action:@selector(clickItemAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            button.layer.borderColor = CTCommonLineBg.CGColor;
            button.layer.borderWidth = 0.5;
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitle:item.rolName forState:UIControlStateNormal];
            [self.whiteView addSubview:button];
        }
        
        
        __weak typeof(self) weakSelf = self;
        CGRect whiteRect = self.whiteView.frame;
        whiteRect.size.height = height;
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8
              initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                  weakSelf.whiteView.frame = whiteRect;
                  weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
              }completion:^(BOOL finished) {
                  
              }];
    }
    return self;
}

-(void)clickItemAction:(UIButton *)button{
    CGHorrolEntity *item = self.dataArray[button.tag];
    if(self.block){
        self.block(item);
    }
    [self close];
}

-(void)clickBackgroundToCancel{
    if(self.cancel){
        self.cancel();
    }
    [self close];
}

-(void)close{
    __weak typeof(self) weakSelf = self;
    CGRect whiteRect = self.whiteView.frame;
    whiteRect.size.height = 0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
              weakSelf.whiteView.frame = whiteRect;
              weakSelf.alpha = 0;
          }completion:^(BOOL finished) {
              [weakSelf removeFromSuperview];
          }];
}

@end
