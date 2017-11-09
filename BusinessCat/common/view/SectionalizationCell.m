//
//  SectionalizationCell.m
//  CGSays
//
//  Created by zhu on 2017/3/17.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "SectionalizationCell.h"
#import "AttentionBiz.h"
#import "LightExpBiz.h"

@interface SectionalizationCell ()
@property (nonatomic, assign) NSInteger isSubscribe;
@property (nonatomic, strong) JoinEntity *entity;
@property (nonatomic, strong) CGInfoHeadEntity *headEntity;
@property (nonatomic, assign) BOOL subscribe;
@property (nonatomic, copy) SectionalizationBlock block;
@end

@implementation SectionalizationCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.monitoringButton.layer.cornerRadius = 4;
  self.monitoringButton.layer.masksToBounds = YES;
  self.monitoringButton.layer.borderWidth = 1;
  [self.monitoringButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
  [self.monitoringButton setTitleColor:[CTCommonUtil convert16BinaryColor:@"#787878"] forState:UIControlStateSelected];
  [self.monitoringButton setTitle:@"已监控" forState:UIControlStateSelected];
  [self.monitoringButton setTitle:@"监控" forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)groupInfo:(JoinEntity *)entity headInfo:(CGInfoHeadEntity *)headEntity{
  self.entity = entity;
  self.headEntity = headEntity;
  [self updateButtonState:entity.isJoin];
}

-(void)updateButtonState:(BOOL)state{
  if (state) {
    self.monitoringButton.selected = YES;
    self.monitoringButton.layer.borderColor = [CTCommonUtil convert16BinaryColor:@"#787878"].CGColor;
  }else{
    self.monitoringButton.selected = NO;
    self.monitoringButton.layer.borderColor = CTThemeMainColor.CGColor;
  }
}

-(void)headInfo:(CGInfoHeadEntity *)entity isSubscribe:(BOOL)isSubscribe block:(SectionalizationBlock )block{
  [self updateButtonState:isSubscribe];
  self.isSubscribe = isSubscribe;
  self.headEntity = entity;
  self.subscribe = YES;
  self.block = block;
}

- (IBAction)click:(UIButton *)sender {
  if (self.subscribe) {
    AttentionBiz *biz = [[AttentionBiz alloc]init];
    self.isSubscribe = !self.isSubscribe;
    self.block(self.isSubscribe);
    [biz subscribeAddWithId:self.headEntity.infoId type:self.headEntity.type success:^(NSInteger status) {
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ATTENTION object:nil];
    } fail:^(NSError *error) {
    }];
    [self updateButtonState:self.isSubscribe];
  }else{
    AttentionBiz *biz = [[AttentionBiz alloc]init];
    self.entity.isJoin = !self.entity.isJoin;
    [biz authRadarGroupConditionAddWithID:self.headEntity.infoId type:self.headEntity.type subjectId:self.entity.groupID op:self.entity.isJoin success:^{
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ATTENTION object:nil];
    } fail:^(NSError *error) {
      
    }];
    [self updateButtonState:self.entity.isJoin];
  }
}

@end
