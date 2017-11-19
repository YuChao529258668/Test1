//
//  YCBookMeetingController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/19.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCBookMeetingController.h"

@interface YCBookMeetingController ()

@end

@implementation YCBookMeetingController


- (instancetype)init
{
    self = [super init];
    if (self) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Meeting" bundle:nil];
        self = (YCBookMeetingController *)[sb instantiateViewControllerWithIdentifier:@"YCBookMeetingController"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"预约会议";
}


@end
