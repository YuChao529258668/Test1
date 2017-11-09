//
//  CGUserHelpCateEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserHelpCateEntity : NSObject
@property (nonatomic, copy) NSString *cateId;
@property (nonatomic, copy) NSString *cateTitle;
@property (nonatomic, copy) NSString *cateIcon;
@property (nonatomic, copy) NSString *cateFontIcon;
@property (nonatomic, copy) NSString *cateColor;
@property (nonatomic, assign) NSInteger createTime;
@end
