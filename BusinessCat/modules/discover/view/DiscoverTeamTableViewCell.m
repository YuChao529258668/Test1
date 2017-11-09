//
//  DiscoverTeamTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/11/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "DiscoverTeamTableViewCell.h"

@interface DiscoverTeamTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIView *redHot;

@end

@implementation DiscoverTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.num.layer.cornerRadius = 9;
    self.num.layer.masksToBounds = YES;
    self.redHot.layer.cornerRadius = 5;
    self.redHot.layer.masksToBounds = YES;
    self.contentView.layer.masksToBounds = YES;
  self.layer.masksToBounds = YES;
}

-(void)updateUserName:(NSString *)userName userIcon:(NSString *)userIcon num:(int)num{
    if([CTStringUtil stringNotBlank:userName]){
        [self.icon sd_setImageWithURL:[NSURL URLWithString:userIcon] placeholderImage:[UIImage imageNamed:@"user_icon"]];
        self.redHot.hidden = NO;
    }else{
        self.icon.image = nil;
        self.redHot.hidden = YES;
    }
    
    if(num <= 0){
        self.num.hidden = YES;
    }else{
        self.num.hidden = NO;
        self.num.text = [NSString stringWithFormat:@"%d",num > 99 ? 99 : num];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
