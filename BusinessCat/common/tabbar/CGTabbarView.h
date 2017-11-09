//
//  CGTabbarView.h
//  CGSays
//
//  Created by mochenyang on 2016/9/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGTabbarEntity.h"

@protocol CTTabBarViewDelegate <NSObject>

//点击tabitem事件
- (void)tabbarSelectedItemAction:(CGTabbarEntity *)selectedEntity;

@end


@interface CGTabbarView : UIView
@property(nonatomic,weak)IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *title;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countWidth;

@property(nonatomic,retain)CGTabbarEntity *entity;

@property(nonatomic,retain)id<CTTabBarViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame entity:(CGTabbarEntity *)entity target:(id)target;

//更新tabbar的选中状态
-(void)tabbarUpdateItemState:(BOOL)flag;

-(void)tabbarUpdateItemCount:(int)count;
@end
