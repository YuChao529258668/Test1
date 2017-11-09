//
//  CapacityViewController.h
//  UltimateShow
//
//  Created by young on 16/12/19.
//  Copyright © 2016年 young. All rights reserved.
//

#import "JCBaseViewController.h"

@interface CapacityViewController : JCBaseViewController

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, copy) void (^capacity) (NSUInteger number);
@end
