//
//  VerificationCodeTableViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "VerificationCodeTableViewCell.h"

@implementation VerificationCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)click:(UIButton *)sender {
 //NSTimer *timer=[NSTimer timerWithTimeInterval:1.0
  //                                target:self
 //                             selector:@selector(staticUpdateTime)
 //                             userInfo:nil
 //                              repeats:YES];
 // NSRunLoop * main=[NSRunLoop currentRunLoop];
 // [main addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)staticUpdateTime{
  NSLog(@"hahahaha");
}

@end
