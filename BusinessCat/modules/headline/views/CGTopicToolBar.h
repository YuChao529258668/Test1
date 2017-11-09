//
//  CGTopicToolBar.h
//  CGSays
//
//  Created by zhu on 2017/1/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoDetailEntity.h"
#import "CGCommentEntity.h"

@protocol CGTopicToolBarDelegate <NSObject>
//弹出评论界面
-(void)detailToolbarOpenTopicCommentAction;
//赏
-(void)detailToolbarEnjoyAction;
//赞数
-(void)detailToolbarCommentTypeAction;
//收藏
-(void)detailToolBarCollectAction;
//分享
-(void)detailToolbarShareAction;
//文档
-(void)detailToolbarDocumentAction;
//爆料
-(void)detailToolbarScoopAction;

@end

@interface CGTopicToolBar : UIView
@property(nonatomic,retain)CGInfoDetailEntity *detail;
@property (strong, nonatomic) IBOutlet UIView *view;
@property(nonatomic,weak)id<CGTopicToolBarDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *fact;
@property (weak, nonatomic) IBOutlet UIButton *share;

-(void)updateToolBar:(CGInfoDetailEntity *)detail isDetail:(BOOL)isDetail comment:(CGCommentEntity *)comment;
-(void)updatePraise:(int)praiseNum;
@end
