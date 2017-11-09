//
//  CGHorrolEntity.h
//  CGSays
//
//  Created by mochenyang on 2016/9/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeadlineBiz.h"
#import "CGUserCompanyAttestationEntity.h"
#import "CGCorporateMemberEntity.h"
#import "CGDiscoverDataEntity.h"

@interface CGHorrolEntity : NSObject

@property(nonatomic,assign)int sort;//排序
@property(nonatomic,retain)NSString *rolId;
@property(nonatomic,retain)NSString *rolName;
@property (nonatomic, copy)NSString *rolType;
@property(nonatomic,retain)NSString *icon;

@property(nonatomic,retain)HeadlineBiz *biz;
@property(nonatomic,assign)long time;
@property (nonatomic, assign) NSInteger page;
@property(nonatomic,retain)NSMutableArray *data;//数据列表
@property (nonatomic, strong) CGUserCompanyAttestationEntity *entity;
@property (nonatomic, strong) CGCorporateMemberEntity *memberEntity;
@property (nonatomic, strong) CGDiscoverDataEntity *discoverEntity;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, assign) BOOL isFirst;

-(instancetype)initWithRolId:(NSString *)rolId rolName:(NSString *)rolName sort:(int)sort;

@end
