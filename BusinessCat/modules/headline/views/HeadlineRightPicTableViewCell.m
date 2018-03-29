//
//  HeadlineRightPicTableViewCell.m
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadlineRightPicTableViewCell.h"
#import "UIColor+colorToImage.h"

@interface HeadlineRightPicTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contextTypeWidth;

@property (weak, nonatomic) IBOutlet UIImageView *collectionIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *relevantInformationLeading;

@end

@implementation HeadlineRightPicTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
    
    self.contextTypeWidth.constant = 0;
    self.contentType.hidden = YES;

  self.contentView.clipsToBounds = YES;
  self.contentType.layer.borderWidth = 0.5;
  self.contentType.layer.borderColor = CTThemeMainColor.CGColor;
  self.contentType.layer.cornerRadius = 2;
  self.contentType.textColor = CTThemeMainColor;
  //    self.relevantInformation.textColor = CTThemeMainColor;
  self.contentType.alpha = 0.6;
  //  self.relevantInformation.alpha = 0.6;
  self.line.backgroundColor = CTCommonLineBg;
  //    self.contentSourceImage.layer.cornerRadius = 2;
}

- (IBAction)closeAction:(id)sender {
  UIButton *close = sender;
  if(self.delegate && [self.delegate respondsToSelector:@selector(headlineCloseInfoCallBack:cell:closeBtnY:)]){
    [self.delegate headlineCloseInfoCallBack:self.info cell:self closeBtnY:CGRectGetMaxY(close.frame)];
  }
}


-(void)updateItem:(CGInfoHeadEntity *)info{
  self.info = info;
  //    self.title.text = info.title;
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
  if (info.title.length<=0) {
    info.title = @"";
  }
  // 调整行间距
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:info.title];
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setLineSpacing:5];
  [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, [info.title length])];
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [info.title length])];
  self.title.attributedText = attributedString;
  
//  if([CTStringUtil stringNotBlank:info.label]){
//    self.contentType.hidden = NO;
//    self.contentType.text = info.label;
//    [self.contentType sizeToFit];
//    self.contextTypeWidth.constant = self.contentType.frame.size.width + 5;
//    self.relevantInformationLeading.constant = 5;
//  }else{
//    self.contentType.hidden = YES;
//    self.contentType.text = @"";
//    self.contextTypeWidth.constant = 0;
//    self.relevantInformationLeading.constant = 0;
//  }
  
  if (self.timeType == 2 ||self.timeType == 3) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (self.timeType == 2) {
     [formatter setDateFormat:@"YYYY年MM月"];
    }else{
     [formatter setDateFormat:@"MM月dd日 hh:mm"];
      info.isSubscribe = NO;
      info.isFollow = NO;
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:info.createtime/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    if ([CTStringUtil stringNotBlank:info.label2]) {
      self.time.text = [NSString stringWithFormat:@"%@ %@",info.label2,confromTimespStr];
    }else{
      self.time.text = confromTimespStr;
    }
    self.contentType.hidden = YES;
    self.contentType.text = @"";
    self.relevantInformationLeading.constant = 0;
    self.contextTypeWidth.constant = 0;
  }else if (self.timeType == 4){
    if ([CTStringUtil stringNotBlank:info.label2]) {
      self.time.text = [NSString stringWithFormat:@"%@ %@",info.label2,[CTDateUtils getTimeFormatFromDateLong:info.createtime]];
    }else{
      self.time.text = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
    }
    self.contentType.hidden = YES;
    self.contentType.text = @"";
    self.relevantInformationLeading.constant = 0;
    self.contextTypeWidth.constant = 0;
  }else{
    if (self.timeType == 1) {
      if (![info.label isEqualToString:@"专辑"]) {
        info.label = @"";
      }
    }
    if ([CTStringUtil stringNotBlank:info.label2]) {
      self.time.text = [NSString stringWithFormat:@"%@ %@",info.label2,[CTDateUtils getTimeFormatFromDateLong:info.createtime]];
    }else{
      self.time.text = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
    }
    if([CTStringUtil stringNotBlank:info.label]){
      self.contentType.hidden = NO;
      self.contentType.text = info.label;
      self.relevantInformationLeading.constant = 5;
      [self.contentType sizeToFit];
      self.contextTypeWidth.constant = self.contentType.frame.size.width + 5;
    }else{
      self.contentType.hidden = YES;
      self.contentType.text = @"";
      self.relevantInformationLeading.constant = 0;
      self.contextTypeWidth.constant = 0;
    }
  }
  
  if (info.isSubscribe) {
    self.collectionIV.hidden = NO;
    self.collectionIV.image = [UIImage imageNamed:@"toutiaoyanjing"];
  }else if (info.isFollow){
    self.collectionIV.hidden = NO;
    self.collectionIV.image = [UIImage imageNamed:@"toutiaoshoucang"];
  }else{
    self.collectionIV.hidden = YES;
  }
  if(info.imglist && info.imglist.count > 0){
    NSDictionary *dict = info.imglist[0];
    NSString *imageUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"src"]];
    [self.picture sd_setImageWithURL:[NSURL URLWithString:[CTStringUtil stringNotBlank:imageUrl]?imageUrl:@""] placeholderImage:[UIImage imageNamed:@"morentu"]];
  }else{
    [self.picture sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"morentu"]];
  }
  
  self.picture.layer.borderColor = CTCommonLineBg.CGColor;
  self.picture.layer.borderWidth = 0.5;
  
  if(info.read == 1){
    self.title.textColor = [UIColor grayColor];
  }else{
    self.title.textColor = TEXT_MAIN_CLR;
  }
  
    // 老板让隐藏的
    self.contextTypeWidth.constant = 0;
    self.contentType.hidden = YES;

  [self autolayout];
}

- (void)autolayout{
  //设置布局
  CGFloat textWith = 0.0;
  [self.time sizeToFit];
  [self.relevantInformation sizeToFit];
  textWith = self.contextTypeWidth.constant+5+self.time.frame.size.width+5+self.relevantInformation.frame.size.width+5;
  
  CGFloat isFollow = (self.info.isFollow == 1||self.info.isSubscribe == 1)?22.0f:0.0f;
  CGFloat width = (SCREEN_WIDTH-50)/3*2;
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
  if (textWith>width-isFollow||fontSize==24) {
    self.closeTrailing.constant = 10.0f;
    self.height = 135.0f;
    self.isCenter = NO;
  }else{
    self.closeTrailing.constant = (SCREEN_WIDTH-50)/3+20;
    self.height = 105.0f;
    self.isCenter = YES;
  }
  
//  if (self.info.relevantInfoList.count == 1) {
//    self.height = self.height+60;
//  }else if (self.info.relevantInfoList.count > 1){
//    self.height = self.height+30;
//  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
