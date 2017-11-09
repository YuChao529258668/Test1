//
//  CGProductReviewViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/11.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CGProductReviewViewController : CTBaseViewController
@property (nonatomic, assign) NSInteger type;//1产品报告 2全民推荐 3行业方案 4行业报告 5办公文档 6企业报告 7商业计划书 8上市企业 9知识专辑
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, assign) NSInteger selectIndex;
@end
