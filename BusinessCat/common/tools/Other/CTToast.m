//  CTToast.m
//  CGSays
//
//  Created by mochenyang on 12-11-12.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTToast.h"
#import <QuartzCore/QuartzCore.h>
#import "CTCommonUtil.h"

@interface CTToast(){
    NSTimer *_timer;
    NSInteger _duration;
    UIView *_showParentView; // 显示提示信息的父视图
    NSString *_text;
    UILabel *_showView;
}

@end

@implementation CTToast

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

- (id)initWithText:(NSString *)text{
    if ((self = [super init])){
		_text = text;
        _duration = 2000;
	}
	return self;
}


#pragma mark - Public methods

-(void)createWithY:(float)y parentView:(UIView *)parentView{
    UIFont *font = [UIFont systemFontOfSize:16];
    CGRect textSize = [_text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    if (textSize.size.height < 20){
        textSize.size.height = 20;
    }
    
    _showParentView = parentView;
    _showView = [[UILabel alloc]initWithFrame:CGRectMake((_showParentView.frame.size.width-textSize.size.width - 30)/2, y==-1?(_showParentView.frame.size.height-textSize.size.height - 20)/2:y, textSize.size.width + 30, textSize.size.height + 20)];
    _showView.alpha = 0;
    _showView.text = _text;
    _showView.numberOfLines = 0;
    _showView.clipsToBounds = YES;
    _showView.font = font;
    _showView.textColor = [UIColor whiteColor];
    _showView.textAlignment = NSTextAlignmentCenter;
    _showView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _showView.layer.cornerRadius = 8;
    _showView.layer.masksToBounds = YES;
    [parentView addSubview:_showView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration / 1000.0f target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _showView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)show:(UIView *)parentView{
    [self createWithY:-1 parentView:parentView];
}

//显示 指定显示位置
-(void)show:(UIView *)parentView y:(float)y{
    [self createWithY:y parentView:parentView];
}

- (void)hideToast{
    [_timer invalidate];
    _timer = nil;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _showView.alpha = 0;
    } completion:^(BOOL finished) {
        [_showView removeFromSuperview];
    }];
}


+ (CTToast *)makeText:(NSString *)text{
	return [[CTToast alloc] initWithText:text];
}

// 注：duration单位是毫秒
- (void)setDuration:(NSInteger)duration{
	_duration = duration;
}


#pragma mark -

+ (void)showWithText:(NSString *)str {
    [[CTToast makeText:str] show:[UIApplication sharedApplication].keyWindow];
}

@end
