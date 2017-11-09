//
//  CTBaseBiz.m
//  VieProd
//
//  Created by Calon Mo on 16/3/22.
//  Copyright © 2016年 VieProd. All rights reserved.


#import "CGBaseBiz.h"

@interface CGBaseBiz(){
    
}

@end

@implementation CGBaseBiz


#pragma mark - GetOrSet

- (CTNetWorkUtil *)component{
    return [CTNetWorkUtil sharedManager];
}


-(void)dealloc{
    _component = nil;
//    NSLog(@"Biz->%@->%@", NSStringFromClass([self class]),  NSStringFromSelector(_cmd));
}

@end
