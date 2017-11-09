//
//  CGKnowledgeBaseTableTopViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKnowledgeBaseTableTopViewCell.h"
#import <UIImageView+WebCache.h>

@interface CGKnowledgeBaseTableTopViewCell ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, copy) CGKnowledgeBaseTableTopBlock block;
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation CGKnowledgeBaseTableTopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.backgroundColor = CTCommonViewControllerBg;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updata:(NSMutableArray *)array selectIndex:(NSInteger)selectIndex block:(CGKnowledgeBaseTableTopBlock)block{
  self.array = array;
  self.block = block;
  for (UIView *view in self.sv.subviews) {
    [view removeFromSuperview];
  }
  NSUInteger count = array.count%8==0?array.count/8:array.count/8+1;
  for (int i=0; i<count; i++) {
    NSInteger jcount = 8;
    if (i == count-1) {
      jcount = array.count%8==0?8:array.count%8;
    }
    for (int j =0; j<jcount; j++) {
      UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH+j%4*SCREEN_WIDTH/4, j/4*80, SCREEN_WIDTH/4, 80)];
      [self.sv addSubview:btn];
      btn.backgroundColor = [UIColor clearColor];
      btn.tag = i*8+j;
      [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//      UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH+j%4*SCREEN_WIDTH/4, j/4*80, SCREEN_WIDTH/4, 80)];
//      [self.sv addSubview:view];
      [btn setBackgroundColor:CTCommonViewControllerBg];
      if (selectIndex == i*8+j) {
        self.selectButton = btn;
        btn.backgroundColor = [UIColor whiteColor];
      }
      KnowledgeBaseEntity *entity = array[i*8+j];
      UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH/4, 20)];
      label.textColor = TEXT_MAIN_CLR;
      label.font = [UIFont systemFontOfSize:15];
      label.textAlignment = NSTextAlignmentCenter;
      label.text = entity.name;
      [btn addSubview:label];
      UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4-40)/2, 10, 40, 40)];
      [btn addSubview:imageView];
      imageView.layer.cornerRadius = 20;
      imageView.layer.masksToBounds = YES;
      imageView.backgroundColor = [CTCommonUtil convert16BinaryColor:entity.color];
      [imageView sd_setImageWithURL:[NSURL URLWithString:entity.icon]];
      
    }
  }
  self.sv.pagingEnabled = YES;
  self.sv.contentSize = CGSizeMake(SCREEN_WIDTH*count, 0);
}

-(void)click:(UIButton *)sender{
  self.selectButton.backgroundColor = CTCommonViewControllerBg;
  sender.backgroundColor = [UIColor whiteColor];
  self.selectButton = sender;
  self.block(sender.tag);
}
@end
