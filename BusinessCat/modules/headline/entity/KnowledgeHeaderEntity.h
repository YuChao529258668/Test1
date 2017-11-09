//
//  KnowledgeHeaderEntity.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//  知识餐列表实体

#import <Foundation/Foundation.h>

@interface KnowledgeHeaderEntity : NSObject

@property(nonatomic,retain)NSString *packageId;//套餐id
@property(nonatomic,retain)NSString *packageTip;
@property(nonatomic,retain)NSString *mainId;//套餐id
@property(nonatomic,retain)NSString *packageTitle;//标题
@property(nonatomic,retain)NSString *packageCover;//封面
@property(nonatomic,retain)NSString *packageNode;//套餐节点
@property(nonatomic,retain)NSString *packageGrade;//等级权限
@property(nonatomic,assign)int onlyVip;//0公共 1只会员
@property(nonatomic,assign)int gobalBuyer;//是否有权限
@property(nonatomic,assign)int groupType;
@property(nonatomic,assign)int packageType;
@property(nonatomic,assign)int readNum;//阅读数
@property(nonatomic,assign)int infoNum;//资讯数
@property(nonatomic,assign)long startTime;//开始时间
@property (nonatomic, copy) NSString *organizaName;//组织名字
@property (nonatomic, copy) NSString *organizaId;//组织id
@property (nonatomic, assign) NSInteger isIcon;
@property (nonatomic, assign) NSInteger createtime;
@end
