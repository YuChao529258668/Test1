//
//  SplitScreenReformer.h
//  UltimateShow
//
//  Created by young on 17/3/20.
//  Copyright © 2017年 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JCApi/JCApi.h>
#import "JCSplitScreenView.h"

@interface JCSplitScreenReformer : NSObject <JCEngineDelegate, SplitScreenViewDataSource>

- (NSString *)getUserId:(NSInteger)index;

- (void)bindSplitScreenView:(JCSplitScreenView *)view;

//刷新分屏
- (void)reload;

//刷新分屏
- (void)stop;

@end
