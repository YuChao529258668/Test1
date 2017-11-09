//
//  PreviewReformer.h
//  UltimateShow
//
//  Created by young on 17/3/27.
//  Copyright © 2017年 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JCApi/JCApi.h>

@class JCVideoDisplayView;

@interface JCPreviewReformer : NSObject <JCEngineDelegate>

- (void)bindPreview:(JCVideoDisplayView *)view;
- (void)bindNameLabel:(UILabel *)label;

- (void)reloadWithUserId:(NSString *)userId;

- (void)stop;

@end
