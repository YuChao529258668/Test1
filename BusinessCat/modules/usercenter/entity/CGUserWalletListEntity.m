//
//  CGUserWalletListEntity.m
//  CGSays
//
//  Created by zhu on 2017/3/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserWalletListEntity.h"

@implementation CGUserWalletListEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"walletID":@"id"};
}
@end
