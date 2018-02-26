//
//  YCMyDocumentController.h
//  BusinessCat
//
//  Created by 余超 on 2018/2/13.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCMyDocumentController : CTBaseViewController
@property (nonatomic, assign) NSInteger type;//0用户VIP 1企业VIP 2团队文档 999我的文档
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, assign) NSInteger showType;

@end
