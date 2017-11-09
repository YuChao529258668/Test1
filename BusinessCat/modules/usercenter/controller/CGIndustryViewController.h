//
//  CGIndustryViewController.h
//  CGSays
//
//  Created by zhu on 2016/12/9.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void (^CGIndustryViewBlock)(NSMutableArray *tagArray);
@interface CGIndustryViewController : CTBaseViewController{
  CGIndustryViewBlock block;
}
-(instancetype)initWithBlock:(CGIndustryViewBlock)release;
@property (nonatomic, strong) NSMutableArray *selectArray;

@end
