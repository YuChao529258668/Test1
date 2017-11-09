//
//  HeadlineTopicCell.h
//  CGSays
//
//  Created by mochenyang on 2016/10/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条模块-话题一级评论的cell

#import <UIKit/UIKit.h>
#import "CGCommentEntity.h"

@class HeadlineTopicCell;

@protocol HeadlineTopicCellDelegate <NSObject>

-(void)callbackToTopicCommentController:(HeadlineTopicCell *)cell;

-(void)callbackToDeleteController:(HeadlineTopicCell *)cell;

@end

@interface HeadlineTopicCell : UITableViewCell

@property(nonatomic,assign)id<HeadlineTopicCellDelegate> delegate;

-(void)updateItem:(CGCommentEntity *)entity;


@end
