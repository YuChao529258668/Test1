//
//  RoomStateView.m
//  BusinessCat
//
//  Created by 余超 on 2018/4/20.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "RoomStateView.h"

@interface RoomStateView()
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *bar;
@property (weak, nonatomic) IBOutlet UIView *welcomeView;
@property (weak, nonatomic) IBOutlet UILabel *onlineCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval seconds;

@end


@implementation RoomStateView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.welcomeView.hidden = YES;
    [self.backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.avatarIV.clipsToBounds = YES;
    self.rightView.hidden = YES;
    self.welcomeView.hidden = YES;
    
    NSString *textStr = @"录像回放";
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName: CTThemeMainColor};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    [self.playBtn  setAttributedTitle:attribtStr forState:UIControlStateNormal];
}

+ (instancetype)view {
    RoomStateView *view = [[NSBundle mainBundle] loadNibNamed:@"RoomStateView" owner:nil options:nil].firstObject;
    return view;
}

- (void)setState:(int)state {
    _state = state;
    
    NSString *imageName;
    //状态:0未到开会时间,1可进入（可提前5分钟），2非参会人员，3会议已结束。这个是meetingEntrance接口返回的，和会议详情接口的不一样！
    if (state == 0) {
        imageName = @"video_wait_normal";
        self.stateL.text = @"会议未开始";
        self.topStateL.text = @"未开始";
        self.playBtn.hidden = YES;
    } else if (state == 1) {
        imageName = @"video_in_normal";
        self.stateL.text = @"正在进入";
        self.topStateL.text = @"会议中";
        self.playBtn.hidden = YES;
        self.dateL.hidden = YES;
        self.countDownL.hidden = YES;
        self.bar.hidden = YES;
    } else if (state == 3) {
        imageName = @"video_over_normal";
        self.stateL.text = @"会议已结束";
        self.topStateL.text = @"已结束";
        self.playBtn.hidden = NO;
        self.dateL.hidden = YES;
        self.countDownL.hidden = YES;
    }
    self.stateIV.image = [UIImage imageNamed:imageName];
}

- (void)setBeginDate:(NSDate *)beginDate {
    _beginDate = beginDate;
    
    [self createTimer];
    [self updateDateLabel:beginDate];
}

- (void)updateOnlineCount:(NSInteger)count {
    self.onlineCountLabel.text = [NSString stringWithFormat:@"在线人数:%ld", (long)count];
}
- (void)updateTotalCount:(NSInteger)count {
    self.totalCountLabel.text = [NSString stringWithFormat:@"在线人数:%ld", (long)count];
}
- (void)updateDateLabel:(NSDate *)date {
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"YYYY年MM月dd日 HH:mm";
    self.dateL.text = [f stringFromDate:date];
}


#pragma mark - Timer

- (void)createTimer {
    self.seconds = self.beginDate.timeIntervalSinceNow;

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    self.timer = timer;
    [timer fire];
}

- (void)handleTimer {
    self.seconds --;
    if (self.seconds <= 0) {
        [self stopTimer];
    }
    NSString *text = [YCTool countDonwStringDHMWithTargetDate:self.beginDate.timeIntervalSince1970];
    self.countDownL.text = [NSString stringWithFormat:@"倒计时：%@", text];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - Action

- (IBAction)clickBarBtn:(UIButton *)sender {
    NSLog(@"clickBarBtn");
    if ([self.delegate respondsToSelector:@selector(stateView:clickBarBtn:atIndex:)]) {
        [self.delegate stateView:self clickBarBtn:sender atIndex:sender.tag];
    }
}

- (IBAction)clickBackBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickBackBtnOfStateView:)]) {
        [self.delegate clickBackBtnOfStateView:self];
    }
}

- (IBAction)clickPlayBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickPlayBtn)]) {
        [self.delegate clickPlayBtn];
    }
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

@end
