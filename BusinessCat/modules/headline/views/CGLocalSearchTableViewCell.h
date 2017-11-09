//
//  CGLocalSearchTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/30.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CGLocalSearchTableBlock)(NSInteger index);
@interface CGLocalSearchTableViewCell : UITableViewCell
-(void)update:(NSMutableArray *)array;
-(void)block:(CGLocalSearchTableBlock)block;
@property (nonatomic, assign) CGFloat height;
@end
