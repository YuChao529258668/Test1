//
//  OpponentTableViewCell.m
//  CGSays
//
//  Created by zhu on 2016/12/30.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "OpponentTableViewCell.h"

@interface OpponentTableViewCell (){
  CGOpponentCellBlock resultBlock;
  CGOpponentType type;
}

@end

@implementation OpponentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)opponentType:(CGOpponentType)opponentType block:(CGOpponentCellBlock)block{
  type = opponentType;
  resultBlock = block;
    switch (opponentType) {
      case CGOpponentTypeLogin:
        self.titleLabel.text = @"需登录后才能查看";
        [self.button setTitle:@"我要登录" forState:UIControlStateNormal];
        self.button.hidden = NO;
        break;
      case CGOpponentTypeOrganization:
        self.titleLabel.text = @"需加入组织后才能查看";
        [self.button setTitle:@"加入组织" forState:UIControlStateNormal];
        self.button.hidden = NO;
        break;
      case CGOpponentTypeIntelligencer:
        self.titleLabel.text = @"尚未设置竞争对手";
        [self.button setTitle:@"对手管理" forState:UIControlStateNormal];
        break;
      case CGOpponentTypeNullIntelligencer:
        self.titleLabel.text = @"请联系管理员设置竞争对手";
        self.button.hidden = YES;
        break;
      case CGOpponentTypeEmpty:
        self.titleLabel.text = @"没有数据";
        self.button.hidden = YES;
        break;
        
      default:
        break;
    }
}

- (IBAction)click:(UIButton *)sender {
  resultBlock(type);
}

@end
