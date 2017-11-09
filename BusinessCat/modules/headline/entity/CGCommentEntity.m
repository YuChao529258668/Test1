//
//  CGCommentEntity.m
//  CGSays
//
//  Created by mochenyang on 2016/10/12.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGCommentEntity.h"

@implementation CGCommentEntity


-(CGCommentReplyEntity *)replyData{
    if(!_replyData){
        _replyData = [[CGCommentReplyEntity alloc]init];
    }
    return _replyData;
}

@end
