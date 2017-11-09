//
//  CommentaryTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/2/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"

@interface CommentaryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descY;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *soruceWidth;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
-(void)updateInfo:(CGInfoHeadEntity *)entity;
+(CGFloat)height:(CGInfoHeadEntity *)entity;
@end
