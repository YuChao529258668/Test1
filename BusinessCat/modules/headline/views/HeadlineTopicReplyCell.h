//
//  HeadlineTopicReplyCell.h
//  CGSays
//
//  Created by mochenyang on 2016/10/13.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条模块-话题二级评论的cell

#import <UIKit/UIKit.h>
#import "CGCommentEntity.h"

@class HeadlineTopicReplyCell;

@protocol HeadlineTopicReplyCellDelegate <NSObject>

-(void)callbackToTopicCommentController:(HeadlineTopicReplyCell *)cell;

@end

@interface HeadlineTopicReplyCell : UITableViewCell

@property(nonatomic,assign)id<HeadlineTopicReplyCellDelegate> delegate;

-(void)updateItem:(CGCommentEntity *)item parent:(BOOL)parent;

@end
