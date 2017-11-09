//
//  ScreenShare.h
//  UltimateShow
//
//  Created by young on 17/3/27.
//  Copyright © 2017年 young. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JCScreenShareDelegate <NSObject>

- (void)screenShareStart;
- (void)screenShareStop;

@end
