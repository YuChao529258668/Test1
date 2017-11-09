//
//  CGTeamDocumentViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGTeamDocumentViewController : CTBaseViewController
@property (nonatomic, assign) NSInteger type;//0用户VIP 1企业VIP 2团队文档
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, assign) NSInteger showType;
@end
