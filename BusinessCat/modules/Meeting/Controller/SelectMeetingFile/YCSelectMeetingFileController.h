//
//  YCSelectMeetingFileController.h
//  BusinessCat
//
//  Created by 余超 on 2017/12/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface YCSelectMeetingFileController : CTBaseViewController

@property (nonatomic,copy) void (^didSelectBlock)(id entity); //CGHorrolEntity ? CGInfoHeadEntity

@end
