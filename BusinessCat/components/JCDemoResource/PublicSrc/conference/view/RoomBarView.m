//
//  RoomBarView.m
//  BusinessCat
//
//  Created by 余超 on 2018/4/17.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "RoomBarView.h"

@interface RoomBarView()
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *bar;
@property (weak, nonatomic) IBOutlet UIView *welcomeView;
@property (weak, nonatomic) IBOutlet UILabel *onlineCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end


@implementation RoomBarView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.welcomeView.hidden = YES;
    [self.backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.avatarIV.clipsToBounds = YES;
}

+ (instancetype)view {
    RoomBarView *view = [[NSBundle mainBundle] loadNibNamed:@"RoomBarView" owner:nil options:nil].firstObject;
    return view;
}

- (void)updateOnlineCount:(NSInteger)count {
    self.onlineCountLabel.text = [NSString stringWithFormat:@"在线人数:%ld", count];
}
- (void)updateTotalCount:(NSInteger)count {
    self.totalCountLabel.text = [NSString stringWithFormat:@"在线人数:%ld", count];
}

- (void)showWelcomeViewWithName:(NSString *)name show:(BOOL)show {
    self.welcomeLabel.text = [NSString stringWithFormat:@"欢迎 %@ 进入会议室", name];
    self.welcomeLabel.hidden = !show;
    if (show) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.welcomeLabel.hidden = YES;
        });
    }
}

- (IBAction)clickBarBtn:(UIButton *)sender {
    NSLog(@"clickBarBtn");
    if ([self.delegate respondsToSelector:@selector(clickBarBtn:atIndex:)]) {
        [self.delegate clickBarBtn:sender atIndex:sender.tag];
    }
}

- (IBAction)clickBackBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickBackBtn)]) {
        [self.delegate clickBackBtn];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (point.y >= 100 && point.y <= (self.bounds.size.height - 100)) {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

@end
