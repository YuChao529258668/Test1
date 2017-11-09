//
//  CGUserViewAuditController.h
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGUserAuditViewController : CTBaseViewController
@property (nonatomic, copy) NSString *companyID;
-(void)refresh;
@end
