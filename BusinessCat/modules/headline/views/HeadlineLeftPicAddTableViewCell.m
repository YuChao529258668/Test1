//
//  HeadlineLeftPicAddTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/1/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "HeadlineLeftPicAddTableViewCell.h"
#import "AttentionBiz.h"
#import "HeadlineBiz.h"
#import "LightExpBiz.h"
#import "AttentionBiz.h"
#import "CGSectionalizationView.h"

@interface HeadlineLeftPicAddTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTrailing;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *typeID;
@property (weak, nonatomic) IBOutlet UIImageView *EXPImageView;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, copy) NSString *subjectId;
@end

@implementation HeadlineLeftPicAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.contentView.clipsToBounds = YES;
  self.contentType.layer.borderWidth = 0.5;
  self.contentType.layer.borderColor = CTThemeMainColor.CGColor;
  self.contentType.layer.cornerRadius = 2;
  self.contentType.textColor = CTThemeMainColor;
  self.contentType.alpha = 0.6;
  self.line.backgroundColor = CTCommonLineBg;
  self.addButton.layer.borderWidth = 0.5;
  self.addButton.layer.cornerRadius = 4;
  self.addButton.layer.masksToBounds = YES;
  self.leftImage.layer.borderColor = CTCommonLineBg.CGColor;
  self.leftImage.layer.borderWidth = 0.5;
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
  if (info.title.length>0) {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:info.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [info.title length])];
    self.title.attributedText = attributedString;
    self.title.lineBreakMode = NSLineBreakByTruncatingTail;
  }
  
  if([CTStringUtil stringNotBlank:info.icon]){
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
  }else{
    self.leftImage.image = [UIImage imageNamed:@"morentuzhengfangxing"];
  }
  
  if([CTStringUtil stringNotBlank:info.label2] && [info.label2 rangeOfString:@"null"].location == NSNotFound){
    self.contentSourceText.text = info.label2;
  }else{
    self.contentSourceText.text = @"";
  }
  NSString *timeStr ;
  if (self.timeType == 2) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:info.createtime/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    timeStr = confromTimespStr;
    self.contentSourceX.constant = 0;
    self.contentType.hidden = YES;
    self.contentType.text = @"";
    self.contentTypeWidth.constant = 0;
  }else{
    if (self.timeType == 1) {
      if (![info.label isEqualToString:@"专辑"]) {
        info.label = @"";
      }
    }
    timeStr = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
    if([CTStringUtil stringNotBlank:info.label]){
      self.contentType.hidden = NO;
      self.contentType.text = info.label;
      [self.contentType sizeToFit];
      self.contentTypeWidth.constant = self.contentType.frame.size.width+10;
      self.contentSourceX.constant = 5;
    }else{
      self.contentSourceX.constant = 0;
      self.contentType.hidden = YES;
      self.contentType.text = @"";
      self.contentTypeWidth.constant = 0;
    }
  }
  switch (info.type) {
    case 3:
      info.label = @"";
        self.contentSourceText.text = [NSString stringWithFormat:@"%@",timeStr];
      break;
    case 4:
      info.label = @"";
      if([CTStringUtil stringNotBlank:info.name]){
        self.contentSourceText.text = [NSString stringWithFormat:@"%@ %@",info.name,timeStr];
      }else{
        self.contentSourceText.text = [NSString stringWithFormat:@"%@",timeStr];
      }
      if ([CTStringUtil stringNotBlank:info.label2]) {
        self.contentSourceText.text = [NSString stringWithFormat:@"%@ %@",self.contentSourceText.text,info.source];
      }
      break;
    case 8:
      info.label = @"";
      self.contentSourceText.text = [NSString stringWithFormat:@"%@ %@",timeStr,info.label2];
      break;
    case 9:
      info.label = @"";
      self.contentSourceText.text = [NSString stringWithFormat:@"%@",timeStr];
      self.titleY.constant = 20;
      self.desc.text = info.desc;
      break;
    case 14:
      self.contentSourceText.text = [NSString stringWithFormat:@"%@",timeStr];
      break;
      break;
    default:
      break;
  }
  
//  if([CTStringUtil stringNotBlank:info.label]){
//    self.contentType.hidden = NO;
//    self.contentType.text = info.label;
//    [self.contentType sizeToFit];
//    self.contentTypeWidth.constant = self.contentType.frame.size.width+10;
//    self.contentSourceX.constant = 5;
//  }else{
//    self.contentSourceX.constant = 0;
//    self.contentType.hidden = YES;
//    self.contentType.text = @"";
//    self.contentTypeWidth.constant = 0;
//  }
//  self.time.text = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
  
  if (info.type == 3 || info.type == 14) {
    self.titleX.constant =15;
    self.leftImage.hidden = YES;
    self.titleHeight.constant = 50;
  }else{
    self.titleX.constant =85;
    self.leftImage.hidden = NO;
    self.titleHeight.constant = 30;
  }
  
  [self updateAddButtonType];
  
}

- (IBAction)addClick:(UIButton *)sender {
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
  self.titleTrailing.constant = 75;
  if (self.type == 9 || self.type == 10) {
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
    self.titleTrailing.constant = 15;
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
//    [self.addButton setTitleColor:CTCommonLineBg forState:UIControlStateNormal];
//    self.addButton.layer.borderColor = CTCommonLineBg.CGColor;
  }else{
    [self.addButton setTitle:@"监控" forState:UIControlStateNormal];
    [self.addButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    self.addButton.layer.borderColor = CTThemeMainColor.CGColor;
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

- (IBAction)closeClick:(UIButton *)sender {
  if(self.delegate && [self.delegate respondsToSelector:@selector(headlineCloseInfoCallBack:cell:closeBtnY:)]){
    [self.delegate headlineCloseInfoCallBack:self.info cell:self closeBtnY:CGRectGetMaxY(sender.frame)];
  }
}
@end
