//
//  TeamCircleMessageCell.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/6/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "TeamCircleMessageCell.h"

@interface TeamCircleMessageCell()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UIImageView *like;
@property (weak, nonatomic) IBOutlet UILabel *scoopContent;

@end

@implementation TeamCircleMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scoopContent.backgroundColor = CTCommonViewControllerBg;
}

//relationType  1-评论 2-点赞 3-打赏
-(void)updateItem:(TeamCircleMessageModel *)entity{
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:entity.portrait]];
    self.userName.text = entity.userName;
    self.content.text = entity.relationContent;
    self.time.text = [CTDateUtils getTimeFormatFromDateLong:entity.createTime];
    if(entity.relationType == 1){//评论
        self.like.hidden = YES;
        self.content.hidden = NO;
    }else if(entity.relationType == 2){//点赞
        self.like.hidden = NO;
        self.content.hidden = YES;
    }else if(entity.relationType == 3){//打赏
        self.like.hidden = YES;
        self.content.hidden = NO;
    }
    if(entity.scoopCover){
        self.picture.hidden = NO;
        self.scoopContent.hidden = YES;
        [self.picture sd_setImageWithURL:[NSURL URLWithString:entity.scoopCover]];
    }else{
        self.picture.hidden = YES;
        self.scoopContent.hidden = NO;
        self.scoopContent.text = entity.scoopContent;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
