//
//  CGUserFireOrganizationTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserFireOrganizationTableViewCell.h"

@implementation CGUserFireOrganizationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)update:(CGUserOrganizaJoinEntity *)entity{
  self.titleLabel.text = entity.companyFullName;
  if (entity.companyType == 2) {
    self.descLabel.text = @"";
  }else{
    if ((![CTStringUtil stringNotBlank:entity.position]||[entity.position isEqualToString:@"未知职位"])&&([entity.department isEqualToString:@"未知部门"]||![CTStringUtil stringNotBlank:entity.department])) {
     self.descLabel.text = @"(需补充职位和部门)";
    }else if (![CTStringUtil stringNotBlank:entity.position]||[entity.position isEqualToString:@"未知职位"]){
    self.descLabel.text = @"(需补充职位)";
    }else if (![CTStringUtil stringNotBlank:entity.department]||[entity.department isEqualToString:@"未知部门"]){
    self.descLabel.text = @"(需补充部门)";
    }else{
    self.descLabel.text = @"";
    }
  }
}
@end
