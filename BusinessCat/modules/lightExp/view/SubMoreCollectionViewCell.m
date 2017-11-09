//
//  SubMoreCollectionViewCell.m
//  CGSays
//
//  Created by zhu on 2016/11/30.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "SubMoreCollectionViewCell.h"

@implementation SubMoreCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShake:) name:@"editStateChanged" object:nil];
}

- (void)handleShake:(NSNotification*)sender
{
  if ([sender.object intValue] == YES) {    
    self.selectButton.hidden = NO;
    self.selectButton.userInteractionEnabled = YES;
    
  }else{
    self.selectButton.hidden = YES;
    self.selectButton.selected = NO;
    
  }
}

- (IBAction)click:(UIButton *)sender {
  sender.selected = !sender.selected;
  if (self.delegate && [self.delegate respondsToSelector:@selector(modelCellButton:)]) {
    [self.delegate modelCellButton:self];
  }
}

@end
