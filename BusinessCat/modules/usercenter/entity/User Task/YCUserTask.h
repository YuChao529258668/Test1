//
//  YCUserTask.h
//  BusinessCat
//
//  Created by 余超 on 2018/3/16.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCUserTask : NSObject
@property (nonatomic, strong) NSString *commpanyId;
@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *parameterId;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *command;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *type;


@property (nonatomic, strong) NSString *yc_hint;

@end

//"data": {
//    "hint": "欢迎您，请完成以下操作获得更多服务",
//    "userTaskList": [
//                     {
//                         "commpanyId": "",
//                         "recordId": "",
//                         "parameterId": "",
//                         "icon": "http://pic.jp580.com/A1.png",
//                         "messageId": "",
//                         "title": "获赠特权",
//                         "type": "A1",
//                         "command": "VIPHuiYuanTeQuanGongNeng"
//                     },

