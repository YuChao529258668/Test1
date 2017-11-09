//
//  CGAttentionMyGroupViewController.h
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void (^CGAttentionMyGroupViewBlock)(BOOL cancelRed);
@interface CGAttentionMyGroupViewController : CTBaseViewController
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, assign) NSInteger type;
-(instancetype)initWithBlock:(CGAttentionMyGroupViewBlock)cancel;
@end
