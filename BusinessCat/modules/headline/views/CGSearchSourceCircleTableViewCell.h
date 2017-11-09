//
//  CGSearchSourceCircleTableViewCell.h
//  CGSays
//
//  Created by zhu on 2016/11/24.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCellLayout.h"
#import "Gallop.h"
#import "CGSourceCircleEntity.h"
#import "CGDiscoverLink.h"

@interface CGSearchSourceCircleTableViewCell : UITableViewCell

@property (nonatomic,strong) SearchCellLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,copy) void(^clickedImageCallback)(CGSearchSourceCircleTableViewCell* cell,NSInteger imageIndex);//图片点击回调
@property (nonatomic,copy) void(^clickedAvatarCallback)(CGSearchSourceCircleTableViewCell* cell);//头像点击回调
@property (nonatomic,copy) void(^clickedReCommentCallback)(CGSearchSourceCircleTableViewCell* cell,SourceCircComments* model);
@property (nonatomic,copy) void(^clickedOpenCellCallback)(CGSearchSourceCircleTableViewCell* cell);//展开全文点击回调
@property (nonatomic,copy) void(^clickedCloseCellCallback)(CGSearchSourceCircleTableViewCell* cell);//收起全文点击回调
@property (nonatomic,copy) void(^linkCallback)(CGSearchSourceCircleTableViewCell* cell,CGDiscoverLink *link);//链接

@end
