//
//  YCMeetingRoom.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingRoom.h"

@implementation YCMeetingRoom


//@property (nonatomic,assign) int commonality; // 是否公共 1是0否
//@property (nonatomic,strong) NSString *companyid;
//@property (nonatomic,assign) float costvideo;
//@property (nonatomic,assign) float costvoice;
////@property (nonatomic,strong) NSString *createtime;
//@property (nonatomic,strong) NSString *freetime; // 可用时长，分钟
//@property (nonatomic,assign) int roomDefault;
//@property (nonatomic,strong) NSString *roomHint;
//@property (nonatomic,assign) int roomcharge; // 费用(0免费1付费2包月)
//@property (nonatomic,strong) NSString *roomid;
//@property (nonatomic,strong) NSString *roomname;
//@property (nonatomic,strong) NSString *roomnum;//可用人数
////@property (nonatomic,strong) NSString *state;
//@property (nonatomic,assign) NSTimeInterval timeb;
//@property (nonatomic,assign) NSTimeInterval timee;

//收费会议室：按会议类型+参会人数+时长进行计算费用
// 免费/包月会议室时：直接显示为免费
- (float)videoRoomPrice {
    if (self.roomcharge == 0 || self.roomcharge == 2) {
        return 0;
    }
    return self.costvideo * self.roomnum;
}

// 免费/包月会议室时：直接显示为免费
- (float)voiceRoomPrice {
    if (self.roomcharge == 0 || self.roomcharge == 2) {
        return 0;
    }
    return self.costvoice * self.roomnum;
}

@end
