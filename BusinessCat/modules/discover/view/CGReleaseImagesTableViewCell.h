//
//  CGReleaseImagesTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGDiscoverLink.h"

typedef void (^ClickAtIndexBlock)(NSInteger index,BOOL isAddButton);
@interface CGReleaseImagesTableViewCell : UITableViewCell
- (void)updateImagesUIWithArray:(NSMutableArray *)array;

- (void)updateLinkWithLinkInfo:(CGDiscoverLink *)link;
@property (strong, nonatomic) ClickAtIndexBlock block;
- (void)didSelectedButtonIndex:(ClickAtIndexBlock)block;
@property (nonatomic, assign) float heigth;
@end
