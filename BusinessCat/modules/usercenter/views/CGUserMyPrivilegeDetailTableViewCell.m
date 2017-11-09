//
//  CGUserMyPrivilegeDetailTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserMyPrivilegeDetailTableViewCell.h"

@implementation CGUserMyPrivilegeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleWithArray:(NSArray *)titleArray unitWithArray:(NSArray *)unitArray numberWithArray:(NSArray *)numberArray{
  for (int i=0; i<titleArray.count; i++) {
    UILabel *titleLabel = [self.TitleLabel objectAtIndex:i];
    titleLabel.text = [titleArray objectAtIndex:i];
    
    UILabel *numberLabel = [self.numberLabel objectAtIndex:i];
    NSString *number = [NSString stringWithFormat:@"%@%@",[numberArray objectAtIndex:i],[unitArray objectAtIndex:i]];
    NSMutableAttributedString *colorContentString = [[NSMutableAttributedString alloc] initWithString:number];
    [colorContentString addAttribute:NSForegroundColorAttributeName value:[CTCommonUtil convert16BinaryColor:@"#B3B3B3"] range:NSMakeRange(0, number.length)];
    if ([[numberArray objectAtIndex:i]intValue] != 0) {
      [colorContentString addAttribute:NSForegroundColorAttributeName value:[CTCommonUtil convert16BinaryColor:@"#0C95E5"] range:NSMakeRange(0, number.length-1)];
    }
    [colorContentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:NSMakeRange(0, number.length-1)];
    [colorContentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:10.0] range:NSMakeRange(number.length-1, 1)];
    numberLabel.attributedText = colorContentString;
  }
}

@end
