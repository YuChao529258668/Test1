//
//  HeadlineTopicMyReplyCell.h
//  CGSays
//
//  Created by zhu on 2017/1/3.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGCommentEntity.h"

@class HeadlineTopicMyReplyCell;

@protocol HeadlineTopicMyReplyCellDelegate <NSObject>

-(void)callbackToTopicMyCommentController:(HeadlineTopicMyReplyCell *)cell;

@end

@interface HeadlineTopicMyReplyCell : UITableViewCell
@property(nonatomic,assign)id<HeadlineTopicMyReplyCellDelegate> delegate;

-(void)updateItem:(CGCommentEntity *)item parent:(BOOL)parent;

@end
