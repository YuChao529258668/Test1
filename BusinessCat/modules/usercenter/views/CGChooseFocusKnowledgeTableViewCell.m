//
//  CGChooseFocusKnowledgeTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/7/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGChooseFocusKnowledgeTableViewCell.h"

@interface CGChooseFocusKnowledgeTableViewCell ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, copy) CGChooseFocusKnowledgeTableBlock block;
@end

@implementation CGChooseFocusKnowledgeTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

-(void)update:(NSMutableArray *)array selectArray:(NSMutableArray *)selectArray{
  self.array = array;
  self.selectArray = selectArray;
  for (UIView *view in self.contentView.subviews) {
    [view removeFromSuperview];
  }
  //  CGRect frame = CGRectMake(5, 10, 0, 0);
  for (int i=0; i<array.count; i++) {
    NavsEntity *entity = array[i];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15+((SCREEN_WIDTH-50)/3+10)*(i%3), i/3*45+10, (SCREEN_WIDTH-50)/3, 40)];
    [self.contentView addSubview:btn];
    [btn setTitleColor:TEXT_MAIN_CLR forState:UIControlStateNormal];
    [btn setBackgroundColor:[CTCommonUtil convert16BinaryColor:@"#F7F7F7"]];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    for (NavsEntity *navs in self.selectArray) {
      if ([entity.navsID isEqualToString:navs.navsID]) {
        entity.isSelect = YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:CTThemeMainColor];
        break;
      }
    }
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.numberOfLines = 2;
    
    [btn setTitle:entity.name forState:UIControlStateNormal];
    btn.tag = i;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
  }
}

-(void)update:(NSMutableArray *)array block:(CGChooseFocusKnowledgeTableBlock)block{
  self.array = array;
  self.block = block;
  for (UIView *view in self.contentView.subviews) {
    [view removeFromSuperview];
  }
  //  CGRect frame = CGRectMake(5, 10, 0, 0);
  for (int i=0; i<array.count; i++) {
    NavsEntity *entity = array[i];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15+((SCREEN_WIDTH-50)/3+10)*(i%3), i/3*45+10, (SCREEN_WIDTH-50)/3, 40)];
    [self.contentView addSubview:btn];
    [btn setTitleColor:TEXT_MAIN_CLR forState:UIControlStateNormal];
    [btn setBackgroundColor:[CTCommonUtil convert16BinaryColor:@"#F7F7F7"]];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.numberOfLines = 2;
    
    [btn setTitle:entity.name forState:UIControlStateNormal];
    btn.tag = i;
    [btn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
  }
}

-(void)selectClick:(UIButton *)sender{
  NavsEntity *entity = self.array[sender.tag];
  self.block(entity);
}

-(CGSize)heightWithWidth:(CGFloat)width font:(CGFloat)font str:(NSString *)string{
  UIFont * fonts = [UIFont systemFontOfSize:font];
  CGSize size  =CGSizeMake(width, MAXFLOAT);
  NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName ,nil];
  size = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
  return size;
}

-(void)click:(UIButton *)sender{
  NavsEntity *entity = self.array[sender.tag];
  if (self.selectArray.count>=30&&entity.isSelect == NO) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"不能选择多于30个"]show:window];
  }else{
    entity.isSelect = !entity.isSelect;
    if (entity.isSelect) {
      [self.selectArray addObject:entity];
      [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [sender setBackgroundColor:CTThemeMainColor];
    }else{
      [sender setTitleColor:TEXT_MAIN_CLR forState:UIControlStateNormal];
      [sender setBackgroundColor:[CTCommonUtil convert16BinaryColor:@"#F7F7F7"]];
      for (NavsEntity *navs in self.selectArray) {
        if ([entity.navsID isEqualToString:navs.navsID]) {
          [self.selectArray removeObject:navs];
          break;
        }
      }
    }
  }
}

+(CGFloat)height:(NSMutableArray *)array{
  NSInteger count = array.count%3==0 ?array.count/3:array.count/3+1;
  CGFloat height = 10+count*45+5;
  //  CGRect frame = CGRectMake(5, 10, 0, 0);
  //  for (int i=0; i<array.count; i++) {
  //    NavsEntity *entity = array[i];
  //    UIFont * fonts = [UIFont systemFontOfSize:15];
  //    CGSize size  =CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT);
  //    NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName ,nil];
  //    size = [entity.name boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
  //    CGRect btnframe = CGRectMake(frame.origin.x+frame.size.width+10, frame.origin.y, size.width+10, size.height+10);
  //    if (btnframe.size.width+btnframe.origin.x+10>SCREEN_WIDTH-30) {
  //      btnframe = CGRectMake(15, frame.origin.y+frame.size.height+10, size.width+10, size.height+10);
  //    }
  //    frame = btnframe;
  //  }
  if (array.count<=0) {
    height = 0;
  }
  return height;
}

@end
