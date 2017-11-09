//
//  CGInviteFriendEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGInviteFriendEntity : NSObject
@property (nonatomic, assign) NSInteger countInvite;
@property (nonatomic, copy) NSString *invitationCode;
@property (nonatomic, copy) NSString *invitationUrl;
@property (nonatomic, assign) NSInteger bonusPoints;
@property (nonatomic, assign) NSInteger inviteNum;
@end
