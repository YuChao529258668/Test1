//
//  SearchProductTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "SearchProductTableViewCell.h"
#import "AttentionBiz.h"
#import "HeadlineBiz.h"
#import "LightExpBiz.h"
#import "CGDiscoverBiz.h"
#import "CGSectionalizationView.h"
#import <UIImageView+WebCache.h>

@interface SearchProductTableViewCell ()
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, assign) BOOL isAttention;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (nonatomic, copy) NSString *subjectId;
@end

@implementation SearchProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.addButton.layer.borderWidth = 0.5;
  self.addButton.layer.cornerRadius = 4;
  self.addButton.layer.masksToBounds = YES;
  [self.addButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
  self.addButton.layer.borderColor = CTThemeMainColor.CGColor;
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
  self.isAttention = isAttention;
  self.subjectId = subjectId;
  self.titleLabel.text = info.title;
  self.sourceLabel.text = [NSString stringWithFormat:@"%@",[CTStringUtil stringNotBlank:info.source]?info.source:@""];
  
  if (info.type == 4) {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"intelligent_analysis_character"]];
    if ([CTStringUtil stringNotBlank:info.source]) {
      self.sourceLabel.text = info.source;
      self.titleCenter.constant = -12;
    }else{
      self.sourceLabel.text = @"";
      self.titleCenter.constant = 0;
    }
  }else if(info.type == 8){
    [self.icon sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"defaultgraph"]];
    if ([CTStringUtil stringNotBlank:info.source]) {
      self.sourceLabel.text = info.source;
      self.titleCenter.constant = -12;
    }else{
      self.sourceLabel.text = @"";
      self.titleCenter.constant = 0;
    }
  }else{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"intelligent_analytics"]];
    self.sourceLabel.text = @"";
    self.titleCenter.constant = 0;
    self.titleHeight.constant = 50;
    self.titleLabel.numberOfLines = 3;
  }
  [self updateAddButtonType];
}

-(void)updatekeyWordItem:(CGSearchKeyWordEntity *)info action:(NSString *)acion type:(int)type typeID:(NSString *)typeID groupId:(NSString *)groupId isAttention:(BOOL)isAttention subjectId:(NSString *)subjectId{
  self.keyInfo = info;
  self.icon.image = [UIImage imageNamed:@"keyword"];
  self.action = acion;
  self.type = type;
  self.typeID = typeID;
  self.groupId = groupId;
  self.isAttention = isAttention;
  self.subjectId = subjectId;
  self.titleLabel.text = info.name;
  self.sourceLabel.text = @"";
  self.titleCenter.constant = 0;
  [self updateAddButtonType];
}

- (IBAction)click:(UIButton *)sender {
  if (self.keyInfo) {
    [self keyWordAttentionBiz];
  }else if (self.type == 9 || self.type == 10) {
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
  if (self.keyInfo) {
    [self KeyWordattention];
  }else if (self.type == 9 || self.type == 10) {
    self.addButton.hidden = NO;
    [self attention];
  }else if (self.type ==11||self.type== 15){
    self.addButton.hidden = NO;
    [self collect];
  }else if ((self.type == 3 || self.type == 4 || self.type == 8)){
    self.addButton.hidden = NO;
    if ([self.action isEqualToString:@"joinExp"]||[self.action isEqualToString:@"joinRecommend"] || [self.action isEqualToString:@"joinSubject"]){
      if ([self.action isEqualToString:@"joinExp"]) {
        if (self.info.isExp) {
          self.EXPImageView.hidden = NO;
        }else{
          self.EXPImageView.hidden = YES;
        }
      }
      
      [self add];
    }else {
      [self attention];
    }
  }else if (self.type == 14){
    self.addButton.hidden = NO;
    if ([self.action isEqualToString:@"joinExp"]||[self.action isEqualToString:@"joinRecommend"] || [self.action isEqualToString:@"joinSubject"]){
      if ([self.action isEqualToString:@"joinExp"]) {
        if (self.info.isExp) {
          self.EXPImageView.hidden = NO;
        }else{
          self.EXPImageView.hidden = YES;
        }
      }
      
      [self add];
    }else{
      [self collect];
    }
  }else{
    self.addButton.hidden = YES;
  }
}

-(void)collect{
  if (self.info.isFollow) {
    [self.addButton setTitle:@"已收藏" forState:UIControlStateNormal];
    [self.addButton setTitleColor:CTCommonLineBg forState:UIControlStateNormal];
    self.addButton.layer.borderColor = CTCommonLineBg.CGColor;
  }else{
    [self.addButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.addButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    self.addButton.layer.borderColor = CTThemeMainColor.CGColor;
  }
}

-(void)attention{
  if (self.info.isSubscribe) {
    [self.addButton setTitle:@"已监控" forState:UIControlStateNormal];
  }else{
    [self.addButton setTitle:@"监控" forState:UIControlStateNormal];
  }
}

-(void)KeyWordattention{
  if (self.keyInfo.isJoin) {
    [self.addButton setTitle:@"已监控" forState:UIControlStateNormal];
  }else{
    [self.addButton setTitle:@"监控" forState:UIControlStateNormal];
  }
}

-(void)add{
  if (self.info.isJoin || self.info.isExpJoin) {
    [self.addButton setTitle:@"已加入" forState:UIControlStateNormal];
    [self.addButton setTitleColor:CTCommonLineBg forState:UIControlStateNormal];
    self.addButton.layer.borderColor = CTCommonLineBg.CGColor;
    [self.addButton setUserInteractionEnabled:NO];
  }else{
    [self.addButton setTitle:@"加入" forState:UIControlStateNormal];
    [self.addButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    self.addButton.layer.borderColor = CTThemeMainColor.CGColor;
    [self.addButton setUserInteractionEnabled:YES];
  }
}

-(void)keyWordAttentionBiz{
  AttentionBiz *biz = [[AttentionBiz alloc]init];
  self.keyInfo.isJoin = !self.keyInfo.isJoin;
  [self updateAddButtonType];
  [biz authRadarGroupConditionAddWithID:self.keyInfo.keyWordID type:self.type subjectId:self.subjectId op:YES success:^{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ATTENTION object:@YES];
  } fail:^(NSError *error) {
    
  }];
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
  [self.addButton setUserInteractionEnabled:NO];
  self.info.isJoin = YES;
  [self updateAddButtonType];
  [biz discoverSubjectAddID:self.info.infoId type:self.type subjectId:self.typeID success:^{
    
  } fail:^(NSError *error) {
    weakSelf.info.isJoin = NO;
    [weakSelf updateAddButtonType];
    [weakSelf.addButton setUserInteractionEnabled:YES];
  }];
}

-(void)addLightExpBiz{
  __weak typeof(self) weakSelf = self;
  //加入体验
  LightExpBiz *biz = [[LightExpBiz alloc]init];
  [self.addButton setUserInteractionEnabled:NO];
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
    [weakSelf.addButton setUserInteractionEnabled:YES];
  }];
}

-(void)addRecommendBiz{
  __weak typeof(self) weakSelf = self;
  //加入全民推荐
  CGDiscoverBiz *biz = [[CGDiscoverBiz alloc]init];
  [self.addButton setUserInteractionEnabled:NO];
  self.info.isJoin = YES;
  [self updateAddButtonType];
  [biz discoverRecommendAddID:self.info.infoId type:self.type subjectId:self.typeID success:^{
    
  } fail:^(NSError *error) {
    weakSelf.info.isJoin = NO;
    [weakSelf updateAddButtonType];
    [weakSelf.addButton setUserInteractionEnabled:YES];
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
