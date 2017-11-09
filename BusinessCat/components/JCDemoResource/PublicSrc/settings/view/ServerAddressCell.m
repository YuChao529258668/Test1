//
//  ServerAddressCell.m
//  UltimateShow
//
//  Created by young on 16/12/17.
//  Copyright © 2016年 young. All rights reserved.
//

#import "ServerAddressCell.h"

@implementation ServerAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)setDefault:(id)sender {
    if (_buttonAction) {
        _buttonAction(self.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
