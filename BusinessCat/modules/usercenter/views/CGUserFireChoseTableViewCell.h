//
//  CGUserFireChoseTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtomClickBlock)(NSInteger index);
@interface CGUserFireChoseTableViewCell : UITableViewCell

- (void)getRelatedWithData:(NSArray *)array;
+ (float)height:(NSArray *)array;
@property (nonatomic,copy) ButtomClickBlock buttonBlock;
@end
