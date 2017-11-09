//
//  HeadlineOnlyTitleTableViewCell.m
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadlineOnlyTitleTableViewCell.h"
#import "CTDateUtils.h"
#import "UIColor+colorToImage.h"

@interface HeadlineOnlyTitleTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contextTypeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *relevantInformationLeading;

@end

@implementation HeadlineOnlyTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.clipsToBounds = YES;
    self.contentType.layer.borderWidth = 0.5;
    self.contentType.layer.borderColor = CTThemeMainColor.CGColor;
    self.contentType.layer.cornerRadius = 2;
    self.contentType.textColor = CTThemeMainColor;
    self.contentType.alpha = 0.6;
//    self.relevantInformation.alpha = 0.6;
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
  self.channelX.constant = 7.0f;
  if (info.isSubscribe) {
    self.collectionIV.hidden = NO;
    self.collectionIV.image = [UIImage imageNamed:@"toutiaoyanjing"];
  }else if (info.isFollow){
    self.collectionIV.hidden = NO;
    self.collectionIV.image = [UIImage imageNamed:@"toutiaoshoucang"];
  }else{
    self.collectionIV.hidden = YES;
  }
  if (self.timeType == 2  || self.timeType == 3) {
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
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:info.title.length<=0?@"":info.title];
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setLineSpacing:5];
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [info.title length])];
  [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, [info.title length])];
  self.title.attributedText = attributedString;
//  self.title.lineBreakMode = NSLineBreakByTruncatingTail;
  CGSize titleSize =  [attributedString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 50.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
  self.height = 54+titleSize.height;
  self.titleHeight.constant = titleSize.height+5;
    if(info.read == 1){
        self.title.textColor = [UIColor grayColor];
    }else{
        self.title.textColor = TEXT_MAIN_CLR;
    }
  if ([CTStringUtil stringNotBlank:info.label2]) {
    
    self.relevantInformation.text = info.label2;
    self.channelX.constant = 7.0f;
  }else{
    self.relevantInformation.text = @"";
    self.channelX.constant = 0.0f;
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
  if (info.title.length<=0) {
    info.title = @"";
  }
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:info.title.length<=0?@"":info.title];
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setLineSpacing:5];
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [info.title length])];
  [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, [info.title length])];
  CGSize titleSize =  [attributedString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 50.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
  return 54+titleSize.height;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
}

@end
