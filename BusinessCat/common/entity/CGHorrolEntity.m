//
//  CGHorrolEntity.m
//  CGSays
//
//  Created by mochenyang on 2016/9/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGHorrolEntity.h"

@implementation CGHorrolEntity

-(instancetype)initWithRolId:(NSString *)rolId rolName:(NSString *)rolName sort:(int)sort{
    self = [super init];
    if(self){
        self.sort = sort;
        self.rolId = rolId;
        self.rolName = rolName;
      self.isFirst = YES;
      self.entity = [[CGUserCompanyAttestationEntity alloc]init];
    }
    return self;
}

-(HeadlineBiz *)biz{
    if(!_biz){
        _biz = [[HeadlineBiz alloc]init];
    }
    return _biz;
}

-(NSInteger)page{
  if (!_page) {
    _page = 1;
  }
  return _page;
}

-(NSMutableArray *)data{
    if(!_data){
        _data = [[NSMutableArray alloc]init];
    }
    return _data;
}

@end
