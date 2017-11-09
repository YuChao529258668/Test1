//
//  CGDetailToolBar.h
//  CGSays
//
//  Created by mochenyang on 2016/9/29.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  头条模块-底部toolbar

#import <UIKit/UIKit.h>
#import "CGInfoDetailEntity.h"

@protocol CGDetailToolBarDelegate <NSObject>
//弹出评论界面
-(void)detailToolbarOpenTopicCommentAction;
//打开话题界面
-(void)openTopicMainControllerAction;
//收藏事件
-(void)detailToolbarCollectAction;
//爆料
-(void)detailToolbarScoopAction;
//分享
-(void)detailToolbarShareAction;
//文档
-(void)detailToolbarDocumentAction;
//支付费用
-(void)detailToolbarPayFeeAction;
//访问工具网址
-(void)detailToolbarAccessWebSitesAction;
//下载文档
-(void)detailToolbarDownloadDocumentAction;
@end

@interface CGDetailToolBar : UIView

@property(nonatomic,weak)IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *topicButton;
@property (weak, nonatomic) IBOutlet UIImageView *topicImage;
@property (weak, nonatomic) IBOutlet UIImageView *collectImage;
@property (weak, nonatomic) IBOutlet UIImageView *scoopImage;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;

@property(nonatomic,retain)CGInfoDetailEntity *detail;
@property (nonatomic, assign) NSInteger isDocument;
@property(nonatomic,weak)id<CGDetailToolBarDelegate> delegate;
-(void)webViewDidFinish;


-(void)updateToolBar:(CGInfoDetailEntity *)detail isDocument:(NSInteger)isDocument;

@property (weak, nonatomic) IBOutlet UIButton *admireButton;
@property (weak, nonatomic) IBOutlet UIButton *prizeButton;
@end
