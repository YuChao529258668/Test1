//
//  classifiedSectionView.h
//  CGSays
//
//  Created by zhu on 2016/11/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^classifiedSectionViewBlock)(int selectIndex);
@interface classifiedSectionView : UIView


- (instancetype)initWithFrame:(CGRect)frame selectIndex:(classifiedSectionViewBlock)index;

- (void)setDataWithArray:(NSMutableArray *)array;

//弹出
- (void)showInView:(UIView *)view;
@end
