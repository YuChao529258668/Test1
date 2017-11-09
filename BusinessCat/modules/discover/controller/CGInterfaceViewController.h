//
//  CGInterfaceViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGInterfaceViewController : CTBaseViewController
@property (nonatomic, assign) NSInteger type;//1app界面 2网站界面 3产品宣传图 4手机海报
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, assign) NSInteger selectIndex;
@end
