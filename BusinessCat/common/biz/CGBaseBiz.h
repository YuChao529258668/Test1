//
//  CTBaseBiz.h
//  VieProd
//
//  Created by Calon Mo on 16/3/22.
//  Copyright © 2016年 VieProd. All rights reserved.
//  建议所有biz业务层都继承此类，进行业务和网络请求操作

#import <Foundation/Foundation.h>
#import "CTNetWorkUtil.h"

#define IntefaceRequestErrorDomain @"IntefaceRequestErrorDomain"

@interface CGBaseBiz : NSObject

/** 网络请求组件 */
@property (nonatomic, strong) CTNetWorkUtil *component;


@end
