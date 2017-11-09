//
//  CGUserWalletInfoEntity.h
//  CGSays
//
//  Created by zhu on 2017/3/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserWalletInfoEntity : NSObject
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, assign) NSInteger totalReceived;
@property (nonatomic, assign) CGFloat receivedAmount;
@property (nonatomic, assign) NSInteger totalSend;
@property (nonatomic, assign) CGFloat sendAmount;
@property (nonatomic, assign) NSInteger isBind;
@property (nonatomic, assign) NSInteger isSubscribe;
@end
