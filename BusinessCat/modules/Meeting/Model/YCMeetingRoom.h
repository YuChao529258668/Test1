//
//  YCMeetingRoom.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCMeetingRoom : NSObject

@property (nonatomic,assign) int commonality; // 是否公共 1是0否
@property (nonatomic,strong) NSString *companyid;
@property (nonatomic,assign) float costvideo;
@property (nonatomic,assign) float costvoice;
//@property (nonatomic,strong) NSString *createtime;
@property (nonatomic,strong) NSString *freetime; // 可用时长，分钟
@property (nonatomic,assign) int roomDefault;
@property (nonatomic,strong) NSString *roomHint;
@property (nonatomic,assign) int roomcharge; // 费用(0免费1付费2包月)
@property (nonatomic,strong) NSString *roomid;
@property (nonatomic,strong) NSString *roomname;
@property (nonatomic,assign) int roomnum;//可用人数
@property (nonatomic,assign) int state;
@property (nonatomic,assign) NSTimeInterval timeb;
@property (nonatomic,assign) NSTimeInterval timee;

//
//commonality                                  1;
//companyid                                  "<null>";
//costvideo                                  0;
//costvoice                                  0;
//createtime                                  "<null>";
//freetime                                  120;
//roomDefault                                  0;
//roomHint
//roomcharge                                  0;
//roomid                                  "3a4c71eb-13e8-40fb-ae41-755bf67126d5";
//roomname                                  "30\U4eba\U4f1a\U8bae\U5ba4";
//roomnum                                  30;
//state                                  1;
//timeb                                  1509512400000;
//timee                                  1512107999000;

- (float)videoRoomPrice;
// 免费/包月会议室时：直接显示为免费
- (float)voiceRoomPrice;

@end
