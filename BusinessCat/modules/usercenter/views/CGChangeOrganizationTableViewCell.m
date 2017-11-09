//
//  CGChangeOrganizationTableViewCell.m
//  CGSays
//
//  Created by zhu on 2016/12/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGChangeOrganizationTableViewCell.h"
#import "ChangeOrganizationViewModel.h"

@interface CGChangeOrganizationTableViewCell ()
@property (nonatomic, copy) CGClaimOrganizationBlock claimBlock;
@property (nonatomic, copy) CGBuyVIPOrganizationBlock vipBlock;
@property (nonatomic, copy) CGDeleteOrganizationBlock deleteBlock;
@property (nonatomic, strong) CGUserOrganizaJoinEntity *entity;

@end


@implementation CGChangeOrganizationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.layer.cornerRadius = 4;
    self.button.layer.masksToBounds = YES;
    self.button.layer.borderWidth = 0.7f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)info:(CGUserOrganizaJoinEntity *)entity editing:(BOOL)editing deleteBlock:(CGDeleteOrganizationBlock)deleteBlock claimBlock:(CGClaimOrganizationBlock)claimBlock vipBlock:(CGBuyVIPOrganizationBlock)vipBlock{
    self.claimBlock = claimBlock;
    self.vipBlock = vipBlock;
    self.entity = entity;
    self.titleLabel.text = entity.companyFullName;
    self.deleteBlock = deleteBlock;
    NSString *companyType;
    switch (entity.companyType) {
        case 1:
            companyType = @"企业";
            break;
        case 2:
            companyType = @"学校";
            break;
        case 3:
            companyType = @"众创空间";
            break;
        case 4:
            companyType = @"其他组织";
            break;
        default:
            break;
    }
    NSString *typestr = @"";
    OrganizationType organizaSate = [ChangeOrganizationViewModel getChangeOrganizationState:entity];
    self.button.tag = organizaSate;
    self.detailLabel.textColor = [UIColor lightGrayColor];
    [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    typestr = [NSString stringWithFormat:@"已认领%@",companyType];
    switch (organizaSate) {
        case OrganizationTypeYetClaimed:
            typestr = [NSString stringWithFormat:@"未认领%@",companyType];
            self.detailLabel.textColor = [UIColor redColor];
            [self.button setTitle:@"认领组织" forState:UIControlStateNormal];
            [self.button setTitleColor: [UIColor redColor] forState:UIControlStateNormal];
            self.button.layer.borderColor =  [UIColor redColor].CGColor;
            break;
        case OrganizationTypeClaimedInReview:
            [self.button setTitle:@"加入待审核中" forState:UIControlStateNormal];
            break;
        case OrganizationTypeClaimedNoneVip:
            [self.button setTitle:@"购买企业会员" forState:UIControlStateNormal];
            [self.button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
            self.button.layer.borderColor = CTThemeMainColor.CGColor;
            break;
        case OrganizationTypeClaimedjoin:
            [self.button setTitle:@"已加入" forState:UIControlStateNormal];
        [self.button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
        self.button.layer.borderColor = CTThemeMainColor.CGColor;
            break;
        case OrganizationTypeClaimednotThroughReview:
            typestr = @"加入审核未通过，请查看原因";
            self.detailLabel.textColor = [UIColor redColor];
            [self.button setTitle:@"审核详情" forState:UIControlStateNormal];
            [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.button.layer.borderColor = [UIColor redColor].CGColor;
            break;
        case OrganizationTypeClaimedIng:
            //认领中
            typestr = [NSString stringWithFormat:@"认领中%@",companyType];
            self.detailLabel.textColor = [UIColor redColor];
            [self.button setTitle:@"认领审核中" forState:UIControlStateNormal];
            [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.button.layer.borderColor = [UIColor redColor].CGColor;
            break;
        case OrganizationTypeClaimedFail:
            //认领失败
            if(self.entity.authInfo.additional){
                typestr = @"认领失败";
                [self.button setTitle:@"认领失败" forState:UIControlStateNormal];
            }else{
                typestr = @"未认领组织";
                [self.button setTitle:@"认领组织" forState:UIControlStateNormal];
            }
            self.detailLabel.textColor = [UIColor redColor];
            [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.button.layer.borderColor = [UIColor redColor].CGColor;
            break;
            
        default:
        case OrganizationTypeInvitationing:
        typestr = [NSString stringWithFormat:@"已认领%@",companyType];
        self.detailLabel.textColor = [UIColor redColor];
        [self.button setTitle:@"认领组织" forState:UIControlStateNormal];
        [self.button setTitleColor: [UIColor redColor] forState:UIControlStateNormal];
        self.button.layer.borderColor =  [UIColor redColor].CGColor;
        break;
            break;
    }
    self.detailLabel.text = [NSString stringWithFormat:@"%@",typestr];
    if (editing) {
      self.button.hidden = NO;
        [self.button setTitle:@"退出组织" forState:UIControlStateNormal];
        [self.button setBackgroundColor:[UIColor whiteColor]];
        [self.button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
        self.button.layer.borderColor = CTThemeMainColor.CGColor;
        self.button.layer.borderWidth = 0.7f;
        self.button.tag = OrganizationTypeQuit;
    }
  self.button.hidden = entity.companyType == 4?YES:NO;
}
- (IBAction)click:(UIButton *)sender {
    int tag = (int)sender.tag;
    switch (tag) {
        case OrganizationTypeYetClaimed:{
            self.claimBlock(sender);
        }
            
            break;
        case OrganizationTypeClaimedInReview:{
            
        }
            
            break;
        case OrganizationTypeClaimedNoneVip:{
            self.vipBlock(sender);
        }
            
            break;
        case OrganizationTypeClaimedjoin:{
            self.vipBlock(sender);
        }
            
            break;
        case OrganizationTypeClaimednotThroughReview:{
          if (self.entity.auditInfo.count>0) {
            CGAuditInfoEntity *entity = self.entity.auditInfo[0];
            NSString *alertMsg = entity.reason;
            if(!alertMsg){
              alertMsg = @"原因未知";
            }
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:alertMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
          }
        }
            
            break;
        case OrganizationTypeClaimedIng:{
            
        }
            
            break;
        case OrganizationTypeClaimedFail:{
            self.claimBlock(sender);
        }
            break;
        case OrganizationTypeQuit:{
            self.deleteBlock(sender);
        }
            
            break;
        case OrganizationTypeInvitationing:
        
        break;
            
        default:
            break;
    }
}


@end
