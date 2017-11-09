//
//  CGSourceCircleTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellLayout.h"
#import "Gallop.h"
#import "CGSourceCircleEntity.h"
#import "CGDiscoverLink.h"

@interface CGSourceCircleTableViewCell : UITableViewCell

@property (nonatomic,strong) CellLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,strong) UIButton* menuButton;
@property (nonatomic,copy) void(^clickedImageCallback)(CGSourceCircleTableViewCell* cell,NSInteger imageIndex);//图片点击回调
@property (nonatomic,copy) void(^clickedAvatarCallback)(CGSourceCircleTableViewCell* cell);//头像点击回调
@property (nonatomic,copy) void(^clickedReCommentCallback)(CGSourceCircleTableViewCell* cell,SourceCircComments* model);
@property (nonatomic,copy) void(^clickedOpenCellCallback)(CGSourceCircleTableViewCell* cell);//展开全文点击回调
@property (nonatomic,copy) void(^clickedCloseCellCallback)(CGSourceCircleTableViewCell* cell);//收起全文点击回调
@property (nonatomic,copy) void(^clicmeunCellCallback)(CGSourceCircleTableViewCell* cell,CGSourceCircleEntity *entity);//更多按钮点击回调
@property (nonatomic,copy) void(^clicPraiseCellCallback)(CGSourceCircleTableViewCell* cell,SourceCircPraise *praise);//点击点赞人回调
@property (nonatomic,copy) void(^clicReplyCellCallback)(CGSourceCircleTableViewCell* cell,SourceCircReply *reply);//被评论人
@property (nonatomic,copy) void(^deleteCallback)(CGSourceCircleTableViewCell* cell,CGSourceCircleEntity *entity);//删除企业圈
@property (nonatomic,copy) void(^linkCallback)(CGSourceCircleTableViewCell* cell,CGDiscoverLink *link);//链接
@end
