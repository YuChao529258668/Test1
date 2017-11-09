//
//  AlertNewDataCountView.m
//  CGSays
//
//  Created by mochenyang on 2016/9/29.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "AlertMessageOnHeadertView.h"

@interface AlertMessageOnHeadertView()

@property(nonatomic,retain)NSTimer *timer;

-(instancetype)initWithX:(float)x y:(float)y text:(NSString *)text;

@end

@implementation AlertMessageOnHeadertView

-(void)showInView:(UIView *)view frame:(CGRect)frame{
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH, 0);
    __weak typeof(self) weakSelf = self;
    [view addSubview:self];
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9
          initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
              weakSelf.alpha = 0.87f;
              weakSelf.frame = frame;
          }completion:^(BOOL finished) {
              weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(hideAlertViewAction) userInfo:nil repeats:NO];
          }];
}

+(AlertMessageOnHeadertView *)initWithText:(NSString *)text{
    return [[AlertMessageOnHeadertView alloc]initWithX:0 y:0 text:text];
}

-(instancetype)initWithX:(float)x y:(float)y text:(NSString *)text{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    if(self){
        self.tag = 1000;
        self.alpha = 0;
        self.backgroundColor = CTThemeMainColor;
        self.text = text;
        self.clipsToBounds = YES;
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

-(void)hideAlertViewAction{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2.0f delay:0 usingSpringWithDamping:0.9
          initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
              weakSelf.alpha = 0;
              weakSelf.frame = CGRectMake(weakSelf.frame.origin.x, weakSelf.frame.origin.y,weakSelf.frame.size.width, 0);
          }completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
          }];
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
@end
