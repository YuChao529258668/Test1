//
//  YCSpaceController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/25.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCSpaceController.h"
#import "CGMeetingListViewController.h"
#import "YCSeeBoardController.h"

@interface YCSpaceController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *meetingBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeBoardBtn;

@property (nonatomic, strong) CGMeetingListViewController *meetingVC;
@property (nonatomic, strong) YCSeeBoardController *seeBoardVC;
@property (nonatomic, strong) UIView *buttonLine;

@end

@implementation YCSpaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGMeetingListViewController *mc = [CGMeetingListViewController new];
    [self addChildViewController:mc];
    self.meetingVC = mc;
    [self.containerView addSubview:mc.view];
    
    YCSeeBoardController *sc = [YCSeeBoardController new];
    [self addChildViewController:sc];
    self.seeBoardVC = sc;
    [self.containerView addSubview:sc.view];
    
    [self clickMeetingBtn:self.meetingBtn];
    
    [self.meetingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.meetingBtn setTitleColor:[YCTool colorOfHex:0x777777] forState:UIControlStateNormal];
    [self.seeBoardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.seeBoardBtn setTitleColor:[YCTool colorOfHex:0x777777] forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.meetingVC.view.frame = self.containerView.bounds;
    self.seeBoardVC.view.frame = self.containerView.bounds;
}

- (IBAction)clickMeetingBtn:(UIButton *)sender {
    [self.containerView bringSubviewToFront:self.meetingVC.view];
    [sender addSubview:self.buttonLine];
    sender.selected = YES;
    self.seeBoardBtn.selected = NO;
}
- (IBAction)clickSeeBoardBtn:(UIButton *)sender {
    [self.containerView bringSubviewToFront:self.seeBoardVC.view];
    [sender addSubview:self.buttonLine];
    sender.selected = YES;
    self.meetingBtn.selected = NO;
}

- (UIView *)buttonLine {
    if (!_buttonLine) {
        _buttonLine = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 46, 1)];
        _buttonLine.backgroundColor = [UIColor blackColor];
    }
    return _buttonLine;
}
@end
