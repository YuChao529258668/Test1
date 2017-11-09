//
//  classifiedSectionView.m
//  CGSays
//
//  Created by zhu on 2016/11/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "classifiedSectionView.h"

@interface classifiedSectionView (){
  classifiedSectionViewBlock block;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation classifiedSectionView

- (instancetype)initWithFrame:(CGRect)frame selectIndex:(classifiedSectionViewBlock)index{
  self = [super initWithFrame:frame];
  if(self){
    block = index;
    
  }
  return self;
}



- (void)setDataWithArray:(NSMutableArray *)array{

}

//弹出
- (void)showInView:(UIView *)view{

}

@end
