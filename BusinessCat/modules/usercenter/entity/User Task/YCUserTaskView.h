//
//  YCUserTaskView.h
//  BusinessCat
//
//  Created by 余超 on 2018/3/19.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCUserTaskCell.h"

@interface YCUserTaskView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

+ (float)height;
+ (instancetype)view;

@end
