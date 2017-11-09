//
//  SearchCompanyTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "SearchCompanyTableViewCell.h"
#import "AttentionBiz.h"
#import "HeadlineBiz.h"
#import "LightExpBiz.h"
#import "CGDiscoverBiz.h"
#import "CGSectionalizationView.h"

@interface SearchCompanyTableViewCell ()
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, copy) NSString *subjectId;
@end

@implementation SearchCompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.button.layer.borderWidth = 0.5;
  self.button.layer.cornerRadius = 4;
  self.button.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateItem:(CGInfoHeadEntity *)info action:(NSString *)acion type:(int)type typeID:(NSString *)typeID groupId:(NSString *)groupId isAttention:(BOOL)isAttention subjectId:(NSString *)subjectId{
  self.info = info;
  self.action = acion;
  self.type = type;
  self.typeID = typeID;
  self.groupId = groupId;
  self.titleLabel.text = info.title;
  self.isAttention = isAttention;
  self.subjectId = subjectId;
  self.descLabel.text = [NSString stringWithFormat:@"%@",[CTDateUtils getTimeFormatFromDateLong:info.createtime]];
  
  [self updateAddButtonType];
}

- (IBAction)click:(id)sender {
  if (self.type == 9 || self.type == 10) {
    [self attentionBiz];
  }else if (self.type ==11||self.type== 15){
    [self collectBiz];
  }else if ((self.type == 3 || self.type == 4 || self.type == 8||self.type ==14)){
    if ([self.action isEqualToString:@"joinRecommend"]){
      if (!self.info.isJoin) {
        [self addRecommendBiz];
      }
    }else if ([self.action isEqualToString:@"joinSubject"]){
      if (!self.info.isJoin) {
        [self addThemeBiz];
      }
    }else if ([self.action isEqualToString:@"joinExp"]){
      if (!self.info.isExpJoin) {
        [self addLightExpBiz];
      }
    }else if (self.type == 14){
      [self collectBiz];
    }else {
      [self attentionBiz];
    }
  }
}

- (void)updateAddButtonType{
  if (self.type == 9 || self.type == 10) {
    self.button.hidden = NO;
    [self attention];
  }else if (self.type ==11||self.type== 15){
    self.button.hidden = NO;
    [self collect];
  }else if ((self.type == 3 || self.type == 4 || self.type == 8)){
    self.button.hidden = NO;
    if ([self.action isEqualToString:@"joinExp"]||[self.action isEqualToString:@"joinRecommend"] || [self.action isEqualToString:@"joinSubject"]){
      [self add];
    }else {
      [self attention];
    }
  }else if (self.type == 14){
    self.button.hidden = NO;
    if ([self.action isEqualToString:@"joinExp"]||[self.action isEqualToString:@"joinRecommend"] || [self.action isEqualToString:@"joinSubject"]){
      [self add];
    }else{
      [self collect];
    }
  }else{
    self.button.hidden = YES;
  }
}

-(void)collect{
  if (self.info.isFollow) {
    [self.button setTitle:@"已收藏" forState:UIControlStateNormal];
    [self.button setTitleColor:CTCommonLineBg forState:UIControlStateNormal];
    self.button.layer.borderColor = CTCommonLineBg.CGColor;
  }else{
    [self.button setTitle:@"收藏" forState:UIControlStateNormal];
    [self.button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    self.button.layer.borderColor = CTThemeMainColor.CGColor;
  }
}

-(void)attention{
  if (self.info.isSubscribe) {
    [self.button setTitle:@"已监控" forState:UIControlStateNormal];
//    [self.button setTitleColor:CTCommonLineBg forState:UIControlStateNormal];
//    self.button.layer.borderColor = CTCommonLineBg.CGColor;
  }else{
    [self.button setTitle:@"监控" forState:UIControlStateNormal];
    [self.button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    self.button.layer.borderColor = CTThemeMainColor.CGColor;
  }
}

-(void)add{
  if (self.info.isJoin || self.info.isExpJoin) {
    [self.button setTitle:@"已加入" forState:UIControlStateNormal];
    [self.button setTitleColor:CTCommonLineBg forState:UIControlStateNormal];
    self.button.layer.borderColor = CTCommonLineBg.CGColor;
    [self.button setUserInteractionEnabled:NO];
  }else{
    [self.button setTitle:@"加入" forState:UIControlStateNormal];
    [self.button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    self.button.layer.borderColor = CTThemeMainColor.CGColor;
    [self.button setUserInteractionEnabled:YES];
  }
}

-(void)attentionBiz{
  __weak typeof(self) weakSelf = self;
  if (self.isAttention) {
    AttentionBiz *biz = [[AttentionBiz alloc]init];
    self.info.isSubscribe = !self.info.isSubscribe;
    [self updateAddButtonType];
    [biz authRadarGroupConditionAddWithID:self.info.infoId type:self.type subjectId:self.subjectId op:YES success:^{
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ATTENTION object:@YES];
    } fail:^(NSError *error) {
      
    }];
  }else{
    CGSectionalizationView *vc = [[CGSectionalizationView userHeaderView]initWithBlock:^(BOOL isMonitoring) {
      weakSelf.info.isSubscribe = isMonitoring;
      [weakSelf attention];
    }];
    [vc showWithEntity:self.info];
  }
}

-(void)addThemeBiz{
  __weak typeof(self) weakSelf = self;
  //加入主题
  CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
  [self.button setUserInteractionEnabled:NO];
  self.info.isJoin = YES;
  [self updateAddButtonType];
  [biz discoverSubjectAddID:self.info.infoId type:self.type subjectId:self.typeID success:^{
    
  } fail:^(NSError *error) {
    weakSelf.info.isJoin = NO;
    [weakSelf updateAddButtonType];
    [weakSelf.button setUserInteractionEnabled:YES];
  }];
}

-(void)addLightExpBiz{
  __weak typeof(self) weakSelf = self;
  //加入体验
  LightExpBiz *biz = [[LightExpBiz alloc]init];
  [self.button setUserInteractionEnabled:NO];
  self.info.isExpJoin = YES;
  [self updateAddButtonType];
  [biz discoverExpAddProductWithProductID:self.info.infoId success:^(CGApps *entity){
    if (weakSelf.groupId.length>0) {
      [biz discoverExpMyGroupAddWithids:@[entity.mid] gid:weakSelf.groupId op:1 success:^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:weakSelf.groupId forKey:@"gid"];
        [dic setObject:entity forKey:@"apps"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_JOINPRODUCT object:dic];
      } fail:^(NSError *error) {
      }];
    }else{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_JOINPRODUCT object:entity];
    }
  } fail:^(NSError *error) {
    weakSelf.info.isExpJoin = NO;
    [weakSelf updateAddButtonType];
    [weakSelf.button setUserInteractionEnabled:YES];
  }];
}

-(void)addRecommendBiz{
  __weak typeof(self) weakSelf = self;
  //加入全民推荐
  CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
  [self.button setUserInteractionEnabled:NO];
  self.info.isJoin = YES;
  [self updateAddButtonType];
  [biz discoverRecommendAddID:self.info.infoId type:self.type subjectId:self.typeID success:^{
    
  } fail:^(NSError *error) {
    weakSelf.info.isJoin = NO;
    [weakSelf updateAddButtonType];
    [weakSelf.button setUserInteractionEnabled:YES];
  }];
}

-(void)collectBiz{
  //收藏
  HeadlineBiz *biz = [[HeadlineBiz alloc]init];
  self.info.isFollow = !self.info.isFollow;
  [self updateAddButtonType];
  [biz collectWithId:self.info.infoId type:self.type collect:self.info.isFollow success:^{
  } fail:^(NSError *error) {
  }];
}
@end
