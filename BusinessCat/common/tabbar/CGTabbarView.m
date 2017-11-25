//
//  CGTabbarView.m
//  CGSays
//
//  Created by mochenyang on 2016/9/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGTabbarView.h"

@implementation CGTabbarView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame entity:(CGTabbarEntity *)entity target:(id)target{
    self = [super initWithFrame:frame];
    if(self){
        self.entity = entity;
        self.delegate = target;
        [[NSBundle mainBundle]loadNibNamed:@"CGTabbarView" owner:self options:nil];
        [self addSubview:self.view];
        
        self.image.image = [UIImage imageNamed:entity.normalImage];
        
        [self.title setTitle:entity.title forState:UIControlStateNormal];
        [self.title setTitle:entity.title forState:UIControlStateSelected];
        
        [self.title setTitleColor:[CTCommonUtil convert16BinaryColor:@"#777777"] forState:UIControlStateNormal];
//        [self.title setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
        [self.title setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabbarClickItemAction:)];
        self.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
        [self.view addGestureRecognizer:tap];
    }
    return self;
}

-(void)updateEntity:(CGTabbarEntity *)entity{
  self.entity = entity;
  self.image.image = [UIImage imageNamed:entity.normalImage];
  
  [self.title setTitle:entity.title forState:UIControlStateNormal];
  [self.title setTitle:entity.title forState:UIControlStateSelected];
}

//更新tabbar的选中状态
-(void)tabbarUpdateItemState:(BOOL)flag{
    self.entity.selected = flag;
    self.title.selected = flag;
    [self.title setTitle:self.entity.title forState:UIControlStateNormal];
    [self.title setTitle:self.entity.title forState:UIControlStateSelected];
//    UIImage *image = [UIImage imageNamed:flag?self.entity.selectedName:self.entity.normalImage];

    if (flag) {
        UIImage *image = [UIImage imageNamed:self.entity.selectedName];
//        self.image.image = [image imageWithTintColor:CTThemeMainColor];
        self.image.image = image;
    } else {
        UIImage *image = [UIImage imageNamed:self.entity.normalImage];
        self.image.image = image;
    }
}

-(void)tabbarClickItemAction:(UITapGestureRecognizer *)recognizer{
    if(self.delegate && [self.delegate respondsToSelector:@selector(tabbarSelectedItemAction:)]){
        [self.delegate tabbarSelectedItemAction:self.entity];
    }
    [self tabbarUpdateItemState:YES];
}

-(void)tabbarUpdateItemCount:(int)count{
  if (count>0&&count<=99) {
    self.count.hidden = NO;
    self.count.text = [NSString stringWithFormat:@"%d",count];
  }else if (count>99){
    self.count.hidden = NO;
    self.count.text = @"99";
  }else{
    self.count.hidden = YES;
  }
  [self.count sizeToFit];
  self.countWidth.constant = self.count.frame.size.width+8;
}

@end
