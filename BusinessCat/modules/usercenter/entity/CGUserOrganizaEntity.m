//
//  CGUserOrganizaEntity.m
//  CGSays
//
//  Created by zhu on 16/11/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserOrganizaEntity.h"

@implementation CGUserOrganizaEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"organizaID":@"id"};
}
@end
