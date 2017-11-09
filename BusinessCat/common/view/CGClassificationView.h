//
//  CGClassificationView.h
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CGClassificationViewBlock)(NSString *navTypeId,NSString *name,NSInteger index,NSInteger secondaryIndex);
typedef void (^CGClassificationCloseViewBlock)();
@interface CGClassificationView : UIView
-(instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)array index:(NSInteger)index secondaryIndex:(NSInteger)secondaryIndex block:(CGClassificationViewBlock)block closeBlock:(CGClassificationCloseViewBlock)closeBlock;
-(void)close;
@end
