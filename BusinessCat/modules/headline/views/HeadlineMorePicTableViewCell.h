//
//  HeadlineMorePicTableViewCell.h
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条模块-图片居底多图的cell

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"

@protocol HeadlineMorePicTableViewCellDelegate <NSObject>

-(void)headlineCloseInfoCallBack:(CGInfoHeadEntity *)info cell:(UITableViewCell *)cell closeBtnY:(float)closeBtnY;

@end
@interface HeadlineMorePicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *contentType;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UIImageView *collectionIV;

@property (nonatomic, assign) CGFloat height;

@property(nonatomic,retain)CGInfoHeadEntity *info;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (weak, nonatomic) IBOutlet UIView *topCompanyView;
@property (weak, nonatomic) IBOutlet UILabel *relevantInformation;
@property (weak, nonatomic) IBOutlet UILabel *sourceNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceNameHeight;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIImageView *companyIcon;
@property (weak, nonatomic) IBOutlet UILabel *companyTitle;
@property (weak, nonatomic) IBOutlet UILabel *companySource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyNameHeight;
@property (nonatomic, assign) NSInteger timeType;//0首页 1岗位知识 2发现 3收藏 4专辑

@property(nonatomic,weak)id<HeadlineMorePicTableViewCellDelegate> delegate;

-(void)updateItem:(CGInfoHeadEntity *)info;

+(CGFloat)height:(CGInfoHeadEntity *)info;

@end
