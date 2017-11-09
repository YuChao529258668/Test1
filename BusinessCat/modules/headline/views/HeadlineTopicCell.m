//
//  HeadlineTopicCell.m
//  CGSays
//
//  Created by mochenyang on 2016/10/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadlineTopicCell.h"
#import "HeadlineBiz.h"

@interface HeadlineTopicCell(){
    CGCommentEntity *comment;
}
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *paiseNum;
@property (weak, nonatomic) IBOutlet UIButton *replyNum;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIView *replyView;

@property (weak, nonatomic) IBOutlet UIView *replyLine;
@property (weak, nonatomic) IBOutlet UILabel *replyUserName;
@property (weak, nonatomic) IBOutlet UILabel *replyContent;
@property (weak, nonatomic) IBOutlet UILabel *replySubNum;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@end

@implementation HeadlineTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.replyLine.backgroundColor = CTCommonLineBg;
  [self.deleteButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateItem:(CGCommentEntity *)entity{
  
  self.content.font = [UIFont systemFontOfSize:(16)];
  self.replyContent.font = [UIFont systemFontOfSize:15];
    comment = entity;
//    if([CTStringUtil stringNotBlank:entity.portrait]){
        [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.portrait] placeholderImage:[UIImage imageNamed:@"user_icon"]];
//    }
    if([CTStringUtil stringNotBlank:entity.userName]){
        self.userName.text = entity.userName;
    }else{
        self.userName.text = @"匿名";
    }
  self.deleteButton.hidden = [[ObjectShareTool sharedInstance].currentUser.uuid isEqualToString:entity.uid]?NO:YES;
  
    self.time.text = [CTDateUtils getTimeFormatFromDateLong:entity.time];
  [self.time sizeToFit];
  self.deleteButton.frame = CGRectMake(self.time.frame.size.width+self.time.frame.origin.x+10, self.deleteButton.frame.origin.y, self.deleteButton.frame.size.width, self.deleteButton.frame.size.height);
    [self.paiseNum setTitle:[NSString stringWithFormat:@" %d",entity.praiseNum] forState:UIControlStateNormal];
    [self.replyNum setTitle:[NSString stringWithFormat:@" %d",entity.replyNum] forState:UIControlStateNormal];
//    [self.paiseNum setImage:[UIImage imageNamed:@"topic_praise_righttop_normal.png"] forState:UIControlStateNormal];
  self.paiseNum.selected = entity.praiseNum>0?YES:NO;
  
    self.content.text = entity.content;
    
    CGRect contentRect = [entity.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:(16)]} context:nil];

//    CGRect cRect = self.content.frame;
    int height = contentRect.size.height+1;
    self.content.frame = CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y, self.content.frame.size.width, height);
  
    if([CTStringUtil stringNotBlank:entity.replyData.uid]){
        self.replyView.hidden = NO;
        self.replySubNum.text = [NSString stringWithFormat:@"更多%d条回复>",entity.replyNum];
        self.replyView.hidden = ![CTStringUtil stringNotBlank:entity.replyData.uid];
        self.replyUserName.text = [NSString stringWithFormat:@"%@:",entity.replyData.userName];
        self.replyContent.text = entity.replyData.content;
        
        CGRect replyContentRect = [entity.replyData.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
        CGRect replyContentRectOld =  self.replyContent.frame;
        replyContentRectOld.size.height = replyContentRect.size.height;
        self.replyContent.frame = replyContentRectOld;
        self.replyView.frame = CGRectMake(self.replyView.frame.origin.x, CGRectGetMaxY(self.content.frame)+10, self.replyView.frame.size.width, 60+replyContentRect.size.height);
        self.replySubNum.frame = CGRectMake(self.replySubNum.frame.origin.x, CGRectGetMaxY(self.replyContent.frame)+10, self.replySubNum.frame.size.width, self.replySubNum.frame.size.height);
        self.replyLine.frame = CGRectMake(self.replyLine.frame.origin.x, self.replyLine.frame.origin.y, 2, CGRectGetMaxY(self.replyContent.frame));
    }else{
        self.replyView.hidden = YES;
        CGRect old = self.replyView.frame;
        old.size.height = 0;
        self.replyView.frame = old;
    }
}
- (IBAction)praiseAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    if(comment.isPraise == 1){
        [[CTToast makeText:@"你已赞过"]show:[UIApplication sharedApplication].keyWindow];
        [self updateItem:comment];
    }else{
        comment.praiseNum += 1;
        comment.isPraise = 1;
        [self updateItem:comment];
      [[[HeadlineBiz alloc]init]topicCommentPraiseWithInfoId:comment.infoId commentId:comment.commentId type:comment.type success:^{
            
        } fail:^(NSError *error) {
            if(error.code == 120104){//您已赞过
                comment.isPraise = 1;
            }else{
                comment.praiseNum -= 1;
                comment.isPraise = 0;
            }
            [weakSelf updateItem:comment];
        }];
    }
}
- (IBAction)commentAction:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(callbackToTopicCommentController:)]){
        [self.delegate callbackToTopicCommentController:self];
    }
}

- (IBAction)deleteClick:(UIButton *)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(callbackToDeleteController:)]) {
    [self.delegate callbackToDeleteController:self];
  }
}

@end
