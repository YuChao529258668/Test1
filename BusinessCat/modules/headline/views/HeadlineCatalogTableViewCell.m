//
//  HeadlineCatalogTableViewCell.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/26.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "HeadlineCatalogTableViewCell.h"

@implementation HeadlineCatalogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.image = [UIImage imageNamed:@"documentdirectory"];
    self.line.backgroundColor = CTCommonLineBg;
    self.textLabel.font = [UIFont systemFontOfSize:16];
}

-(void)updateItem:(CGInfoHeadEntity *)info{
    self.textLabel.text = info.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- ( void )layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(14,15,22,22);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;

    CGRect tmpFrame = self.textLabel.frame ;
    tmpFrame.origin.x = CGRectGetMaxX(self.imageView.frame)+10;
    self.textLabel.frame = tmpFrame;
    
    tmpFrame = self.detailTextLabel.frame ;
    tmpFrame.origin.x = CGRectGetMaxX(self.imageView.frame)+10;
    self.detailTextLabel.frame = tmpFrame;
    
}

@end
