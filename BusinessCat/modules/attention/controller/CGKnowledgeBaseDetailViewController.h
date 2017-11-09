//
//  CGKnowledgeBaseDetailViewController.h
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "KnowledgeBaseEntity.h"

@interface CGKnowledgeBaseDetailViewController : CTBaseViewController
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, copy) NSString *navTypeId;//二级分类id
@property (nonatomic, copy) NSString *navName;//二级分类名
@property (nonatomic, copy) NSString *bigTypeId;//一级分类id
@property (nonatomic, copy) NSString *bigName;//一级分类名
@property (nonatomic, assign) NSInteger catePage;//1工具 0其他
@property (nonatomic, assign) NSInteger index; //二级大类选中
@property (nonatomic, assign) NSInteger secondaryIndex;//三级大类选中
@property (nonatomic, assign) NSInteger selectIndex;//头部大类选中
@end
