//
//  CGReleaseTextViewTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGReleaseTextViewTableViewCell.h"

@interface CGReleaseTextViewTableViewCell ()<UITextViewDelegate>

@end

@implementation CGReleaseTextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.textView.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidChange:(UITextView *)textView {
  if (textView.text.length>0) {
    self.placeholder.hidden = YES;
  }else{
    self.placeholder.hidden = NO;
  }
}

@end
