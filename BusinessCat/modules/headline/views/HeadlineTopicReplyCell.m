//
//  HeadlineTopicReplyCell.m
//  CGSays
//
//  Created by mochenyang on 2016/10/13.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadlineTopicReplyCell.h"
#import "HeadlineBiz.h"

@interface HeadlineTopicReplyCell(){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *praiseNum;
@property (weak, nonatomic) IBOutlet UIButton *commentNum;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property(nonatomic,retain)CGCommentEntity *comment;
@property(nonatomic,assign)BOOL parent;

@end

@implementation HeadlineTopicReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateItem:(CGCommentEntity *)item parent:(BOOL)parent{
    self.comment = item;
    self.parent = parent;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.portrait] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    if([CTStringUtil stringNotBlank:item.userName]){
        self.userName.text = item.userName;
    }else{
        self.userName.text = @"匿名";
    }
    
    self.time.text = [CTDateUtils getTimeFormatFromDateLong:item.time];
    [self.praiseNum setTitle:[NSString stringWithFormat:@" %d",item.praiseNum] forState:UIControlStateNormal];
    [self.commentNum setTitle:[NSString stringWithFormat:@" %d",item.replyNum] forState:UIControlStateNormal];
//  [self.praiseNum setImage:[UIImage imageNamed:@"topic_praise_righttop_normal.png"] forState:UIControlStateNormal];
  if(item.isPraise){//已赞过
    [self.praiseNum setImage:[UIImage imageNamed:@"topic_praise_righttop_solid"] forState:UIControlStateNormal];
  }else{
    [self.praiseNum setImage:[UIImage imageNamed:@"topic_praise_righttop_normal"] forState:UIControlStateNormal];
  }
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
        
        CGRect cRect = self.content.frame;
        cRect.size.height = contentRect.size.height;
        self.content.frame = cRect;
    }
    
    
    
}



- (IBAction)praiseAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    if(self.comment.isPraise == 1){
        [[CTToast makeText:@"你已赞过"]show:[UIApplication sharedApplication].keyWindow];
        [self updateItem:self.comment parent:self.parent];
    }else{
        self.comment.praiseNum += 1;
        self.comment.isPraise = 1;
        [self updateItem:self.comment parent:self.parent];
      [[[HeadlineBiz alloc]init]topicCommentPraiseWithInfoId:self.comment.infoId commentId:self.comment.commentId type:self.comment.type success:^{
            
        } fail:^(NSError *error) {
            if(error.code == 120104){//您已赞过
                weakSelf.comment.isPraise = 1;
            }else{
                weakSelf.comment.praiseNum -= 1;
                weakSelf.comment.isPraise = 0;
            }
            [weakSelf updateItem:weakSelf.comment parent:weakSelf.parent];
        }];
    }
}

- (IBAction)commentAction:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(callbackToTopicCommentController:)]){
        [self.delegate callbackToTopicCommentController:self];
    }
}

@end
