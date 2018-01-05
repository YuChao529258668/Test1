//
//  CGInfoDetailEntity.m
//  CGSays
//
//  Created by mochenyang on 2016/10/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGInfoDetailEntity.h"

@implementation CGInfoDetailEntity

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"infoId":@"id"};
}

- (NSMutableArray<NSString *> *)getYCImageURLs {
    NSArray *imageNames = [self.pageName componentsSeparatedByString:@","];
    NSString *preStr = [self.infoPic stringByReplacingOccurrencesOfString:imageNames.firstObject withString:@""];
    NSMutableArray *imageURLs = [NSMutableArray arrayWithCapacity:imageNames.count];
    for (NSString *name in imageNames) {
        [imageURLs addObject:[NSString stringWithFormat:@"%@%@", preStr, name]];
    }
    return imageURLs;
}

@end

@implementation CGAppListEntity

@end
