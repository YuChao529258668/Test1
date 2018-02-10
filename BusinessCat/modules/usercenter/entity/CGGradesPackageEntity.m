//
//  CGGradesPackageEntity.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGGradesPackageEntity.h"

@implementation CGGradesPackageEntity
- (NSString *)iosTitle {
    if (_iosTitle) {
        return _iosTitle;
    } else {
        return _packageTitle;
    }
}
@end
