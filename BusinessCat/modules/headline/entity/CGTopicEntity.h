//
//  CGTopicEntity.h
//  CGSays
//
//  Created by mochenyang on 2016/10/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条话题model

#import <Foundation/Foundation.h>

@interface CGTopicEntity : NSObject
@property (nonatomic, strong) NSString * topicId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * portrait;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, assign) NSInteger isPraise;
@property (nonatomic, assign) int count;//公司讨论数
@property (nonatomic, assign) int discuss;//评论数
@property (nonatomic, strong) NSString * commentId;//第一条评论id
@property (nonatomic, strong) NSString * content;//话题的内容(第一条评论的内容)
@property (nonatomic, assign) int isCollection;//是否收藏
@property (nonatomic, assign) int jing;//右上角的数量
@end
