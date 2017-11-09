//
//  CGUserSearchCompanyEntity.m
//  CGSays
//
//  Created by zhu on 16/10/21.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserSearchCompanyEntity.h"

@implementation CGUserSearchCompanyEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"companyId":@"id"};
}
@end
