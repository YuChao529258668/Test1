//
//  CGInterfaceAppIconCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGProductInterfaceEntity.h"

@interface CGInterfaceAppIconCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *collect;
@property (nonatomic, strong) CGProductInterfaceEntity *interface;
@end
