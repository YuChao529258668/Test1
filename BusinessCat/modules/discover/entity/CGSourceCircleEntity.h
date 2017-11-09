//
//  CGSourceCircleEntity.h
//  CGSays
//
//  Created by zhu on 16/10/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGSourceCircleEntity : NSObject
@property (nonatomic, copy) NSString *scoopID;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger feedbackType;//意见反馈
@property (nonatomic, assign) NSInteger scoopType;//企业圈
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger visibility;
@property (nonatomic, copy) NSString *linkIcon;
@property (nonatomic, copy) NSString *linkId;
@property (nonatomic, copy) NSString *linkTitle;
@property (nonatomic, assign) NSInteger linkType;
@property (nonatomic, strong) NSMutableArray *imgList;
@property (nonatomic, strong) NSMutableArray *praise;
@property (nonatomic, assign) long time;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableArray *payList;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger isPraise;//是否点赞
@property (nonatomic, assign) NSInteger isPay;//是否已赞赏
//自定义参数
@property (nonatomic, assign) BOOL isSearch;//是否是搜索界面
@property (nonatomic, assign) BOOL isFeedback;//是否意见反馈
@property (nonatomic, copy) NSString *imageListJsonStr;
@property (nonatomic, copy) NSString *praiseJsonStr;
@property (nonatomic, copy) NSString *commentJsonStr;
@property (nonatomic, copy) NSString *payJsonStr;
@end

@interface  SourceCircImgList: NSObject
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *src;
@end

@interface SourceCircPraise: NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *nickname;
@end

@class SourceCircReply;
@interface SourceCircComments : NSObject
@property (nonatomic, assign) int commentType;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) SourceCircReply *reply;
@property (nonatomic, copy) NSString *replyJsonStr;
@end

@interface SourceCircReply : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;
@end

@interface SourcePay : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *portrait;
@end
