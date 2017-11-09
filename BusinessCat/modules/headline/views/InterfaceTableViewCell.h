//
//  InterfaceTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/1/23.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"
#import "CGProductInterfaceEntity.h"

@protocol InterfaceDelegate <NSObject>
@optional

- (void)doProductDetailWithIndex:(NSInteger )index;

@end

@interface InterfaceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) CGInfoHeadEntity *product1;
@property (nonatomic, strong) CGInfoHeadEntity *product2;
@property (weak, nonatomic) IBOutlet UIButton *leftCollect;
@property (weak, nonatomic) IBOutlet UIButton *rightCollect;
@property (nonatomic, weak) id <InterfaceDelegate> delegate;

@property (nonatomic, strong) CGProductInterfaceEntity *interface1;
@property (nonatomic, strong) CGProductInterfaceEntity *interface2;
@end
