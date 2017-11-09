//
//  CGKonwledgeMoreTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/7/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKonwledgeMoreTableViewCell.h"
#import "CGInfoHeadEntity.h"

@interface CGKonwledgeMoreTableViewCell ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, copy) CGKonwledgeMoreBlock block;
@end

@implementation CGKonwledgeMoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(NSMutableArray *)array block:(CGKonwledgeMoreBlock)block{
  for (UIView *view in self.contentView.subviews) {
    [view removeFromSuperview];
  }
  self.array = array;
  self.block = block;
  int j = 3;
  CGFloat width = (SCREEN_WIDTH-15*4)/j;
  if (width>100) {
    j =4;
    width = (SCREEN_WIDTH-15*5)/j;
  }
  for (int i= 0; i<array.count; i++) {
    CGInfoHeadEntity *info = array[i];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15+i%j*(width+15), i/j*(width+50), width, width+50)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, width, width)];
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 4;
    NSString *imageUrl;
    if (info.imglist.count>0) {
      NSDictionary *dic = info.imglist[0];
      imageUrl = dic[@"src"];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [view addSubview:imageView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, width+15, width, 35)];
    [view addSubview:title];
    title.text = info.title;
    title.textColor = [UIColor lightGrayColor];
    title.numberOfLines = 3;
    title.textAlignment = NSTextAlignmentCenter;
    title.lineBreakMode = NSLineBreakByCharWrapping;
    title.font = [UIFont systemFontOfSize:12];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:view.bounds];
    btn.tag = i;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [self.contentView addSubview:view];
  }
}

-(void)click:(UIButton *)sendr{
  CGInfoHeadEntity *info = self.array[sendr.tag];
  self.block(info);
}

+(NSInteger)height:(NSMutableArray *)array{
  int j = 3;
  CGFloat width = (SCREEN_WIDTH-15*4)/j;
  if (width>100) {
    j =4;
    width = (SCREEN_WIDTH-15*5)/j;
  }
  NSInteger height = (array.count%j==0?array.count/j:(array.count/j+1))*(width+50)+15;
  return height;
}
@end
