//
//  KnowledgeAlbumEntity.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "KnowledgeAlbumEntity.h"

@implementation KnowledgeAlbumEntity

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"groupList":[KnowledgeHeaderEntity class]};
}


@end
