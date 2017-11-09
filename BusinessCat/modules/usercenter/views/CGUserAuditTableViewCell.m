//
//  CGUserAuditTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserAuditTableViewCell.h"


@implementation CGUserAuditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.button.layer.cornerRadius = 4;
  self.button.layer.borderColor = CTThemeMainColor.CGColor;
    [self.button addTarget:self action:@selector(auditClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updatItem:(CGUserCompanyAuditListEntity *)item block:(CGUserAuditTableViewCellButtonSelect)block{
    self.block = block;
    self.entity = item;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.userIcon] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    self.nameLabel.text = item.userName;
    self.phoneLabel.text = item.userMobile;
    if (item.auditState == 0) {
        [self.button setTitle:@"审核" forState:UIControlStateNormal];
        [self.button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
        self.button.layer.borderWidth = 0.5;
    }else if (item.auditState == 1){
        [self.button setTitle:@"已加入" forState:UIControlStateNormal];
        [self.button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
        self.button.layer.borderWidth = 0;
    }else if(item.auditState == 2){
        [self.button setTitle:@"已拒绝" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.button.layer.borderWidth = 0;
    }
    self.timeLabel.text = [CTDateUtils getTimeFormatFromDateLong:item.applyTime.integerValue];
    
}

-(void)auditClick{
    if(self.entity.auditState == 0 && self.block){
        self.block(self.entity);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
