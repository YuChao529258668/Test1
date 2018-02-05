//
//  CGDetailToolBar.m
//  CGSays
//
//  Created by mochenyang on 2016/9/29.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDetailToolBar.h"

@implementation CGDetailToolBar

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle mainBundle]loadNibNamed:@"CGDetailToolBar" owner:self options:nil];
        [self addSubview:self.view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openTopicMainControllerAction)];
        [self.topicImage addGestureRecognizer:tap];
        
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openCollectAction)];
        [self.collectImage addGestureRecognizer:tap];
       
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openScoopAction)];
        [self.scoopImage addGestureRecognizer:tap];
        
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openShareAction)];
        [self.shareImage addGestureRecognizer:tap];
        [self.topicButton setBackgroundImage:[CTCommonUtil generateImageWithColor:CTCommonLineBg size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    }
    return self;
}

-(void)updateToolBar:(CGInfoDetailEntity *)detail isDocument:(NSInteger)isDocument{
    self.detail = detail;
    self.isDocument = isDocument;
    self.collectImage.image = [UIImage imageNamed:self.detail.isFollow == 1 ? @"headline_collect_select" : @"headline_collect_normal"];
    if(self.detail.commentCount <= 0){
        self.commentNum.text = @"";
        self.topicImage.image = [UIImage imageNamed:@"headline_comment_icon"];
    }else{
        self.commentNum.text = [NSString stringWithFormat:@"%ld",self.detail.commentCount];
        self.topicImage.image = [UIImage imageNamed:@"topic_commentNum_hasNum_righttop"];
    }
  
  if (isDocument == 1) {
    [self.topicButton setTitle:@"我要评论..." forState:UIControlStateNormal];
    [self.topicButton setUserInteractionEnabled:YES];
  }else if (isDocument == 2) {
    if ([CTStringUtil stringNotBlank:self.detail.qiniuUrl]) {
      [self.topicButton setTitle:@"打开文档" forState:UIControlStateNormal];
      [self.topicButton setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
      [self.topicButton setUserInteractionEnabled:YES];
      [self.topicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
      [self.topicButton setTitle:@"暂无文档" forState:UIControlStateNormal];
      [self.topicButton setUserInteractionEnabled:NO];
    }
  }else if(isDocument == 3){
    [self.topicButton setTitle:[NSString stringWithFormat:@"支付%ld金币后全部查看",detail.integral] forState:UIControlStateNormal];
    [self.topicButton setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.topicButton setUserInteractionEnabled:YES];
    [self.topicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  }else if (isDocument == 4){
    [self.topicButton setTitle:@"工具网址" forState:UIControlStateNormal];
    [self.topicButton setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.topicButton setUserInteractionEnabled:YES];
    [self.topicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  }else if (isDocument == 5){
    [self.topicButton setTitle:@"下载文档" forState:UIControlStateNormal];
    [self.topicButton setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.topicButton setUserInteractionEnabled:YES];
    [self.topicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  }
  
//  NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//  NSNumber *fact = [ user objectForKey:@"fact"];
//  self.admireButton.hidden = fact.boolValue;
//  NSNumber *share = [user objectForKey:@"share"];
//  self.prizeButton.hidden = share.boolValue;
}

- (IBAction)openTopicAction:(id)sender {
  if (self.isDocument == 1) {
    [self openTopicAction2];
  }else if (self.isDocument ==2){
    if ([CTStringUtil stringNotBlank:self.detail.qiniuUrl]) {
      if(self.delegate && [self.delegate respondsToSelector:@selector(detailToolbarDocumentAction)]){
        [self.delegate detailToolbarDocumentAction];
      }
    }
  }else if (self.isDocument == 3){
    if(self.delegate && [self.delegate respondsToSelector:@selector(detailToolbarPayFeeAction)]){
      [self.delegate detailToolbarPayFeeAction];
    }
  }else if(self.isDocument == 4){
    if(self.delegate && [self.delegate respondsToSelector:@selector(detailToolbarAccessWebSitesAction)]){
      [self.delegate detailToolbarAccessWebSitesAction];
    }
  }else if (self.isDocument == 5){
    if(self.delegate && [self.delegate respondsToSelector:@selector(detailToolbarDownloadDocumentAction)]){
      [self.delegate detailToolbarDownloadDocumentAction];
    }
  }
}

-(void)webViewDidFinish{
  [self.topicButton setUserInteractionEnabled:YES];
  [self.topicImage setUserInteractionEnabled:YES];
  [self.collectImage setUserInteractionEnabled:YES];
  [self.scoopImage setUserInteractionEnabled:YES];
  [self.shareImage setUserInteractionEnabled:YES];
}

-(void)openTopicAction2{
    if(self.delegate && [self.delegate respondsToSelector:@selector(detailToolbarOpenTopicCommentAction)]){
        [self.delegate detailToolbarOpenTopicCommentAction];
    }
}

-(void)openTopicMainControllerAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(openTopicMainControllerAction)]){
        [self.delegate openTopicMainControllerAction];
    }
}

-(void)openCollectAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(detailToolbarCollectAction)]){
        [self.delegate detailToolbarCollectAction];
    }
}

-(void)openScoopAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(detailToolbarScoopAction)]){
        [self.delegate detailToolbarScoopAction];
    }
}

-(void)openShareAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(detailToolbarShareAction)]){
        [self.delegate detailToolbarShareAction];
    }
}

@end
