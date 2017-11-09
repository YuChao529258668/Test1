//
//  CGInterfaceDetailCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGProductDetailsVersionEntity.h"

typedef void (^CGInterfaceDetailViewBlock)(CGProductDetailsVersionEntity *entity);
@interface CGInterfaceDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)updateUIWithEntity:(CGHorrolEntity *)entity productID:(NSString *)productID block:(CGInterfaceDetailViewBlock)block;
@end
