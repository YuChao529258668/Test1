//
//  CGAttentionEntity.h
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGAttentionEntity : NSObject
@property(nonatomic,retain)NSString *rolId;
@property(nonatomic,retain)NSString *rolName;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger type;
@property(nonatomic,retain)NSMutableArray *data;//数据列表

-(instancetype)initWithRolId:(NSString *)rolId rolName:(NSString *)rolName type:(NSInteger)type;
@end
