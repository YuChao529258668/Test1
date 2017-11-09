//
//  CGUserCompanyTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGUserEntity.h"
typedef void(^SelectedButtonIndex)(NSInteger index);
@interface CGUserCompanyTableViewCell : UITableViewCell
@property (strong, nonatomic) SelectedButtonIndex block;
- (void)didSelectedButtonIndex:(SelectedButtonIndex)block;

- (void)info:(CGUserEntity *)userInfo;
@end
