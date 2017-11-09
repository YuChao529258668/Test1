//
//  CGUserStatistics.h
//  CGSays
//
//  Created by mochenyang on 2016/10/11.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  用户的相关统计信息

#import <Foundation/Foundation.h>

@interface CGUserStatistics : NSObject

@property(nonatomic,assign)int integralNum;//积分
@property(nonatomic,assign)int subjectNum;//主题数
@property(nonatomic,assign)int subscribeNum;//关注数
@property(nonatomic,assign)int advicesNum;//爆料数
@property(nonatomic,assign)int shareNum;//分享数
@property(nonatomic,assign)int fansNum;//粉丝数
@property(nonatomic,assign)int expNum;//体验数
@property(nonatomic,assign)int browseNum;//浏览数

@end
