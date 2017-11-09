//
//  TeamCircleLastStateEntity.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/6/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//  企业圈互动信息实体

#import <Foundation/Foundation.h>
#import "TeamCircleBadgeState.h"
#import "TeamCircleCompanyState.h"

@interface TeamCircleLastStateEntity : NSObject

@property(nonatomic,retain)TeamCircleBadgeState *badge;
@property(nonatomic,assign)int count;
@property(nonatomic,retain)NSMutableArray *list;
@property(nonatomic,assign)int systemMsgCount;//系统消息未读数



+(BOOL)saveToLocal:(TeamCircleLastStateEntity *)entity;

+(TeamCircleLastStateEntity *)getFromLocal;

-(TeamCircleCompanyState *)getCompanyStateById:(NSString *)companyId companyType:(int)companyType;

@end
