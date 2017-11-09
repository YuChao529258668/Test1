//
//  AttentionSortList.m
//  CGSays
//
//  Created by zhu on 2016/12/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "AttentionSortList.h"

@implementation AttentionSortList

-(NSMutableArray *)data{
  if(!_data){
    _data = [[NSMutableArray alloc]init];
  }
  return _data;
}


@end
