//
//  MtcDocDelegate.h
//  JusDoc
//
//  Created by Fiona on 1/14/16.
//  Copyright © 2016 juphoon. All rights reserved.
//

#ifndef JusDocManager_h
#define JusDocManager_h

#import <Foundation/Foundation.h>
#import <JusDoc/JusDoc.h>

@protocol JusDocDelegate

- (void)didCreate;
- (void)requestToStart:(NSString *)docUri;
- (void)requestToStop;

@end

@interface JusDocManager : NSObject

+ (void)init;

+ (void)setDelegate:(id<JusDocDelegate>)delegate;

//用于全屏显示
+ (void)start:(NSString *)docUri;

//用于添加到其他 view 的时候来显示，需要传入对应 view 的 size
+ (UIViewController *)start:(NSString *)docUri displayViewSize:(CGSize)size;

+ (void)stop;

@end

#endif // JusDocManager_h
