//
//  CGUserFireViewController.h
//  CGSays
//
//  Created by zhu on 16/10/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTBaseViewController.h"
typedef void(^CGFireSuccessBlock)(NSString *success);
@interface CGUserFireViewController : CTBaseViewController
@property (nonatomic,copy) CGFireSuccessBlock block;
- (void)didSelectedButtonIndex:(CGFireSuccessBlock)block;
@end
