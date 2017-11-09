//
//  CGNoIdentityTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGNoIdentityTableViewCell.h"

@implementation CGNoIdentityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.button.layer.cornerRadius = 4;
  self.button.layer.masksToBounds = YES;
  self.button.backgroundColor = CTThemeMainColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(KnowledgeBaseEntity *)entity{
  if (entity.viewPermit == -1||entity.viewPermit == 6) {
    self.viewPromptLabel.text = entity.viewPrompt;
    self.button.hidden = NO;
    [self.button setTitle:@"登录" forState:UIControlStateNormal];
  }else if (entity.viewPermit==2||entity.viewPermit==3) {
    self.viewPromptLabel.text = entity.viewPrompt;
    self.button.hidden = YES;
  }else if (entity.viewPermit==1||entity.viewPermit==5||entity.viewPermit==7){
    self.viewPromptLabel.text = entity.viewPrompt;
    self.button.hidden = NO;
    [self.button setTitle:entity.viewPermit==1||entity.viewPermit==7?@"我要升级":@"我要成为VIP企业" forState:UIControlStateNormal];
    if (entity.viewPermit == 5 &&[ObjectShareTool sharedInstance].currentUser.companyList.count!=1) {
      self.button.hidden = YES;
      self.viewPromptLabel.text = @"你无权限阅读";
    }
  }else if (entity.viewPermit==4){
    NSString *integral = [NSString stringWithFormat:@"%ld",entity.integral];
    NSString *str = [NSString stringWithFormat:@"需支付%ld知识币才能查看",entity.integral];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [str length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [str length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, integral.length+3)];
    
    self.viewPromptLabel.attributedText = attributedString;
    self.button.hidden = NO;
    [self.button setTitle:@"付费" forState:UIControlStateNormal];
  }else if (entity.viewPermit == 9){
    self.viewPromptLabel.text = entity.viewPrompt;
    self.button.hidden = YES;
  }
}
@end
