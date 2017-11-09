//
//  CGCorporateMemberEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCorporateMemberEntity : NSObject
@property (nonatomic, assign) int isVip;
@property (nonatomic, assign) int vipDays;
@property (nonatomic, copy) NSString *vipTime;
@property(nonatomic,retain)NSString *gradeId;
@property(nonatomic,retain)NSString *gradeName;

@property (nonatomic, strong) NSMutableArray *privilegeTitle;
@property (nonatomic, strong) NSMutableArray *privilegeList;
@end


@interface CGPrivilegeTitle : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *icon;
@end

@interface CGPrivilegeList : NSObject
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) int sort;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *fonticon;
@property (nonatomic, strong) NSMutableArray *list;
@end

@interface CGListEntity : NSObject
@property(nonatomic,retain)NSString *gradesId;
@property (nonatomic, copy) NSString *color;
@property(nonatomic,assign)int isButtom;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *fonticon;
@property (nonatomic, copy) NSString *info;
@end
