//
//  CGUserHeaderCollectionViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserHeaderCollectionViewCell.h"

@implementation CGUserHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)updateData:(NSString *)str{
  NSMutableAttributedString *colorContentString = [[NSMutableAttributedString alloc] initWithString:str];
  [colorContentString addAttribute:NSForegroundColorAttributeName value:[CTCommonUtil convert16BinaryColor:@"#0C95E5"] range:NSMakeRange(0, str.length-1)];
  [colorContentString addAttribute:NSForegroundColorAttributeName value:[CTCommonUtil convert16BinaryColor:@"#B3B3B3"] range:NSMakeRange(str.length-1, 1)];
  [colorContentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:NSMakeRange(0, str.length-1)];
  [colorContentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:10.0] range:NSMakeRange(str.length-1, 1)];
  self.numberLabel.attributedText = colorContentString;
}
@end
