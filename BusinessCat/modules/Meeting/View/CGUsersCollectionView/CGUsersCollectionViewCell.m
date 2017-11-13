//
//  CGUsersCollectionViewCell.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUsersCollectionViewCell.h"

#define kCycleWidth 42

@implementation CGUsersCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor lightGrayColor] set];
    CGContextSetLineWidth(context, 1);
//    CGContextAddArc(context, 0, 0, kCycleWidth/2, 0, 2*M_PI, 0);
    rect.size.width -= 2;
    rect.size.height -= 2;
    rect.origin.x += 1;
    rect.origin.y += 1;
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
