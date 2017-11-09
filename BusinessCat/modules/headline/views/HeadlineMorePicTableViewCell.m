//
//  HeadlineMorePicTableViewCell.m
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadlineMorePicTableViewCell.h"

@interface HeadlineMorePicTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contextTypeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *relevantInformationLeading;

@end

@implementation HeadlineMorePicTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.contentView.clipsToBounds = YES;
  self.contentType.layer.borderWidth = 0.5;
  self.contentType.layer.borderColor = CTThemeMainColor.CGColor;
  self.contentType.layer.cornerRadius = 2;
  self.contentType.textColor = CTThemeMainColor;
  self.contentType.alpha = 0.6;
  self.line.backgroundColor = CTCommonLineBg;
  
}

- (IBAction)closeAction:(id)sender {
  UIButton *close = sender;
  if(self.delegate && [self.delegate respondsToSelector:@selector(headlineCloseInfoCallBack:cell:closeBtnY:)]){
    [self.delegate headlineCloseInfoCallBack:self.info cell:self closeBtnY:CGRectGetMaxY(close.frame)];
  }
}

-(void)updateItem:(CGInfoHeadEntity *)info{
  if (self.timeType == 2 ||self.timeType == 3) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (self.timeType == 3) {
      [formatter setDateFormat:@"MM月dd日 hh:mm"];
    }else{
     [formatter setDateFormat:@"YYYY年MM月"];
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:info.createtime/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    self.time.text = confromTimespStr;
    self.contentType.hidden = YES;
    self.contentType.text = @"";
    self.relevantInformationLeading.constant = 0;
    self.contextTypeWidth.constant = 0;
  }else if (self.timeType == 4){
    self.time.text = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
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
    self.time.text = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
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
  if(info.imglist.count >= 3){
    NSDictionary *dict0 = info.imglist[0];
    NSDictionary *dict1 = info.imglist[1];
    NSDictionary *dict2 = info.imglist[2];
    NSString *url1 = [dict0 objectForKey:@"src"];
    NSString *url2 = [dict1 objectForKey:@"src"];
    NSString *url3 = [dict2 objectForKey:@"src"];
    if([CTStringUtil stringNotBlank:url1]){
      [self.image1 sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"morentu"]];
    }
    if([CTStringUtil stringNotBlank:url2]){
      [self.image2 sd_setImageWithURL:[NSURL URLWithString:url2] placeholderImage:[UIImage imageNamed:@"morentu"]];
    }
    if([CTStringUtil stringNotBlank:url3]){
      [self.image3 sd_setImageWithURL:[NSURL URLWithString:url3] placeholderImage:[UIImage imageNamed:@"morentu"]];
    }
  }
  
//  self.time.text = [CTDateUtils getTimeFormatFromDateLong:info.createtime];
  self.image1.layer.borderColor = CTCommonLineBg.CGColor;
  self.image1.layer.borderWidth = 0.5;
  self.image2.layer.borderColor = CTCommonLineBg.CGColor;
  self.image2.layer.borderWidth = 0.5;
  self.image3.layer.borderColor = CTCommonLineBg.CGColor;
  self.image3.layer.borderWidth = 0.5;
  
  [self.contentType sizeToFit];
  
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
  self.info = info;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[CTStringUtil stringNotBlank:info.title]?info.title:@""];
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setLineSpacing:5];
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [info.title length])];
  [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, [info.title length])];
  self.title.attributedText = attributedString;
  CGSize titleSize =  [attributedString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, (fontSize*2+20)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
  self.title.lineBreakMode = NSLineBreakByTruncatingTail;
  self.titleHeight.constant = titleSize.height+5;
  self.height = 147+titleSize.height;
  if(info.read == 1){
    self.title.textColor = [UIColor grayColor];
  }else{
    self.title.textColor = TEXT_MAIN_CLR;
  }
  
  if ([CTStringUtil stringNotBlank:info.label2]) {
    self.self.channelX.constant = 7.0f;
    self.relevantInformation.text = info.label2;
  }else{
    self.relevantInformation.text = @"";
    self.self.channelX.constant = 0;
  }
  
}

+(CGFloat)height:(CGInfoHeadEntity *)info{
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
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[CTStringUtil stringNotBlank:info.title]?info.title:@""];
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setLineSpacing:5];
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [info.title length])];
  [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, [info.title length])];
  CGSize titleSize =  [attributedString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, (fontSize*2+20)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
  return 147+titleSize.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
