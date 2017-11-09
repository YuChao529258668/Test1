//
//  CGUserFireChoseTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserFireChoseTableViewCell.h"
#import "UIColor+colorToImage.h"
#import "CGUserRoles.h"
#import "CGUserIndustry.h"
#import "CGTagsEntity.h"
#import "CGOrganizationEntity.h"

@interface CGUserFireChoseTableViewCell()
@property (nonatomic, strong) NSArray *array;
@end

@implementation CGUserFireChoseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getRelatedWithData:(NSArray *)array{
  self.array = array;
  for (int i=0; i<array.count; i++) {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15+((SCREEN_WIDTH-90)/3+30)*(i%3), 20+35*(i/3), (SCREEN_WIDTH-90)/3, 30)];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = CTCommonLineBg.CGColor;
    btn.layer.borderWidth = 0.5;
    btn.tag = i;
    [btn setTitleColor:TEXT_MAIN_CLR forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor] Rect:btn.bounds] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIColor createImageWithColor:CTThemeMainColor Rect:btn.bounds] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    if ([array[i] isKindOfClass:[CGTags class]]) {
      CGTags *tag = array[i];
      [btn setTitle:tag.tagName forState:UIControlStateNormal];
    }else{
      CGknowledgeEntity *tag = array[i];
      [btn setTitle:tag.cateName forState:UIControlStateNormal];
    }
    [self.contentView addSubview:btn];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
  }
}

+ (float)height:(NSArray *)array{
  long int count = array.count%3>0?array.count/3+1:array.count/3;
  float height = 20+35*count;
  return height;
}

- (void)click:(UIButton *)btn{
//  btn.selected = !btn.selected;
//  if ([[self.array objectAtIndex:btn.tag] isKindOfClass:[CGUserIndustry class]]) {
//    CGUserIndustry *entity = [self.array objectAtIndex:btn.tag];
//    entity.isChecked = btn.selected;
//  }else{
//    CGUserRoles *entity = [self.array objectAtIndex:btn.tag];
//    entity.isChecked = btn.selected;
//  }
}

@end
