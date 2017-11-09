//
//  ScreenShareReformer.h
//  UltimateShow
//
//  Created by Nathan Zheng on 2017/3/24.
//  Copyright © 2017年 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JCScreenShareProtocol.h"

@interface JCScreenShareReformer : NSObject

@property (nonatomic, weak) id<JCScreenShareDelegate> delegate;

- (void)bindRenderView:(UIView *)view;
- (void)bindNameLabel:(UILabel *)label;

- (void)reload;

- (void)stop;

@end
