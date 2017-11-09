
//
//  CGTopicToolBar.m
//  CGSays
//
//  Created by zhu on 2017/1/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGTopicToolBar.h"

@interface CGTopicToolBar ()
@property (weak, nonatomic) IBOutlet UIButton *topicButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *factButton;
@property (nonatomic, assign) BOOL isDetail;
@end

@implementation CGTopicToolBar

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [[NSBundle mainBundle]loadNibNamed:@"CGTopicToolBar" owner:self options:nil];
    [self addSubview:self.view];
    [self.topicButton setBackgroundImage:[CTCommonUtil generateImageWithColor:CTCommonLineBg size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *fact = [ user objectForKey:@"fact"];
    self.fact.hidden = fact.boolValue;
    NSNumber *share = [user objectForKey:@"share"];
    self.share.hidden = share.boolValue;
  }
  return self;
}

-(void)updatePraise:(int)praiseNum{
  if(praiseNum <= 0){
    self.leftButton.selected = NO;
  }else{
    self.leftButton.selected = YES;
  }
}

-(void)updateToolBar:(CGInfoDetailEntity *)detail isDetail:(BOOL)isDetail comment:(CGCommentEntity *)comment{
  self.detail = detail;
  self.isDetail = isDetail;
  if (isDetail) {
    [self.leftButton setImage:[UIImage imageNamed:@"like_a"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"soliddz"] forState:UIControlStateSelected];
    [self.rightButton setImage:[UIImage imageNamed:@"areward"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"areward"] forState:UIControlStateSelected];
    self.leftButton.selected = comment.praiseNum <= 0?NO:YES;
  }else{
    self.leftButton.selected = self.detail.isFollow?YES:NO;
  }
    [self.topicButton setTitle:@"我要评论..." forState:UIControlStateNormal];
}

- (IBAction)enjoyClick:(UIButton *)sender {
  if (self.isDetail) {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(detailToolbarCommentTypeAction)]) {
      [self.delegate detailToolbarCommentTypeAction];
    }
  }else{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(detailToolBarCollectAction)]) {
      [self.delegate detailToolBarCollectAction];
    }
  }
  
}
- (IBAction)factClick:(UIButton *)sender {
  if (self.detail) {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(detailToolbarScoopAction)]) {
      [self.delegate detailToolbarScoopAction];
    }
  }
}

- (IBAction)shareClick:(UIButton *)sender {
  if (self.isDetail) {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(detailToolbarEnjoyAction)]) {
      [self.delegate detailToolbarEnjoyAction];
    }
  }else{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(detailToolbarShareAction)]) {
      [self.delegate detailToolbarShareAction];
    }
  }
}

- (IBAction)openTopicAction:(UIButton *)sender {
  [self openTopicAction2];
}

-(void)openTopicAction2{
  if(self.delegate && [self.delegate respondsToSelector:@selector(detailToolbarOpenTopicCommentAction)]){
    [self.delegate detailToolbarOpenTopicCommentAction];
  }
}

@end
