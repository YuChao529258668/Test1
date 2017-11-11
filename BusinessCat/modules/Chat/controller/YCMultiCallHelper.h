//
//  YCMultiCallHelper.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCMultiCallHelper : NSObject

// 多人语音通话控制器
//@property (nonatomic,strong,readonly) UIViewController *multiCallViewController; // weak 可以吗？strong 要在不用时设置为 nil
@property (nonatomic,weak,readonly) UIViewController *multiCallViewController; // weak 可以吗？

// 设置多人语音通话控制器，记得不用时再设置一次 nil，释放资源
+ (void)setMultiCallViewController:(UIViewController *)multiCallVC;

@end
