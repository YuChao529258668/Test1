//
//  KnowledgePackageEntity.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGRelevantInformationEntity.h"

@interface KnowledgePackageEntity : NSObject

@property(nonatomic,retain)NSString *contentId;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *tag;
@property(nonatomic,retain)NSString *icon;
@property(nonatomic,assign)int desc;
@property(nonatomic,assign)int type;
@property(nonatomic,assign)int layout;
@property(nonatomic,retain)NSString *label;
@property(nonatomic,retain)NSString *source;
@property(nonatomic,retain)NSString *address;
@property(nonatomic,assign)int discuss;
@property(nonatomic,assign)int subscribe;
@property(nonatomic,retain)NSString *prompt;
@property(nonatomic,assign)long createtime;
@property(nonatomic,retain)NSString *navType;
@property(nonatomic,retain)NSString *navColor;
@property(nonatomic,assign)int isSubscribe;
@property(nonatomic,assign)int isFollow;
@property(nonatomic,retain)NSMutableArray<CGRelevantInformationEntity *> *relevant;

@property(nonatomic,retain)NSMutableArray *imglist;

@end
