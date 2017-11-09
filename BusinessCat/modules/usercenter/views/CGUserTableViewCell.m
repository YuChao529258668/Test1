//
//  CGUserTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/17.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserTableViewCell.h"

@implementation CGUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)info:(CGUserEntity *)userInfo{
  NSString *companyType;
//  switch (userInfo.organizaType) {
//    case 1:
//      companyType = @"企业";
//      break;
//    case 2:
//      companyType = @"学校";
//      break;
//    case 3:
//      companyType = @"众创空间";
//      break;
//    case 4:
//      companyType = @"其他组织";
//      break;
//      
//    default:
//      break;
//  }
//  if (userInfo.isLogin) {
//    if (userInfo.companyName.length>0) {
//      if ((userInfo.auditStete==1&&userInfo.companyManage==0&&userInfo.companyState==0)||(userInfo.auditStete==1&&userInfo.companyManage==1&&userInfo.companyState==0)) {
//        self.attestationLabel.hidden = NO;
//        NSString *str = [NSString stringWithFormat:@"未认证%@",companyType];
//        [self updateAttestationLabelWithCompanyName:userInfo.companyName state:str];
//      }else if ((userInfo.auditStete==1&&userInfo.companyManage==0&&userInfo.companyState==2)||(userInfo.auditStete==1&&userInfo.companyManage==1&&userInfo.companyState==2)){
//      self.attestationLabel.hidden = NO;
//        NSString *str = [NSString stringWithFormat:@"%@认证中",companyType];
//        [self updateAttestationLabelWithCompanyName:userInfo.companyName state:str];
//      }else if (userInfo.auditStete==0&&userInfo.companyManage==0&&userInfo.companyState==1){
//        self.attestationLabel.hidden = NO;
//        [self updateAttestationLabelWithCompanyName:userInfo.companyName state:@"加入审核中"];
//      }else if ((userInfo.auditStete==1&&userInfo.companyManage==0&&userInfo.companyState==1)||(userInfo.auditStete==1&&userInfo.companyManage==1&&userInfo.companyState==1)){
//        self.companyLabel.hidden = NO;
//        self.levelLabel.hidden = NO;
//        self.companyLabel.text = userInfo.companyName;
//        if (userInfo.companyGender) {
//          self.levelLabel.text = [NSString stringWithFormat:@"认证%@，等级%@",companyType,userInfo.companyGender];
//        }else{
//          self.levelLabel.text = [NSString stringWithFormat:@"认证%@",companyType];
//        }
//      }
    
      
/*
      if (userInfo.companyState==1) {
        self.companyLabel.hidden = NO;
        self.levelLabel.hidden = NO;
        self.companyLabel.text = userInfo.companyName;
        if (userInfo.companyGender) {
          self.levelLabel.text = [NSString stringWithFormat:@"认证企业，等级%@", userInfo.companyGender];
        }else{
          self.levelLabel.text = [NSString stringWithFormat:@"认证企业"];
        }
      }else{
        self.attestationLabel.hidden = NO;
        NSString *state;
        if (userInfo.companyManage==1) {
          if (userInfo.companyState==0) {
            state = @"请认证公司";
          }else if(userInfo.companyState == 2){
            state = @"审核中";
          }
        }else{
          if (userInfo.companyState== 0) {
            state = @"未认证";
          }else if(userInfo.companyState == 2){
            state = @"认证公司中";
          }
        }
      }
// */
//    }else{
//      self.redView.hidden = NO;
//    }
//  }
}

- (void)updateAttestationLabelWithCompanyName:(NSString *)companyName state:(NSString *)state{
  NSString *str = [NSString stringWithFormat:@"%@(%@)",companyName,state];
  NSMutableAttributedString *colorContentString = [[NSMutableAttributedString alloc] initWithString:str];
  [colorContentString addAttribute:NSForegroundColorAttributeName value:[CTCommonUtil convert16BinaryColor:@"#ABABAB"] range:NSMakeRange(0, str.length)];
  [colorContentString addAttribute:NSForegroundColorAttributeName value:[CTCommonUtil convert16BinaryColor:@"#FC2C32"] range:NSMakeRange(companyName.length+1, state.length)];
  [colorContentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:12.0] range:NSMakeRange(0, str.length)];
  self.attestationLabel.attributedText = colorContentString;
}
@end
