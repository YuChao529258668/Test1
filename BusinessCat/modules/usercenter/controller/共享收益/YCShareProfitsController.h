//
//  YCShareProfitsController.h
//  BusinessCat
//
//  Created by 余超 on 2018/2/10.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCShareProfitsController : UIViewController
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *companyID;
@property (nonatomic,copy) void (^onJoinSuccessBlock)();

@end
