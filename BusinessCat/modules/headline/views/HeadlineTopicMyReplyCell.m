//
//  HeadlineTopicMyReplyCell.m
//  CGSays
//
//  Created by zhu on 2017/1/3.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "HeadlineTopicMyReplyCell.h"
#import "HeadlineBiz.h"

@interface HeadlineTopicMyReplyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *commentNum;
@property(nonatomic,retain)CGCommentEntity *comment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHight;
@property(nonatomic,assign)BOOL parent;
@end

@implementation HeadlineTopicMyReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateItem:(CGCommentEntity *)item parent:(BOOL)parent{
  self.comment = item;
  self.parent = parent;
//  if([CTStringUtil stringNotBlank:item.portrait]){
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.portrait] placeholderImage:[UIImage imageNamed:@"user_icon"]];
//  }
  if([CTStringUtil stringNotBlank:item.userName]){
    self.userName.text = item.userName;
  }else{
    self.userName.text = @"匿名";
  }
  
  self.time.text = [CTDateUtils getTimeFormatFromDateLong:item.time];
  [self.commentNum setTitle:[NSString stringWithFormat:@" %d",item.replyNum] forState:UIControlStateNormal];
  if([CTStringUtil stringNotBlank:item.replyData.uid] && [item.replyData.uid rangeOfString:@"null"].location == NSNotFound && !parent){
    NSString *text = [NSString stringWithFormat:@"%@//@%@:%@",item.content,item.replyData.userName,item.replyData.content];
    self.content.text = text;
    CGRect contentRect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
    
    CGRect cRect = self.content.frame;
    cRect.size.height = contentRect.size.height;
    self.content.frame = cRect;
  }else{
    self.content.text = item.content;
    CGRect contentRect = [item.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
  
    self.contentHight.constant = contentRect.size.height;
  }
}

- (IBAction)commentAction:(UIButton *)sender {
  if(self.delegate && [self.delegate respondsToSelector:@selector(callbackToTopicMyCommentController:)]){
    [self.delegate callbackToTopicMyCommentController:self];
  }
}

@end
