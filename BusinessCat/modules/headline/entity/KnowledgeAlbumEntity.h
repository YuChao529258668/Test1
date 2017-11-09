//
//  KnowledgeAlbumEntity.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KnowledgeHeaderEntity.h"

@interface KnowledgeAlbumEntity : NSObject

@property(nonatomic,assign)int groupType;
@property(nonatomic,retain)NSString *groupName;
@property(nonatomic,assign)long groupTime;
@property(nonatomic,assign)int isVip;
@property(nonatomic,retain)NSMutableArray<KnowledgeHeaderEntity *> *groupList;

@end
