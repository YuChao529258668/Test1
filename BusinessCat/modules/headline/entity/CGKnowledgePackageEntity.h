//
//  CGKnowledgePackageEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/5.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGKnowledgePackageEntity : NSObject
@property (nonatomic, assign) NSInteger isFollow;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger showType;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, assign) NSInteger viewPermit;
@property (nonatomic, copy) NSString *viewPrompt;
@property (nonatomic, strong) NSMutableArray *list;
@end

