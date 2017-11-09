//
//  CGUserMyPrivilegeHeaderTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserMyPrivilegeHeaderTableViewCell.h"

@interface CGUserMyPrivilegeHeaderTableViewCell()
@property (nonatomic, strong) NSMutableArray *levelIVArray;
@property (nonatomic, strong) NSMutableArray *levelLabelArray;
@property (nonatomic, strong) NSMutableArray *lineArray;

@end

@implementation CGUserMyPrivilegeHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  [self level];
}

- (void)level{
  self.levelLabelArray = [NSMutableArray array];
  self.levelIVArray = [NSMutableArray array];
  self.lineArray = [NSMutableArray array];
  float width = 0;
  int count = 10;
  for (int i=0; i<count; i++) {
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-27)/2+i*127, 26, 27, 27)];
    image.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = 13.5;
    [self.sv addSubview:image];
    if (i < count-1) {
      UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(image.frame.origin.x+image.frame.size.width, 36, 100, 5)];
      line.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
      [self.sv addSubview:line];
      [self.lineArray addObject:line];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-42)/2+i*127, image.frame.origin.y+image.frame.size.height, 42, 15)];
    [self.sv addSubview:label];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    label.text = [NSString stringWithFormat:@"%d",i+1];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.levelLabelArray addObject:label];
    [self.levelIVArray addObject:image];
    width = image.frame.origin.x+image.frame.size.width;
  }
  self.sv.contentSize = CGSizeMake(width+(SCREEN_WIDTH-27)/2, 0);
}

- (void)getLevelWithNumber:(NSString *)number{
  int count = number.intValue;
  for (int i=0; i<count; i++) {
    UIImageView *image = [self.levelIVArray objectAtIndex:i];
    image.backgroundColor = [UIColor whiteColor];
    if (i>0) {
      UIImageView *line = [self.lineArray objectAtIndex:i-1];
      line.backgroundColor = [UIColor whiteColor];
    }
    UILabel *label = [self.levelLabelArray objectAtIndex:i];
    label.textColor = [UIColor whiteColor];
    
  }
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
