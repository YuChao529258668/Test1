//
//  CGMessageEntity.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMessageEntity.h"

@implementation CGMessageEntity
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
  return @{@"messageID":@"id"};
}
@end
