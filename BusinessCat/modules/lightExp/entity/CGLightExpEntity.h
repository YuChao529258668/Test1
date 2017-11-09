//
//  CGLightExpEntity.h
//  CGSays
//
//  Created by zhu on 2016/11/30.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGLightExpEntity : NSObject
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *gName;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger update;
@property (nonatomic, strong) NSMutableArray *apps;
@property (nonatomic, assign) NSInteger isExp;
@property (nonatomic, copy) NSString *appsJsonStr;
@property (nonatomic, assign) NSInteger time;
@end

@interface CGApps : NSObject
@property (nonatomic, assign) int time;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *pName;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, assign) int sotr;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) int update;
@property (nonatomic, assign) int isExp;
@property (nonatomic, assign) int count;
//自定义参数
@property (nonatomic, assign) BOOL isAdd;//是否是添加按钮
@end
