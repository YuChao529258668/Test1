//
//  CollectionViewCell.h
//  CGSays
//
//  Created by zhu on 2016/11/14.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"

typedef void (^CollectionViewCellBlock)(id entity);
typedef void (^InterfaceSelectIndexBlock)(NSMutableArray *array,NSInteger index);
@interface CollectionViewCell : UICollectionViewCell{
  CollectionViewCellBlock didBlock;
  InterfaceSelectIndexBlock interfaceBlock;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, copy) NSString *subjectId;
- (void)updateUIWithEntity:(CGHorrolEntity *)entity keyWord:(NSString *)keyWord action:(NSString *)action typeID:(NSString *)typeID didSelectEntityBlock:(CollectionViewCellBlock)block interfaceSelectIndex:(InterfaceSelectIndexBlock)interfaceIndexBlock;
@end
