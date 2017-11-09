//
//  CGCommentEntity.h
//  CGSays
//
//  Created by mochenyang on 2016/10/12.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条评论model

#import <Foundation/Foundation.h>
#import "CGCommentReplyEntity.h"

@interface CGCommentEntity : NSObject
@property (nonatomic, strong) NSString * commentId;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) int isPraise;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * portrait;
@property (nonatomic, assign) int praiseNum;
@property (nonatomic, strong) CGCommentReplyEntity * replyData;
@property (nonatomic, assign) int replyNum;
@property (nonatomic, assign) long time;
@property (nonatomic, strong) NSString * toCommentId;
@property (nonatomic, strong) NSString * uid;
@property(nonatomic,retain)NSString *topicId;
@property (nonatomic, assign) NSInteger type;

//以下非接口返回的参数
@property(nonatomic,retain)NSString *infoId;

@end


