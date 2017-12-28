//
//  CGRotateUtil.m
//  RoverDemo
//
//  Created by mochenyang on 2016/11/3.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import "CGRotateUtil.h"


@interface CGRotateUtil()

@property(nonatomic,retain)UIView *targetView;
@property(nonatomic,assign)float radius;
@property(nonatomic,assign)float speed;
@property(nonatomic,assign)CGPoint point;
@property(nonatomic,assign)int runCount;

@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,assign)float timeout;
@property(nonatomic,assign)float timeoutCount;

@end


@implementation CGRotateUtil

-(instancetype)initWithTargetView:(UIView *)targetView radius:(float)radius speed:(float)speed point:(CGPoint)point timeout:(float)timeout{
    self = [super init];
    if(self){
        self.timeout = timeout;
        self.targetView = targetView;
        self.targetView.hidden = NO;
        self.radius = radius;
        self.speed = speed;
        self.point = point;
    }
    return self;
}

-(void)run{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
}

-(void)timerGo{
    ++self.runCount;
    self.timeoutCount += 0.01;
    CGFloat angle = self.runCount * self.speed;
    double sinAngle = sin(angle * M_PI / 180);
    double cosAngle = cos(angle * M_PI / 180);
    CGFloat centerX = self.point.x + cosAngle * self.radius;
    CGFloat centerY = self.point.y + sinAngle * self.radius;
    self.targetView.center = CGPointMake(centerX, centerY);
    if(self.timeoutCount >= self.timeout){
        [self stop];
    }
}

-(void)dealloc{
    self.runCount = 0;
    [self.timer invalidate];
}

-(void)stop{
    self.targetView.hidden = YES;
    [self.timer invalidate];
}

@end
