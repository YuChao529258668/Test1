//
//  CGSearchSourceCircleEntity.h
//  CGSays
//
//  Created by zhu on 2016/11/24.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGSearchSourceCircleEntity : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *linkIcon;
@property (nonatomic, copy) NSString *linkId;
@property (nonatomic, copy) NSString *linkTitle;
@property (nonatomic, assign) NSInteger linkType;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, assign) NSInteger replyNum;
@end

@interface  SearchSourceCircImgList: NSObject
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *src;
@end
