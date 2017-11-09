//
//  HeadlineLeftPicAddTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/1/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"
#import "CGDiscoverBiz.h"

@protocol HeadlineLeftPicAddTableViewCellDelegate <NSObject>

-(void)headlineCloseInfoCallBack:(CGInfoHeadEntity *)info cell:(UITableViewCell *)cell closeBtnY:(float)closeBtnY;

@end

@interface HeadlineLeftPicAddTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *contentType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTypeWidth;
@property (weak, nonatomic) IBOutlet UILabel *contentSourceText;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSourceX;
@property(nonatomic,retain)CGInfoHeadEntity *info;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleY;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (nonatomic, assign) NSInteger timeType;//0首页 1岗位知识 2发现


@property(nonatomic,weak)id<HeadlineLeftPicAddTableViewCellDelegate> delegate;

-(void)updateItem:(CGInfoHeadEntity *)info action:(NSString *)acion type:(int)type typeID:(NSString *)typeID groupId:(NSString *)groupId isAttention:(BOOL)isAttention subjectId:(NSString *)subjectId;

@end
