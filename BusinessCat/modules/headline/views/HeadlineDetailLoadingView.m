//
//  HeadlineDetailLoadingView.m
//  CGSays
//
//  Created by mochenyang on 2016/11/17.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadlineDetailLoadingView.h"
#import "CGRotateUtil.h"

@interface HeadlineDetailLoadingView(){
    UIView *background;
    UIImageView *angle;
    CGRotateUtil *rotate;
    UILabel *number;
    UIImageView *loading;
}

@end

@implementation HeadlineDetailLoadingView

-(instancetype)initWithFrame:(CGRect)frame block:(HeadlineDetailLoadingViewBlock)block{
    self = [super initWithFrame:frame];
    if(self){
        clickBlock = block;
        background = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 40,40)];
        background.layer.cornerRadius = (frame.size.width - 20)/2;
        background.layer.masksToBounds = YES;
        background.alpha = 0.8;
        [self addSubview:background];
        
        angle = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-25/2, frame.size.height/2-25/2, 25, 25)];
        [self addSubview:angle];
        angle.image = [UIImage imageNamed:@"common_two_jiao_icon"];
        angle.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:angle];
        
        number = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        number.textColor = [UIColor darkGrayColor];
        number.textAlignment = NSTextAlignmentCenter;
        number.font = [UIFont systemFontOfSize:10];
        number.hidden = YES;
        [self addSubview:number];
        
        loading = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-20/2, frame.size.height/2-20/2, 20, 20)];
        loading.image = [UIImage imageNamed:@"common_two_jiao_loding_icon"];
        [self addSubview:loading];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)click{
    if(clickBlock){
        clickBlock();
    }
}

-(void)startAnimation{
    number.hidden = YES;
    loading.hidden = NO;
    rotate = [[CGRotateUtil alloc]initWithTargetView:loading radius:3 speed:4 point:CGPointMake(self.frame.size.width/2+3, self.frame.size.height/2+3) timeout:kRequsetTimeOutSeconds];
    [rotate run];
}

-(void)stopAnimation:(int)num{
    number.text = [NSString stringWithFormat:@"%d",num];
    number.hidden = NO;
    loading.hidden = YES;
    [rotate stop];
    rotate = nil;
}

-(void)showCircleColor{
    background.backgroundColor = [CTCommonUtil convert16BinaryColor:HeadlineTopCircelColor];
}

-(void)hideCircleColor{
    background.backgroundColor = [UIColor clearColor];
}

@end
