//
//  UserWalletCollectionViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGIntegralEntity.h"

typedef void (^UserWalletCollectionViewBlock)(RelationInfoEntity *entity);

@interface UserWalletCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)updateDataWithType:(CGHorrolEntity *)entity block:(UserWalletCollectionViewBlock)block;
@end
