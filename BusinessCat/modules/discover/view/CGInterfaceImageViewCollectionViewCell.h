//
//  CGInterfaceImageViewCollectionViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/7.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGProductInterfaceEntity.h"
#import "CGInfoHeadEntity.h"

@protocol CGInterfaceImageViewCollectionDelegate <NSObject>

-(void)cancelCollectionWithIndex:(NSInteger)index;

@end

@interface CGInterfaceImageViewCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) CGProductInterfaceEntity *interface;
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *littleIcon;
@property (nonatomic, strong) CGInfoHeadEntity *product;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectBtnWidth;
@property(nonatomic, weak) id<CGInterfaceImageViewCollectionDelegate> delegate;
@end
