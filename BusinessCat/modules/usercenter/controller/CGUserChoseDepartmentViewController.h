//
//  CGUserChoseDepartmentViewController.h
//  CGSays
//
//  Created by zhu on 2016/12/13.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

@protocol CGUserChoseDepartmentDelegate <NSObject>

-(void)didSelectDepaID:(NSString *)depaID depaName:(NSString *)depaName;

@end

@interface CGUserChoseDepartmentViewController : CTBaseViewController
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, assign) NSInteger companyType;
@property(nonatomic,assign)id<CGUserChoseDepartmentDelegate> delegate;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isDiscover;
@end
