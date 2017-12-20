//
//  AttentionEmptyView.m
//  CGSays
//
//  Created by mochenyang on 2016/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "AttentionEmptyView.h"

@implementation AttentionEmptyView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-155)/2, (frame.size.height-155)/2, 155, 155)];
        image.image = [UIImage imageNamed:@"user_phone"];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:image];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame), SCREEN_WIDTH, 30)];
        title.font = [UIFont systemFontOfSize:18];
        title.textColor = TEXT_MAIN_CLR;
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"关注后雷达自动挖掘数据";
        [self addSubview:title];
        
//        UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), SCREEN_WIDTH, 30)];
//        desc.text = @"关注后会议猫将自动挖掘更多数据";
//        desc.textAlignment = NSTextAlignmentCenter;
//        desc.font = [UIFont systemFontOfSize:13];
//        desc.textColor = [UIColor grayColor];
//        [self addSubview:desc];
    }
    return self;
}

@end
