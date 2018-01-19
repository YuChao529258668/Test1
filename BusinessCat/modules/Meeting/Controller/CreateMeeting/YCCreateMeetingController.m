//
//  YCCreateMeetingController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/18.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCCreateMeetingController.h"

@interface YCCreateMeetingController ()

@end

@implementation YCCreateMeetingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configViews];
}

#pragma mark - Actions

- (IBAction)dismiss:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickVideoBtn:(id)sender {
}
- (IBAction)clickVoiceBtn:(id)sender {
}
- (IBAction)clickLiveBtn:(id)sender {
}
- (IBAction)clickDateBtn:(id)sender {
}
- (IBAction)clickBeginTimeBtn:(id)sender {
}
- (IBAction)clickEndTimeBtn:(id)sender {
}
- (IBAction)clickDurationBtn:(id)sender {
}
- (IBAction)clickBtn4:(id)sender {
}
- (IBAction)clickBtn8:(id)sender {
}
- (IBAction)clickBtn16:(id)sender {
}
- (IBAction)clickCreateMeetingBtn:(id)sender {
}

#pragma mark - 界面配置

- (void)configViews {
    UIImage *Image = self.blockIV.image;
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 4, 4, 4);
    Image = [Image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.blockIV.image = Image;
    
    
}



@end
