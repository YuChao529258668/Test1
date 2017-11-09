//
//  CGUserHelpCateListEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserHelpCateListEntity : NSObject
@property (nonatomic, copy) NSString *pageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *fonticon;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, assign) NSInteger pageCount;
@end
