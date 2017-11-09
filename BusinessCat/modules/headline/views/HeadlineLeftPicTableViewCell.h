//
//  HeadlineLeftPicTableViewCell.h
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条模块-图片居左的cell

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"

@protocol HeadlineLeftPicTableViewCellDelegate <NSObject>

-(void)headlineCloseInfoCallBack:(CGInfoHeadEntity *)info cell:(UITableViewCell *)cell closeBtnY:(float)closeBtnY;

@end

@interface HeadlineLeftPicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *contentType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTypeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeX;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (nonatomic, assign) NSInteger timeType;//0首页 1岗位知识 2发现 4专辑

@property (nonatomic, assign) BOOL isIntelligent;

@property(nonatomic,retain)CGInfoHeadEntity *info;

@property(nonatomic,weak)id<HeadlineLeftPicTableViewCellDelegate> delegate;

-(void)updateItem:(CGInfoHeadEntity *)info;

@end
