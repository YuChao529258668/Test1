//
//  CGMainViewController.h
//  CGSays
//
//  Created by mochenyang on 2017/3/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "MainPageBaseViewController.h"


@interface CGMainViewController : MainPageBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *typeEditButton;

-(void)resetHeadlineLocationAction;

@end

