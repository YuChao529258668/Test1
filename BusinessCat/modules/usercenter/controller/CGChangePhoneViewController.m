//
//  CGChangePhoneViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/7/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGChangePhoneViewController.h"

@interface CGChangePhoneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation CGChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.phoneLabel.text = [ObjectShareTool sharedInstance].currentUser.phone;
  self.button.layer.cornerRadius = 4;
  self.button.layer.masksToBounds = YES;
  self.button.backgroundColor = CTThemeMainColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
