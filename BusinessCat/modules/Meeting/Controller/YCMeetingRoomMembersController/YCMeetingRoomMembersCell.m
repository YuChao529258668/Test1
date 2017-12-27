//
//  YCMeetingRoomMembersCell.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingRoomMembersCell.h"

@implementation YCMeetingRoomMembersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarIV.layer.cornerRadius = self.avatarIV.frame.size.width / 2;
    self.avatarIV.clipsToBounds = YES;
    
    self.allowBtn.layer.cornerRadius = 4;
    self.allowBtn.clipsToBounds = YES;
    
    self.endBtn.layer.cornerRadius = 4;
    self.endBtn.clipsToBounds = YES;
    self.endBtn.hidden = YES;
    
    [self.allowBtn addTarget:self action:@selector(clickAllowBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.endBtn addTarget:self action:@selector(clickEndBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.interactingLabel.backgroundColor = CTThemeMainColor;
    self.requestingLabel.backgroundColor = self.allowBtn.backgroundColor;
    self.requestingLabel.textColor = [UIColor redColor];
}

+ (float)cellHeight {
    return 60;
}

- (void)clickAllowBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:[YCMeetingRoomMembersCell allowNotificationName] object:self];
}

- (void)clickEndBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:[YCMeetingRoomMembersCell endNotificationName] object:self];
}

+ (NSString *)allowNotificationName {
    return @"YCMeetingRoomMembersCelAllowNotificationl";
}

+ (NSString *)endNotificationName {
    return @"YCMeetingRoomMembersCellEndNotification";
}

// 当前状态:0未进入,1开会中,2已离开,4禁止
- (void)setUserState:(long)state {
    NSArray *titles = @[@"未进入", @"开会中", @"已离开", @"未知状态", @"禁止"];
    self.stateLabel.text = titles[state];
    if (state == 0 || state == 2) {
        self.stateLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.stateLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - 侧滑显示的图片

+ (UIImage *)deleteUserImage {
    float w = [self cellHeight];
    CGSize size = CGSizeMake(w, w);
    
    UIImage *dimage = [self imageWithColor:CTThemeMainColor size:size];
    UIImage *uimage = [UIImage imageNamed:@"video_icon_remove"];
    UIImage *image = [self imageWithUpImage:uimage downImage:dimage size:size];
    return image;
}

+ (UIImage *)changeCompereImage {
    float w = [self cellHeight];
    CGSize size = CGSizeMake(w, w);
    
    UIImage *dimage = [self imageWithColor:CTThemeMainColor size:size];
    UIImage *uimage = [UIImage imageNamed:@"video_icon_pr"];
    UIImage *image = [self imageWithUpImage:uimage downImage:dimage size:size];

    CGRect upRect = CGRectMake(size.width - 1, 0, size.width, size.height);
    UIImage *line = [UIImage imageNamed:@"video_line"];
    line = [line resizableImageWithCapInsets:UIEdgeInsetsZero];
    image = [self imageWithUpImage:line upImageRect:upRect downImage:image size:size];
    return image;
}

#pragma mark - 图片合成

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    CGRect rect=CGRectMake(0,0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)imageWithUpImage:(UIImage *)upImage downImage:(UIImage *)downImage size:(CGSize)size {
    CGRect rect=CGRectMake(0,0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, rect, downImage.CGImage);
    
    float x = (downImage.size.width - upImage.size.width) / 2;
    float y = (downImage.size.height - upImage.size.height) / 2;
    CGRect rect2 = CGRectMake(x, y, upImage.size.width, upImage.size.height);
    CGContextDrawImage(context, rect2, upImage.CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithUpImage:(UIImage *)upImage upImageRect:(CGRect)upRect downImage:(UIImage *)downImage size:(CGSize)size {
    CGRect rect=CGRectMake(0,0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, rect, downImage.CGImage);
    
    CGContextDrawImage(context, upRect, upImage.CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
