//
//  CGSkillTagsViewController.h
//  CGSays
//
//  Created by zhu on 2016/11/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void (^CGSkillTagsViewtBlock)(NSMutableArray *tagArray);
@interface CGSkillTagsViewController : CTBaseViewController{
  CGSkillTagsViewtBlock block;
}
-(instancetype)initWithBlock:(CGSkillTagsViewtBlock)release;
@property (nonatomic, strong) NSMutableArray *selectArray;
@end
