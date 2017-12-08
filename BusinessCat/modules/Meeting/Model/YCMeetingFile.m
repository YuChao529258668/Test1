//
//  YCMeetingFile.m
//  BusinessCat
//
//  Created by 余超 on 2017/12/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCMeetingFile.h"

@implementation YCMeetingFile

- (void)setPicName:(NSString *)picName {
    _picName = picName;
    
    self.imageUrls = [picName componentsSeparatedByString:@","];
}

@end
