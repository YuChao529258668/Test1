//
//  CGGradesPackageEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGGradesPackageEntity : NSObject
@property (nonatomic, copy) NSString *packageId;
@property (nonatomic, copy) NSString *packageTitle;
@property (nonatomic, assign) NSInteger packagePrice;
@property (nonatomic, copy) NSString *packageDesc;
@property (nonatomic, copy) NSString *iOSProductId;
@property (nonatomic, assign) NSInteger iosPrice;
@property (nonatomic, strong) NSString *iosTitle; // getter：为空则返回 packageTitle

@end
