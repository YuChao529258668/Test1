//
//  TeamCircleMessageModel.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/6/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamCircleMessageModel : NSObject

@property(nonatomic,retain)NSString *userId;
@property(nonatomic,retain)NSString *userName;
@property(nonatomic,retain)NSString *portrait;
@property(nonatomic,assign)int relationType;
@property(nonatomic,retain)NSString *relationContent;
@property(nonatomic,retain)NSString *relationId;
@property(nonatomic,retain)NSString *scoopId;
@property(nonatomic,retain)NSString *scoopCover;
@property(nonatomic,retain)NSString *scoopContent;
@property(nonatomic,assign)long createTime;

@end
