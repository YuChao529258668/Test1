//
//  CGLineLayout.m
//  CGSays
//
//  Created by zhu on 2016/11/17.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGLineLayout.h"

@implementation CGLineLayout
- (instancetype)init{
  
  self = [super init];
  
  if (self) {
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
  }
  
  return self;
  
}



- (void)prepareLayout{
  
  [super prepareLayout];
  
  self.collectionView.contentOffset = self.offsetpoint;
  
}



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds{
  
  
  
  return NO;
  
}
@end
