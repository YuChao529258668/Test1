//
//  HeadlineDetailLoadingView.h
//  CGSays
//
//  Created by mochenyang on 2016/11/17.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HeadlineTopCircelColor @"#F9F9F9"

typedef void (^HeadlineDetailLoadingViewBlock)(void);

@interface HeadlineDetailLoadingView : UIView{
    HeadlineDetailLoadingViewBlock clickBlock;
}

-(instancetype)initWithFrame:(CGRect)frame block:(HeadlineDetailLoadingViewBlock)block;

-(void)startAnimation;

-(void)stopAnimation:(int)num;

-(void)showCircleColor;

-(void)hideCircleColor;

@end
