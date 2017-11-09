//
//  KnowledgeBaseEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnowledgeBaseEntity : NSObject
@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *fonticon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) NSInteger catePage;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, copy) NSString *navType;
@property (nonatomic, assign) NSInteger viewPermit;
@property (nonatomic, copy) NSString *viewPrompt;
@property (nonatomic, assign) NSInteger integral;
@end

@interface ListEntity : NSObject
@property (nonatomic, copy) NSString *listID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger catePage;
@end

@interface  NavsEntity: NSObject
@property (nonatomic, copy) NSString *navsID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger catePage;
@property (nonatomic, assign) NSInteger isSelect;
@end
