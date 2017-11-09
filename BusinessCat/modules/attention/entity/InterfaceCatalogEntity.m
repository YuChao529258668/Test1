//
//  InterfaceCatalogEntity.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/11.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "InterfaceCatalogEntity.h"

@implementation InterfaceCatalogEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"catalogID":@"id"};
}
@end
