//
//  CGInterfaceCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGExpListEntity.h"
typedef void (^CGInterfaceCollectionViewBlock)(NSInteger index);
typedef void (^CGInterfaceProductCollectionViewBlock)(CGExpListEntity *entity);
@interface CGInterfaceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)updateUIWithEntity:(CGHorrolEntity *)entity interfaceBlock:(CGInterfaceCollectionViewBlock)interfaceBlock productBlock:(CGInterfaceProductCollectionViewBlock)productBlock;
- (void)update:(CGHorrolEntity *)entity;
@end
