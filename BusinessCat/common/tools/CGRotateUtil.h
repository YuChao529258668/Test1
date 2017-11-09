//
//  CGRotateUtil.h
//  RoverDemo
//
//  Created by mochenyang on 2016/11/3.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CGRotateUtil : NSObject

//公转，targetView：需要旋转的view radius：半径,speed：旋转速度，center:围绕的中心点
-(instancetype)initWithTargetView:(UIView *)targetView radius:(float)radius speed:(float)speed point:(CGPoint)point timeout:(float)timeout;

-(void)run;

-(void)stop;

@end
