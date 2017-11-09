//
//  HeadlineLeftPicTableViewCell.m
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadlineLeftPicTableViewCell.h"

@implementation HeadlineLeftPicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.clipsToBounds = YES;
    self.contentType.layer.borderWidth = 0.5;
    self.contentType.layer.borderColor = CTThemeMainColor.CGColor;
    self.contentType.layer.cornerRadius = 2;
    self.contentType.textColor = CTThemeMainColor;
    self.contentType.alpha = 0.6;
    self.line.backgroundColor = CTCommonLineBg;
    self.leftImage.layer.borderColor = CTCommonLineBg.CGColor;
    self.leftImage.layer.borderWidth = 0.5;
}

- (IBAction)closeAction:(id)sender {
    UIButton *close = sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(headlineCloseInfoCallBack:cell:closeBtnY:)]){
        [self.delegate headlineCloseInfoCallBack:self.info cell:self closeBtnY:CGRectGetMaxY(close.frame)];
    }
}

-(void)updateItem:(CGInfoHeadEntity *)info{
    self.info = info;
  if (info.title.length>0) {
    NSInteger fontSize = 17;
    switch ([ObjectShareTool sharedInstance].settingEntity.fontSize) {
      case 1:
        fontSize = 17;
        break;
      case 2:
        fontSize = 19;
        break;
      case 3:
        fontSize = 20;
        break;
      case 4:
        fontSize = 24;
        break;
        
      default:
        break;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:info.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, [info.title length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [info.title length])];
    self.title.attributedText = attributedString;
  }else{
  self.title.text = @"";
  }
  NSString *timeStr;
  if (self.timeType == 2 || self.timeType == 3) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (self.timeType == 2) {
      [formatter setDateFormat:@"YYYY年MM月"];
    }else{
      [formatter setDateFormat:@"MM月dd日 hh:mm"];
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:info.createtime/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    timeStr = confromTimespStr;
    self.contentType.hidden = YES;
    self.contentType.text = @"";
    self.contentTypeWidth.constant = 0;
    self.timeX.constant = 0;
  }else if (self.timeType == 4){
    timeStr = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
    self.contentType.hidden = YES;
    self.contentType.text = @"";
    self.contentTypeWidth.constant = 0;
    self.timeX.constant = 0;
  }else{
    if (self.timeType == 1) {
      if (![info.label isEqualToString:@"专辑"]) {
        info.label = @"";
      }
    }
    timeStr = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
    if([CTStringUtil stringNotBlank:info.label]){
      self.contentType.hidden = NO;
      self.contentType.text = info.label;
      [self.contentType sizeToFit];
      self.timeX.constant = 5;
      self.contentTypeWidth.constant = self.contentType.frame.size.width + 5;
    }else{
      self.contentType.hidden = YES;
      self.contentType.text = @"";
      self.contentTypeWidth.constant = 0;
      self.timeX.constant = 0;
    }
  }
  
  if([CTStringUtil stringNotBlank:info.source]){
    self.time.text = [NSString stringWithFormat:@"%@ %@",info.source,timeStr];
    }else{
      self.time.text = timeStr;
    }
  
  if ([CTStringUtil stringNotBlank:info.navtype]) {
    self.time.text = [NSString stringWithFormat:@"%@ %@",info.navtype,self.time.text];
  }
  
  if ([CTStringUtil stringNotBlank:info.desc]) {
    self.titleHeight.constant = 30;
    self.desc.text = info.desc;
  }else{
    self.desc.text = @"";
    self.titleHeight.constant = 60;
  }
  
  if (self.isIntelligent) {
    if (info.type == 3) {
      [self.leftImage sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"intelligent_analytics"]];
    }else if (info.type == 4){
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"intelligent_analysis_character"]];
    }else if (info.type == 8){
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"intelligent_analysis_products"]];
    }
  }else{
  [self.leftImage sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"morentu"]];
    if (info.type == 3) {
      self.titleX.constant =15;
      self.leftImage.hidden = YES;
      self.desc.hidden = YES;
      self.titleHeight.constant = 60;
    }else{
      self.titleX.constant =85;
      self.desc.hidden = NO;
      self.leftImage.hidden = NO;
      self.titleHeight.constant = 30;
    }
  }
  
    if(info.read == 1){
        self.title.textColor = [UIColor grayColor];
    }else{
        self.title.textColor = TEXT_MAIN_CLR;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
