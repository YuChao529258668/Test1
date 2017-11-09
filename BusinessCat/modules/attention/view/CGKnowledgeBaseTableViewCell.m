//
//  CGKnowledgeBaseTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKnowledgeBaseTableViewCell.h"

@interface CGKnowledgeBaseTableViewCell ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, copy) CGKnowledgeBaseTableBlock block;
@end

@implementation CGKnowledgeBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(NSMutableArray *)array block:(CGKnowledgeBaseTableBlock)block{
  self.array = array;
  self.block = block;
  for (UIView *view in self.contentView.subviews) {
    [view removeFromSuperview];
  }
//  CGRect frame = CGRectMake(5, 10, 0, 0);
  for (int i=0; i<array.count; i++) {
    NavsEntity *entity = array[i];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15+((SCREEN_WIDTH-50)/3+10)*(i%3), i/3*45+10, (SCREEN_WIDTH-50)/3, 40)];
//    if (btn.frame.size.width+btn.frame.origin.x+10>SCREEN_WIDTH-30) {
//      btn.frame = CGRectMake(15, frame.origin.y+frame.size.height+10, btnSize.width+10, btnSize.height+10);
//    }
//    frame = btn.frame;
    [self.contentView addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:TEXT_MAIN_CLR forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.numberOfLines = 2;
    
    [btn setTitle:entity.name forState:UIControlStateNormal];
    [btn setBackgroundColor:[CTCommonUtil convert16BinaryColor:@"#F7F7F7"]];
    btn.tag = i;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
  }
}


-(CGSize)heightWithWidth:(CGFloat)width font:(CGFloat)font str:(NSString *)string{
  UIFont * fonts = [UIFont systemFontOfSize:font];
  CGSize size  =CGSizeMake(width, MAXFLOAT);
  NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName ,nil];
  size = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
  return size;
}

-(void)click:(UIButton *)sender{
  self.block(self.array[sender.tag],sender.tag);
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
