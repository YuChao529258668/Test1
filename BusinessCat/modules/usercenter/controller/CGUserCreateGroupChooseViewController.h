//
//  CGUserCreateGroupChooseViewController.h
//  CGSays
//
//  Created by zhu on 16/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGTagsEntity.h"
#import "CGUserIndustryListEntity.h"
typedef NS_ENUM(NSInteger, CreatGroupStatus) {
  CreatGroupIndustryStatus = 1,
  CreatGroupScaleStatus = 2,
};
typedef void(^industryListBackClickBlock)(CGUserIndustryListEntity *entity);
typedef void(^tagsBackClickBlock)(CGTagsEntity *entity);
@interface CGUserCreateGroupChooseViewController : CTBaseViewController
@property (nonatomic, assign) CreatGroupStatus state;
@property (nonatomic,copy) industryListBackClickBlock industryBlock;
@property (nonatomic,copy) tagsBackClickBlock tagsBlock;
- (void)didSelectedButtonIndex:(industryListBackClickBlock)industryListblock tagsBlock:(tagsBackClickBlock)tagsBlock;
@end
