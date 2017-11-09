//
//  AttentionListCell.m
//  CGSays
//
//  Created by mochenyang on 2016/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "AttentionListCell.h"

@interface AttentionListCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;

@end

@interface AttentionListCell(){
    
    __weak IBOutlet UILabel *lastDataTitle;
    __weak IBOutlet UIImageView *icon;
    __weak IBOutlet UILabel *title;
    
    __weak IBOutlet UILabel *desc;
    
    __weak IBOutlet UILabel *company;
    
    __weak IBOutlet UILabel *address;
    
    __weak IBOutlet UILabel *dataNum;
    
    __weak IBOutlet UILabel *time;
    
    __weak IBOutlet UILabel *subjectNum;
    
    __weak IBOutlet UILabel *lastDataNum;
    
}

@end

@implementation AttentionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    icon.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:0.8]CGColor];
    icon.layer.borderWidth = 0.3;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)updateItem:(AttentionHead *)entity{
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
    desc.font = [UIFont systemFontOfSize:(fontSize-3)];
    title.font = [UIFont systemFontOfSize:fontSize];
  CGFloat titleHeight = title.frame.size.height;
  titleHeight = fontSize;
  desc.frame = CGRectMake(desc.frame.origin.x, 75-(fontSize+3), desc.frame.size.width, fontSize-3);
  
    if([CTStringUtil stringNotBlank:entity.icon]){
        [icon sd_setImageWithURL:[NSURL URLWithString:entity.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
    }else{
        icon.image = [UIImage imageNamed:@"morentuzhengfangxing"];
    }
    title.text = entity.title;
    desc.text = entity.desc;
    NSString *lastDataNumStr = [NSString stringWithFormat:@"%d",entity.newNum];
    if(entity.newNum > 999){
        lastDataNumStr = @"999";
    }
  
  if (entity.newNum==0) {
    lastDataTitle.textColor = [CTCommonUtil convert16BinaryColor:@"#c3c3c3"];
    lastDataNum.textColor   = [CTCommonUtil convert16BinaryColor:@"#c3c3c3"];
  }else{
    lastDataTitle.textColor = [CTCommonUtil convert16BinaryColor:@"#FF7F00"];
    lastDataNum.textColor   = [CTCommonUtil convert16BinaryColor:@"#FF7F00"];
  }
  
    lastDataNum.text = lastDataNumStr;
//    company.text = entity.source;
//    address.text = entity.address;
    dataNum.text = [NSString stringWithFormat:@"%d数据",entity.countNum];
    time.text = [CTDateUtils getTimeFormatFromDateLong:entity.createtime];
    subjectNum.text = [NSString stringWithFormat:@"%d关注",entity.subscribeNum];
  
  subjectNum.hidden = YES;
//  if ([entity.prompt isEqualToString:@"对手"]) {
//    subjectNum.hidden = YES;
//  }else{
//    subjectNum.hidden = NO;
//  }
    float start = 0;
  if ([entity.label isEqualToString:@"公司"]) {
    self.titleX.constant = 15;
    self.titleHeight.constant = 55;
    title.numberOfLines = 2;
    desc.hidden = YES;
    icon.hidden = YES;
    company.text = @"";
    address.text = @"";
  }else if ([entity.label isEqualToString:@"产品"]){
    self.titleHeight.constant = 55;
    title.numberOfLines = 2;
    desc.hidden = YES;
    company.text = entity.source;
    address.text = @"";
  }else if ([entity.label isEqualToString:@"人物"]){
    company.text = entity.source;
    address.text = @"";
  }else{
    company.text = entity.source;
    address.text = entity.address;
  }
    //设置布局
    CGRect companyRect = company.frame;
    [company sizeToFit];
    companyRect.size.width = company.frame.size.width;
    company.frame = companyRect;
    start += CGRectGetMaxX(company.frame);
    
    CGRect addressRect = address.frame;
    [address sizeToFit];
    addressRect.size.width = address.frame.size.width;
    if(addressRect.size.width > 100){
        addressRect.size.width = 100;
    }
  addressRect.origin.x = start+(company.frame.size.width==0?0:5);
    address.frame = addressRect;
    start += address.frame.size.width+(company.frame.size.width==0?0:5);
    
    CGRect dataNumRect = dataNum.frame;
    [dataNum sizeToFit];
    dataNumRect.size.width = dataNum.frame.size.width;
    dataNumRect.origin.x = start+(address.frame.size.width==0?0:5);
    dataNum.frame = dataNumRect;
    start += dataNum.frame.size.width+(address.frame.size.width==0?0:5);
    
    CGRect timeRect = time.frame;
    [time sizeToFit];
    timeRect.size.width = time.frame.size.width;
    timeRect.origin.x = start+(dataNum.frame.size.width==0?0:5);
    time.frame = timeRect;
    start += time.frame.size.width+(dataNum.frame.size.width==0?0:5);
    
    CGRect subjectRect = subjectNum.frame;
    [subjectNum sizeToFit];
    subjectRect.size.width = subjectNum.frame.size.width + 20;
    subjectRect.origin.x = start+(time.frame.size.width==0?0:5);
    subjectNum.frame = subjectRect;
    
//    CGRect lastDataNumRect = lastDataNum.frame;
//    [lastDataNum sizeToFit];
//    lastDataNumRect.size.width = lastDataNum.frame.size.width;
//    if(lastDataNumRect.size.width < 45){
//        lastDataNumRect.size.width = 45;
//    }
//    lastDataNumRect.origin.x = self.contentView.frame.size.width - lastDataNumRect.size.width - 15;
//    lastDataNum.frame = lastDataNumRect;
//    lastDataTitle.frame = CGRectMake(lastDataNumRect.origin.x, lastDataTitle.frame.origin.y, lastDataNumRect.size.width, lastDataTitle.frame.size.height);
}

@end
