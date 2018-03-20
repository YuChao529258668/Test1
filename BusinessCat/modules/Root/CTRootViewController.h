//
//  CTRootViewController.h
//  VieProd
//
//  Created by Calon Mo on 16/4/7.
//  Copyright © 2016年 VieProd. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGTabbarEntity.h"
#import "CGTabbarView.h"
#import "CGKnowledgeBaseViewController.h"
#import "CGDiscoverTeamCircelViewController.h"
#import "CGMyMainViewController.h"
#import "CGDiscoverMainController.h"
#import "CTKnowledgeMealViewController.h"

#import "CGChatListViewController.h"
#import "YCWorkViewController.h"
#import "YCCollegeViewController.h"
#import "CGMeetingListViewController.h"
#import "YCSpaceController.h"

@interface CTRootViewController : CTBaseViewController

@property(nonatomic,assign)int currentShowTabIndex;//当前显示的tabindex

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *tabbarView;
@property(nonatomic,retain)UILabel *redHot;//企业圈红点

@property (nonatomic, assign) BOOL headlineTabIsShow;//是否拖动显示头条 NO：不显示，初始默认状态，YES：已显示

//@property(nonatomic,strong)CGTabbarEntity *firstEntity;
//@property(nonatomic,strong)CGTabbarView *firstTab;
//@property(nonatomic,strong)CTKnowledgeMealViewController *firstController;
//
//@property(nonatomic,strong)CGTabbarEntity *secondEntity;
//@property(nonatomic,strong)CGTabbarView *secondTab;
//@property(nonatomic,strong)CGKnowledgeBaseViewController *secondController;
//
//@property(nonatomic,strong)CGTabbarEntity *thirdEntity;
//@property(nonatomic,strong)CGTabbarView *thirdTab;
//@property(nonatomic,strong)CGDiscoverMainController *thirdController;
//
//@property(nonatomic,strong)CGTabbarEntity *fourthEntity;
//@property(nonatomic,strong)CGTabbarView *fourthTab;
//@property(nonatomic,strong)CGMyMainViewController *fourthController;

@property (nonatomic,strong) NSMutableArray<CGTabbarEntity *> *tabEntitys;
@property (nonatomic,strong) NSMutableArray<CGTabbarView *> *tabViews;
@property (nonatomic,strong) CTKnowledgeMealViewController *mealVC;
@property (nonatomic,strong) CGKnowledgeBaseViewController *baseVC;
@property (nonatomic,strong) CGDiscoverMainController *discoverVC;
@property (nonatomic,strong) CGMyMainViewController *myVC;
@property (nonatomic,strong) CGChatListViewController *chatListVC;
@property (nonatomic,strong) YCWorkViewController *workVC;
@property (nonatomic,strong) YCCollegeViewController *collegeVC;
@property (nonatomic,strong) CGMeetingListViewController *meetingListVC;
@property (nonatomic, strong) YCSpaceController *spaceVC;



//默认显示哪个tab
-(void)showTabIndex:(int)index;

//登录或者退出登录后调用更新“我的”tabbar的状态
-(void)updateMyTabBarState;

//检查token
-(void)toCheckToken;

//跳转到聊天界面
- (void)pushToChatViewControllerWith:(IMAUser *)user;

// 设置会话列表下面的小红点
- (void)setConversationListTabViewRedPoint:(NSInteger)count;

// 登录
- (void)forceLogin;

@end

