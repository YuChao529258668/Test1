//
//  CGUserWalletListEntity.h
//  CGSays
//
//  Created by zhu on 2017/3/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserWalletListEntity : NSObject
@property (nonatomic, copy) NSString *walletID;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger type;
@end
