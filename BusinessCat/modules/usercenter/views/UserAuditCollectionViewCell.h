//
//  UserAuditCollectionViewCell.h
//  CGSays
//
//  Created by zhu on 2017/2/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGUserCompanyAuditListEntity.h"

@interface UserAuditCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)updateDataWithType:(NSInteger)type;
@end
