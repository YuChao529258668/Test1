//
//  CGDiscoverLibraryViewController.h
//  CGSays
//
//  Created by zhu on 2016/12/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGDiscoverLibraryViewController : CTBaseViewController
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) int pageCount;
@property (nonatomic, assign) BOOL isOpen;//是否直接打开文档
@end
