//
//  HeadlineOnlyTitleTableViewCell.h
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条模块-只有标题的cell

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"

@protocol HeadlineOnlyTitleTableViewCellDelegate <NSObject>

-(void)headlineCloseInfoCallBack:(CGInfoHeadEntity *)info cell:(UITableViewCell *)cell closeBtnY:(float)closeBtnY;

@end

@interface HeadlineOnlyTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *contentType;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic, assign) CGFloat height;
@property (weak, nonatomic) IBOutlet UIImageView *collectionIV;
@property (weak, nonatomic) IBOutlet UILabel *relevantInformation;

@property(nonatomic,weak)id<HeadlineOnlyTitleTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (weak, nonatomic) IBOutlet UIView *topCompanyView;

@property (weak, nonatomic) IBOutlet UILabel *SourceNameLabel;

@property(nonatomic,retain)CGInfoHeadEntity *info;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyNameHeight;
@property (weak, nonatomic) IBOutlet UIImageView *companyIcon;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyTitle;
@property (weak, nonatomic) IBOutlet UILabel *companySource;
-(void)updateItem:(CGInfoHeadEntity *)info;
+(CGFloat)height:(CGInfoHeadEntity *)info;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceNameHeight;
@property (nonatomic, assign) NSInteger timeType;//0首页 1岗位知识 2发现 3收藏 4专辑

@end
