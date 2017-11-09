//
//  CGUserAttestationCollectionViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGHorrolEntity.h"

typedef void (^CGUserAttestationCollectionBlock)(UIButton *sender);

@interface CGUserAttestationCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)update:(CGHorrolEntity *)entity;
-(void)didSelectButtonBlock:(CGUserAttestationCollectionBlock)block;
-(void)allResignFirst;
@end
