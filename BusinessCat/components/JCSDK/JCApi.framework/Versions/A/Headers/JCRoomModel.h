//
//  JCRoomModel.h
//  JCApi
//
//  Created by 沈世达 on 17/5/9.
//  Copyright © 2017年 young. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCParticipantModel;

typedef NS_ENUM(NSInteger, JCRoomMode) {
    JCRoomModeHost = 0,  //主持人控制
    JCRoomModeFree       //自由
};

@interface JCRoomModel : NSObject

@property (nonatomic, readonly, copy) NSString *roomId;    //会议房间ID
@property (nonatomic, readonly, copy) NSString *title;  //会议主题

@property (nonatomic, readonly) JCRoomMode mode;  //会议模式

//会议中成员列表
@property (nonatomic, readonly, strong) NSArray<JCParticipantModel *> *participants;

//会议中发起屏幕共享的成员，nil则表示没成员发起屏幕共享或者发起者取消了屏幕共享
@property (nonatomic, readonly, strong) JCParticipantModel *screenSharer;

@end
