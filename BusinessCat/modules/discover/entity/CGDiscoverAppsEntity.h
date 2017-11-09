//
//  CGDiscoverAppsEntity.h
//  CGSays
//
//  Created by zhu on 16/11/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGDiscoverAppsEntity : NSObject
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, assign) NSInteger groupSort;
@property (nonatomic, strong) NSMutableArray *gropuApps;
@end

@interface CGGropuAppsEntity : NSObject
@property (nonatomic, copy) NSString *appsID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;//H5路径
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) NSInteger webpage;//是否为H5
@property(nonatomic,assign)int indexSort;//排序
@property (nonatomic, assign) NSInteger permission;
@property (nonatomic, assign) NSInteger permissionShow;
@property (nonatomic, assign) NSInteger activation;
@property (nonatomic, copy) NSString *viewPrompt;
@property (nonatomic, assign) NSInteger viewPermit;
@end
