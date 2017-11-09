//
//  KnowledgePackageEntity.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "KnowledgePackageEntity.h"

@implementation KnowledgePackageEntity

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"contentId":@"id"};
}

@end
