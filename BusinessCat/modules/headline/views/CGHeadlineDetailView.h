//
//  CGHeadlineDetailView.h
//  CGSays
//
//  Created by zhu on 2017/3/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CGHeadlineDetailViewDelegate <NSObject>

-(void)headerDidSelectButtonWithIndex:(NSInteger)index;

@end

@interface CGHeadlineDetailView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,weak)id<CGHeadlineDetailViewDelegate> delegate;
+ (instancetype)userHeaderView;
+ (float)height;
- (void)updateData:(NSMutableArray *)array;
@end
