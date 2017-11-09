//
//  AttentionHeaderCell.h
//  CGSays
//
//  Created by zhu on 2017/3/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (void)updateWithArray:(NSMutableArray *)array;
@end
