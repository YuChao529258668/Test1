//
//  CGUserHelpCatePageEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserHelpCatePageEntity : NSObject
@property (nonatomic, copy) NSString *pageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger createTime;
@end
