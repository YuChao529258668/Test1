//
//  ServerInfoViewController.h
//  UltimateShow
//
//  Created by young on 16/12/18.
//  Copyright © 2016年 young. All rights reserved.
//

#import "JCBaseViewController.h"
#import "SettingManager.h"

@interface ServerInfoViewController : JCBaseViewController

//0为添加新的服务器地址  1为编辑服务器地址
@property (nonatomic, assign) NSUInteger type;

//编辑时传原来的服务器地址
@property (nonatomic, strong) ServerAddressModel *model;

@property (nonatomic, copy) void(^addServer)(NSString *server, BOOL isDefault);

@property (nonatomic, copy) void(^updateServer)(NSString *server, BOOL isDefault);
@end
