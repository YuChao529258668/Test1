//
//  TeamCircelCollectionViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"
#import "CGSourceCircleEntity.h"
typedef void (^TeamCircelCollectionViewBlock)(NSInteger selectIndex,CGSourceCircleEntity* entity);
typedef void (^TeamCircelCollectionViewLinkBlock)(NSString *linkID,NSInteger linkType);
typedef void (^TeamCircelCollectionViewDidSelectBlock)(NSInteger selectIndex,CGSourceCircleEntity* entity);
typedef void (^TeamCircelCollectionViewCellToMessageBlock)(NSString *companyId,int companyType);
@interface TeamCircelCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)updateUIWithEntity:(CGHorrolEntity *)entity block:(TeamCircelCollectionViewBlock)block linkBlock:(TeamCircelCollectionViewLinkBlock)linkBlock didSelectBlock:(TeamCircelCollectionViewDidSelectBlock)didSelectBlock toMsgBlock:(TeamCircelCollectionViewCellToMessageBlock)toMsgBlock;
@property (weak, nonatomic) IBOutlet UIButton *BGButton;
@property (nonatomic, assign) NSInteger isFirst;
-(void)getLastListData;
@end
