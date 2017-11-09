//
//  CGUserPhoneContactEntity.h
//  CGSays
//
//  Created by zhu on 16/10/25.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserPhoneContactEntity : NSObject
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) NSInteger isInvite;//是否邀请 1邀请 0未邀请 4邀请中
@property (nonatomic, copy) NSString *position;
@end
