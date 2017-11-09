//
//  CGBigdataEntity.h
//  CGSays
//
//  Created by zhu on 2017/3/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGBigdataEntity : NSObject
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *cateList;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@interface cate : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *fonticon;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger type;
@end
