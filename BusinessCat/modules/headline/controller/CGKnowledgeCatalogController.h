//
//  CGKnowledgeCatalogController.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/26.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTBaseViewController.h"
#import "CGInfoHeadEntity.h"

@interface CGKnowledgeCatalogController : CTBaseViewController
-(instancetype)initWithmainId:(NSString *)mainId packageId:(NSString *)packageId companyId:(NSString *)companyId cataId:(NSString *)cataId;
@property (nonatomic, assign) NSInteger isShowMenu;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *titleStr;
@end
