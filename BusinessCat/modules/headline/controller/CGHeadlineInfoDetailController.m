//
//  CGHeadlineInfoDetailController.m
//  CGSays
//
//  Created by mochenyang on 2016/9/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGHeadlineInfoDetailController.h"
#import "HeadlineBiz.h"
#import "CGInfoDetailEntity.h"
#import "CGTopicMainViewController.h"
#import "CGCommentView.h"
#import "CGMainLoginViewController.h"
#import "ShareUtil.h"
#import "CGReloadView.h"
#import "HeadLineDao.h"
#import "WKWebViewController.h"
#import "CGRotateUtil.h"
#import "AppDelegate.h"
#import "CGDiscoverLink.h"
#import "CGDiscoverReleaseSourceViewController.h"
#import "HeadlineDetailLoadingView.h"
#import "UIImage+animatedGIF.h"
#import "CGDiscoverLibraryViewController.h"
#import "PDFViewController.h"
#import "LWImageBrowser.h"
#import "CGFristOpenView.h"
#import "CGUserFireViewController.h"

#import "HeadlineOnlyTitleTableViewCell.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "CGHeadlineDetailView.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "CGBigdataEntity.h"
#import "NoDataTableViewCell.h"
#import "CGHeadlineDetailLeftTableViewCell.h"
#import "CGCompanyDao.h"
#import "CGSourceTableViewCell.h"
#import "CommonWebViewController.h"
#import "DiscoverPushView.h"
#import "CGFeedbackReleaseViewController.h"
#import "KxMenu.h"
#import "CGEnterpriseMemberViewController.h"
#import "CGCompanyDao.h"
#import "CGUserCenterBiz.h"
#import "CGCopyrightTipsView.h"
#import "QRCodeGenerator.h"
#import "CGBuyVIPViewController.h"
#import "CGPlatformManagementViewController.h"
#import "CGDetailTableViewCell.h"
#import "CGDetailBigImageViewController.h"

@interface CGImageEntity : NSObject
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
-(instancetype)initWithWidth:(NSInteger)width height:(NSInteger)height;
@end

@implementation CGImageEntity
-(instancetype)initWithWidth:(NSInteger)width height:(NSInteger)height{
  self = [super init];
  if(self){
    self.width = width;
    self.height = height;
  }
  return self;
}
@end

@interface CGHeadlineInfoDetailController ()<CGDetailToolBarDelegate,UIScrollViewDelegate,WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate,CGHeadlineDetailViewDelegate,UIActionSheetDelegate,WKScriptMessageHandler,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)HeadlineBiz *biz;
@property(nonatomic,retain)HeadLineDao *dao;
@property(nonatomic,retain)CGInfoDetailEntity *detail;
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic,assign)float lastPosition;
@property(nonatomic,retain)NSString *inputStr;

@property(nonatomic,retain)ShareUtil *shareUtil;

@property(nonatomic,assign)float currentPostion;

@property(nonatomic,assign)UIStatusBarStyle statusBarStyle;
@property(nonatomic,assign)BOOL statusBarHidden;

@property(nonatomic,retain)HeadlineDetailLoadingView *loadRotateView;
@property (nonatomic, strong) UIImageView *hudIV;
@property (weak, nonatomic) IBOutlet UIImageView *nodataIcon;

@property (nonatomic, assign) BOOL isCompetiClick;

@property(nonatomic,assign)BOOL manMadeScroll;//是否人为拖动网页
@property (nonatomic, strong) CGBigdataEntity *bigDataEntity;
@property (nonatomic, assign) NSInteger selectType;
@property (nonatomic, strong) CGHeadlineDetailView *headerView;
@property (nonatomic, assign) BOOL isHtml5Finish;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (weak, nonatomic) IBOutlet UIView *permissionsBGView;
@property (weak, nonatomic) IBOutlet UILabel *permissionsLabel;
@property (weak, nonatomic) IBOutlet UIButton *permissionsButton;
@property (weak, nonatomic) IBOutlet UIButton *copyrightTipsButton;
@property (nonatomic, copy) CGHeadlineInfoDetailDeleteBlock block;
@property (nonatomic, strong) UIView *footView;

@property (nonatomic, assign) NSInteger isStatusBar;//是否显示时间栏
@property (nonatomic, assign) NSInteger isHorizontal;//是否横屏
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIView *qrCodeView;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeIV;
@property (nonatomic, assign) NSInteger originalDetailType;
@property (nonatomic, assign) NSInteger isOpenErcode;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic, strong) NSMutableArray *imageList;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSMutableArray *mUrlArray;
@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, assign) NSInteger isUrlFrist;
@property (nonatomic, copy) NSString *svgStr;
@end

@implementation CGHeadlineInfoDetailController

- (BOOL)shouldAutorotate{
  if(![CTStringUtil stringNotBlank:self.detail.html]&&[CTStringUtil stringNotBlank:self.detail.qiniuUrl]){
    return YES;
  }
  //是否允许转屏
  return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  //viewController所支持的全部旋转方向
  return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  //viewController初始显示的方向
  return UIInterfaceOrientationPortrait;
}

//屏幕旋转完成的状态
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  
}

//获取将要旋转的状态
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  
}

//获取旋转中的状态
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  self.navi.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
  CGFloat height = self.isStatusBar?0:20;
  self.hudIV.frame = CGRectMake((SCREEN_WIDTH-152)/2, (SCREEN_HEIGHT-152)/2, 152, 152);
  if (toInterfaceOrientation == UIDeviceOrientationLandscapeRight ||toInterfaceOrientation == UIDeviceOrientationLandscapeLeft) {
    self.webView.frame = CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT-height);
    self.tableView.frame = self.webView.frame;
    self.countLabel.frame = CGRectMake((SCREEN_WIDTH-60)/2, SCREEN_HEIGHT-54, 60, 30);
    self.isHorizontal = YES;
    self.toolbar.hidden = YES;
  }else{
    self.webView.frame = CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT-44-height);
    self.countLabel.frame = CGRectMake((SCREEN_WIDTH-60)/2, SCREEN_HEIGHT-94, 60, 30);
    self.tableView.frame = self.webView.frame;
    self.isHorizontal = NO;
    self.toolbar.hidden = NO;
  }
  [self.tableView reloadData];
}

-(HeadLineDao *)dao{
  if(!_dao){
    _dao = [[HeadLineDao alloc]init];
  }
  return _dao;
}

-(UITableView *)tableView{
  if (!_tableView) {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = CTCommonViewControllerBg;
  }
  return _tableView;
}

-(UILabel *)countLabel{
  if (!_countLabel) {
    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, SCREEN_HEIGHT-94, 60, 30)];
    _countLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    _countLabel.font = [UIFont systemFontOfSize:15];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = [UIColor whiteColor];
  }
  return _countLabel;
}

-(HeadlineBiz *)biz{
  if(!_biz){
    _biz = [[HeadlineBiz alloc]init];
  }
  return _biz;
}

-(instancetype)initWithInfoId:(NSString *)infoId type:(NSInteger)type block:(CGHeadlineInfoDetailDeleteBlock)block{
  self = [super init];
  if(self){
    self.infoId = infoId;
    self.type = type;
    self.block = block;
  }
  return self;
}

-(void)viewDidAppear:(BOOL)animated{
  [self updateState];
  if ([CTStringUtil stringNotBlank:self.detail.infoId]) {
    __weak typeof(self) weakSelf = self;
    [self.biz headlinesInfoDetailStateWithID:self.detail.infoId type:self.detail.type success:^(NSInteger isFollow, NSInteger commentCount) {
      weakSelf.detail.isFollow = isFollow;
      weakSelf.detail.commentCount = commentCount;
      [[[HeadLineDao alloc]init]updateInfoDataByKey:HeadlineInfo_isFollow value:[NSString stringWithFormat:@"%ld",(long)isFollow] infoId:weakSelf.detail.infoId table:HeadlineInfoDetail_tableName];
      [[[HeadLineDao alloc]init]updateInfoDataByKey:HeadlineInfoDetail_commentCount value:[NSString stringWithFormat:@"%ld",(long)commentCount] infoId:weakSelf.detail.infoId table:HeadlineInfoDetail_tableName];
      [weakSelf updateState];
    } fail:^(NSError *error) {
      
    }];
  }
}

-(void)getCopyrightView{
  NSString *str = self.detail.notice;
  CGFloat height = [CTStringUtil heightWithFont:15 width:SCREEN_WIDTH-30 str:str];
  self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, height+50)];
  UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 10, 80, 20)];
  [self.footView addSubview:tipLabel];
  tipLabel.textColor = [UIColor lightGrayColor];
  tipLabel.font = [UIFont systemFontOfSize:15];
  tipLabel.text = @"版权提示";
  tipLabel.textAlignment = NSTextAlignmentCenter;
  self.footView.backgroundColor = [UIColor whiteColor];
  UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH-30, height)];
  [self.footView addSubview:label];
  label.text = str;
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:15];
  label.textColor = [UIColor lightGrayColor];
  UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(15, height+48, SCREEN_WIDTH-30, 2)];
  bottomLine.backgroundColor = CTCommonLineBg;
  [self.footView addSubview:bottomLine];
  UIImageView *leftLine = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, (SCREEN_WIDTH-80-30)/2, 2)];
  leftLine.backgroundColor = CTCommonLineBg;
  [self.footView addSubview:leftLine];
  UIImageView *rightLine = [[UIImageView alloc]initWithFrame:CGRectMake(tipLabel.frame.size.width+tipLabel.frame.origin.x, 20, (SCREEN_WIDTH-80-30)/2, 2)];
  rightLine.backgroundColor = CTCommonLineBg;
  [self.footView addSubview:rightLine];
}

- (void)callActionSheetFunc{
  self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"字体大小" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"小", @"中",@"大",@"特大",nil];
  self.actionSheet.tag = 1000;
  [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (actionSheet.tag == 1000) {
    switch (buttonIndex) {
      case 0:{
        [ObjectShareTool sharedInstance].settingEntity.fontSize = 1;
        [self updateSetting];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FONTSIZE object:nil];
      }
        break;
        
      case 1:
      {
        [ObjectShareTool sharedInstance].settingEntity.fontSize = 2;
        [self updateSetting];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FONTSIZE object:nil];
      }
        break;
        
      case 2:
      {
        [ObjectShareTool sharedInstance].settingEntity.fontSize = 3;
        [self updateSetting];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FONTSIZE object:nil];
      }
        break;
        
      case 3:
      {
        [ObjectShareTool sharedInstance].settingEntity.fontSize = 4;
        [self updateSetting];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FONTSIZE object:nil];
      }
        break;
        
      case 4:
        
        break;
    }
  }
  [self executeFontSize];
}

-(void)updateSetting{
  CGUserCenterBiz *biz = [[CGUserCenterBiz alloc]init];
  [biz userSettingUpdateWithDisturb:0 fontSize:[ObjectShareTool sharedInstance].settingEntity.fontSize nightMode:0 noPic:0 vibration:0 voice:0 message:0 knowledgeMsg:0 everydayMsg:0 rewardMsg:0 auditMsg:0 exitMsg:0 success:^{
    [CGCompanyDao saveSettingStatistics:[ObjectShareTool sharedInstance].settingEntity];
  } fail:^(NSError *error) {
    
  }];
}

//版权提示点击事件
- (IBAction)copyrightClick:(UIButton *)sender {
  __weak typeof(self) weakSelf = self;
  CGCopyrightTipsView *view = [[CGCopyrightTipsView alloc]initWithInfo:self.detail block:^(NSString *url) {
    CommonWebViewController *vc = [[CommonWebViewController alloc]init];
    vc.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [weakSelf.navigationController pushViewController:vc animated:YES];
  }];
  [self.view addSubview:view];
}

- (IBAction)rightClick:(UIButton *)sender {
  NSMutableArray *menuItems = [NSMutableArray arrayWithObjects:[KxMenuItem menuItem:@"留言管家"
                                                                              image:nil
                                                                             target:self
                                                                             action:@selector(feedbackAction)], nil];
  if ([ObjectShareTool sharedInstance].currentUser.platformAdmin) {
    [menuItems addObject:[KxMenuItem menuItem:@"校正管理"
                                        image:nil
                                       target:self
                                       action:@selector(libraryCorrectionbackAction)]];
  }
  if ([CTStringUtil stringNotBlank:self.detail.html]) {
    [menuItems addObject:[KxMenuItem menuItem:@"字体大小"
                                        image:nil
                                       target:self
                                       action:@selector(fontSizeChangeAction)]];
  }
  
  CGRect fromRect = sender.frame;
  [KxMenu setTintColor:[UIColor blackColor]];
  
  [KxMenu showMenuInView:self.view
                fromRect:fromRect
               menuItems:menuItems];
}


//校正管理
-(void)libraryCorrectionbackAction{
  __weak typeof(self) weakSelf = self;
  NSInteger type = 0;
  if ([CTStringUtil stringNotBlank:self.detail.qiniuUrl]) {
    type = 2;
  }
  CGPlatformManagementViewController *vc = [[CGPlatformManagementViewController alloc]initWithInfoId:self.infoId type:type array:self.typeArray time:self.detail.createTimeNew block:^(NSString *success) {
    [weakSelf getData];
  }];
  [self.navigationController pushViewController:vc animated:YES];
}
//字体大小
-(void)fontSizeChangeAction{
  [self callActionSheetFunc];
}

//我要反馈
-(void)feedbackAction{
  if (![ObjectShareTool sharedInstance].currentUser.isLogin) {
    [self clickToLoginAction];
    return;
  }
  if (![ObjectShareTool sharedInstance].currentUser.housekeeper) {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请开通管家会员才能使用！" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
    alertView.tag = 1006;
    [alertView show];
    return;
  }
  
  CGFeedbackReleaseViewController *vc = [[CGFeedbackReleaseViewController alloc]initWithBlock:^(NSString *success) {
  }];
  CGDiscoverLink *link = [[CGDiscoverLink alloc]init];
  link.linkIcon = self.detail.infoPic;
  link.linkId = self.detail.infoId;
  link.linkTitle = self.detail.title;
  link.linkType = self.detail.type;
  vc.link = link;
  vc.level = 1;
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:YES];
  [self.config.userContentController removeScriptMessageHandlerForName:@"decideADBlock"];
}

-(void)viewDidDisappear:(BOOL)animated{
  [self.biz.component stopBlockAnimation];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self hideCustomNavi];
  self.toolbar.delegate = self;
  self.isCompetiClick = YES;
  //  self.webViewHeight = SCREEN_HEIGHT-20-40;
  //  self.isWebImageClick = YES;
  self.permissionsButton.layer.cornerRadius = 4;
  self.permissionsButton.layer.masksToBounds = YES;
  self.permissionsButton.backgroundColor = CTThemeMainColor;
  self.copyrightTipsButton.layer.cornerRadius = 4;
  self.copyrightTipsButton.layer.borderColor = CTCommonLineBg.CGColor;
  self.copyrightTipsButton.layer.borderWidth = 1;
  
  [self loadInfoDetail];
  self.selectType = 0;
  self.detailType = self.detailType==0?1:self.detailType;
  self.originalDetailType = self.detailType;
  //重新拉取用户资料
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryRemoteUserDetailInfo) name:NOTIFICATION_LOGINSUCCESS object:nil];
  //购买会员成功回调
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bugVipSuccess) name:NOTIFICATION_BUYMEMBER object:nil];
  self.shareButton.layer.cornerRadius = 4;
  self.shareButton.layer.masksToBounds = YES;
  self.shareButton.backgroundColor = CTThemeMainColor;
  self.webView.navigationDelegate = self;
}

-(void)queryRemoteUserDetailInfo{
  [self getData];
}

-(void)bugVipSuccess{
  [self getData];
}

- (IBAction)permissionsClick:(UIButton *)sender {
  if (self.detail.viewPermit == -1 ||self.detail.viewPermit == 6) {
    [self clickToLoginAction];
  }else if (self.detail.viewPermit==1||self.detail.viewPermit == 7){
    CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
  }else if (self.detail.viewPermit==5){
    CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
  }else if (self.detail.viewPermit == 4||self.detail.viewPermit == 8){
    //初始化AlertView
    [self hiddenHUD];
    NSString *message = [NSString stringWithFormat:@"是否确定支付%ld知识币查看内容",(long)self.detail.integral];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    alert.tag = 1001;
    [alert show];
  }
}

//点击登录
-(void)clickToLoginAction{
  __weak typeof(self) weakSelf = self;
  CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
    [weakSelf.tableview reloadData];
  } fail:^(NSError *error) {
    
  }];
  //    [self presentViewController:controller animated:YES completion:nil];
  [self.navigationController pushViewController:controller animated:YES];
}

-(void)updateView{
  //  [self showHUD];
  //  if (self.isQiniuUrl) {
  [self.view addSubview:self.webView];
  self.webView.scrollView.scrollEnabled = YES;
  //  }else{
  //    self.webView.scrollView.scrollEnabled = NO;
  //    [self.webScrollView addSubview:self.webView];
  //    [self.view addSubview:self.tableView];
  //  }
  
  if ([self.detail.qiniuUrl hasSuffix:@"xls"]||[self.detail.qiniuUrl hasSuffix:@"xlsx"]) {
    CGRect tuiRect = self.tuiBtn.frame;
    tuiRect.origin.x = 60;
    self.tuiBtn.frame = tuiRect;
    [self.tuiBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:[CTCommonUtil convert16BinaryColor:HeadlineTopCircelColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:[CTCommonUtil convert16BinaryColor:HeadlineTopCircelColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
  }
  
  [self.view bringSubviewToFront:self.tuiBtn];
  [self.view bringSubviewToFront:self.rightBtn];
  if ([CTStringUtil stringNotBlank:self.detail.authorName]||[CTStringUtil stringNotBlank:self.detail.source]||[CTStringUtil stringNotBlank:self.detail.url]||[CTStringUtil stringNotBlank:self.detail.notice]) {
    [self.view bringSubviewToFront:self.copyrightTipsButton];
    self.copyrightTipsButton.hidden = NO;
  }
  [self.view bringSubviewToFront:self.hudIV];
  [self.view bringSubviewToFront:self.qrCodeView];
}

-(CGHeadlineDetailView *)headerView{
  if (!_headerView) {
    _headerView = [[CGHeadlineDetailView userHeaderView] init];
    _headerView.delegate = self;
  }
  return _headerView;
}

-(void)baseBackAction{
  if ([CTStringUtil stringNotBlank:self.inputStr]) {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你有内容未发表，是否关闭？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1000;
    [alert show];
  }else{
    if (self.detail.state == 0||(self.detail.isFollow == NO&&self.isCollect == YES)) {
      self.block();
    }
    [super baseBackAction];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (alertView.tag == 1000) {
    if (buttonIndex == 1) {
      if (self.detail.isFollow == NO&&self.isCollect == YES) {
        self.block();
      }
      [super baseBackAction];
    }
  }else if (alertView.tag == 1001){
    if (buttonIndex == 1) {
      if ([ObjectShareTool sharedInstance].currentUser.integralNum<self.detail.integral) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"知识币不够提示"
                                                        message:@"你可以通过以下两个方式增加知识币：\n1）按知识币奖励规则完成任务获得知识币\n2）在线支付充值知识币"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"我要充值",nil];
        alert.tag = 1002;
        [alert show];
        return;
      }
      __weak typeof(self) weakSelf = self;
      [self.biz headlinesInfoDetailsIntegralPurchaseWithType:self.type ID:self.infoId integral:self.detail.integral success:^{
        [weakSelf getData];
      } fail:^(NSError *error) {
        
      }];
    }else{
      self.isOpenErcode = NO;
    }
  }else if (alertView.tag == 1002){
    if (buttonIndex ==1) {
      CGBuyVIPViewController *vc = [[CGBuyVIPViewController alloc]init];
      vc.type = 4;
      [self.navigationController pushViewController:vc animated:YES];
    }
  }else if (alertView.tag == 1006){
    if (buttonIndex == 1) {
      CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
      vc.type = 0;
      [self.navigationController pushViewController:vc animated:YES];
    }
  }
}

-(WKWebView *)webView{
  if(!_webView){
    self.config = [[WKWebViewConfiguration alloc]init];
    self.config.userContentController = [[WKUserContentController alloc]init];
    [self.config.userContentController addScriptMessageHandler:self name:@"decideADBlock"];
    _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:self.config];
    _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-40);
    _webView.UIDelegate = self;
    _webView.scrollView.delegate = self;
  }
  return _webView;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
  if ([message.name isEqualToString:@"decideADBlock"]) {
    CommonWebViewController *vc = [[CommonWebViewController alloc]init];
    vc.url = self.detail.url;
    [self.navigationController pushViewController:vc animated:YES];
  }
}

-(void)loadInfoDetail{
  __weak typeof(self) weakSelf = self;
  //优先加载本地
  [self.dao queryInfoDetailFromDB:self.infoId success:^(CGInfoDetailEntity *detail) {
    weakSelf.toolbar.hidden = NO;
    weakSelf.detail = detail;
    [weakSelf.toolbar webViewDidFinish];
    if (detail.pageCount>0&&![detail.infoPic hasSuffix:@".svg.png"]) {
      NSString * newString = [detail.infoPic substringWithRange:NSMakeRange(0, [detail.infoPic length] - 1)];
      weakSelf.imageList = [NSMutableArray array];
      for (int i=0; i<detail.pageCount; i++) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%d",newString,i+1];
        [weakSelf.imageList addObject:imageUrl];
      }
      if (detail.width<=0||detail.height<=0) {
        [weakSelf updateimageList];
      }
      [weakSelf.view addSubview:weakSelf.tableView];
      [weakSelf.view addSubview:weakSelf.countLabel];
      weakSelf.countLabel.text = [NSString stringWithFormat:@"%ld",(long)detail.pageCount];
      [weakSelf.tableView reloadData];
    }else if(detail.pageCount>0&&[detail.infoPic hasSuffix:@".svg.png"]){
      NSString * newString = [detail.infoPic substringWithRange:NSMakeRange(0, [detail.infoPic length] - 9)];
      self.svgStr = @"";
      for (int i=0; i<detail.pageCount; i++) {
        NSString *imageUrl = [NSString stringWithFormat:@"<div class=\"ImageView\"><img class=\"\" src=\"%@%d.svg\" style=\"opacity: 1; width: 100%%; height: auto;\"></div>",newString,i+1];
        self.svgStr = [NSString stringWithFormat:@"%@%@",self.svgStr,imageUrl];
      }
    }
    if (detail.infoOriginal) {
      [weakSelf.copyrightTipsButton setTitle:@"原创" forState:UIControlStateNormal];
    }else{
      [weakSelf.copyrightTipsButton setTitle:@"版权" forState:UIControlStateNormal];
    }
    [weakSelf getData];
    [weakSelf updateViewPermitState];
  } fail:^(NSError *error) {
    [weakSelf getData];
  }];
}

-(void)getData{
  __weak typeof(self) weakSelf = self;
  //加载服务器数据
  [self showHUD];
  [self.biz queryRemoteInfoDetailById:self.infoId type:self.type success:^(CGInfoDetailEntity *infoDetail) {
      
      [weakSelf hiddenHUD];
      weakSelf.detail = infoDetail;
      if (infoDetail.pageCount>0&&![infoDetail.infoPic hasSuffix:@".svg.png"]) {
          NSString * newString = [infoDetail.infoPic substringWithRange:NSMakeRange(0, [infoDetail.infoPic length] - 1)];
          weakSelf.imageList = [NSMutableArray array];
          for (int i=0; i<infoDetail.pageCount; i++) {
              NSString *imageUrl = [NSString stringWithFormat:@"%@%d",newString,i+1];
              [weakSelf.imageList addObject:imageUrl];
          }
          weakSelf.imageList = [infoDetail getYCImageURLs];
          if (infoDetail.width<=0||infoDetail.height<=0) {
              [weakSelf updateimageList];
          }
          [weakSelf.view addSubview:weakSelf.tableView];
          [weakSelf.view addSubview:weakSelf.countLabel];
          weakSelf.countLabel.text = [NSString stringWithFormat:@"%ld",infoDetail.pageCount];
          [weakSelf.tableView reloadData];
      }
      else if(infoDetail.pageCount>0&&[infoDetail.infoPic hasSuffix:@".svg.png"]){
          NSString * newString = [infoDetail.infoPic substringWithRange:NSMakeRange(0, [infoDetail.infoPic length] - 9)];
          self.svgStr = @"";
          for (int i=0; i<infoDetail.pageCount; i++) {
              NSString *imageUrl = [NSString stringWithFormat:@"<div class=\"ImageView\"><img class=\"\" src=\"%@%d.svg\" style=\"opacity: 1; width: 100%%; height: auto;\"></div>",newString,i+1];
              self.svgStr = [NSString stringWithFormat:@"%@%@",self.svgStr,imageUrl];
          }
      }
      if (infoDetail.infoOriginal) {
          [weakSelf.copyrightTipsButton setTitle:@"原创" forState:UIControlStateNormal];
      }else{
          [weakSelf.copyrightTipsButton setTitle:@"版权" forState:UIControlStateNormal];
      }
      [weakSelf updateViewPermitState];
      [weakSelf getDetailState];
      
  } fail:^(NSError *error){
    [weakSelf hiddenHUD];
    NetworkStatus status = [[ObjectShareTool sharedInstance].reachability currentReachabilityStatus];
    if ((!weakSelf.detail&&error.code == 10086)||(!weakSelf.detail&&status == NotReachable)) {
      weakSelf.webView.hidden = YES;
      weakSelf.permissionsBGView.hidden = NO;
      weakSelf.nodataIcon.image = [UIImage imageNamed:@"Check_network"];
      if (error.code == 10086) {
        weakSelf.permissionsLabel.text = @"服务正在升级";
      }else{
        weakSelf.permissionsLabel.text = @"断网了 ~T_T~ 请检查网络";
      }
      weakSelf.permissionsButton.hidden = YES;
      
    }
    weakSelf.toolbar.hidden = YES;
  }];
}

-(void)updateViewPermitState{
  if (self.detail.state == 0) {
    self.webView.hidden = YES;
    self.toolbar.hidden = YES;
    if (![ObjectShareTool sharedInstance].currentUser.platformAdmin) {
      self.rightBtn.hidden = YES;
    }
    self.copyrightTipsButton.hidden = YES;
    self.permissionsBGView.hidden = NO;
    self.nodataIcon.image = [UIImage imageNamed:@"no_data"];
    NSString *str = @"内容";
    self.permissionsLabel.text = [NSString stringWithFormat:@"%@因版权问题已被删除",str];
    self.permissionsButton.hidden = YES;
    [[[HeadLineDao alloc]init]deleteInfoDetailFromDB:self.infoId];
  }else{
    [self hiddenHUD];
    self.toolbar.hidden = NO;
    self.copyrightTipsButton.hidden = YES;
    [self.toolbar webViewDidFinish];
    if (self.detail.viewPermit == -1||self.detail.viewPermit == 6) {
      self.webView.hidden = YES;
      self.permissionsBGView.hidden = NO;
      self.permissionsLabel.text = self.detail.viewPrompt;;
      self.permissionsButton.hidden = NO;
      [self.permissionsButton setTitle:@"登录" forState:UIControlStateNormal];
    }else if (self.detail.viewPermit==2||self.detail.viewPermit==3) {
      self.webView.hidden = YES;
      self.permissionsBGView.hidden = NO;
      self.permissionsLabel.text = self.detail.viewPrompt;
      self.permissionsButton.hidden = YES;
    }else if (self.detail.viewPermit==1||self.detail.viewPermit==5||self.detail.viewPermit == 7){
      self.webView.hidden = YES;
      self.permissionsBGView.hidden = NO;
      self.permissionsLabel.text = self.detail.viewPrompt;
      self.permissionsButton.hidden = NO;
      [self.permissionsButton setTitle:self.detail.viewPermit==1||self.detail.viewPermit == 7?@"我要升级":@"我要成为VIP企业" forState:UIControlStateNormal];
      if (self.detail.viewPermit == 5 &&[ObjectShareTool sharedInstance].currentUser.companyList.count!=1) {
        self.permissionsButton.hidden = YES;
        self.permissionsLabel.text = @"你无权限阅读";
      }
    }else if (self.detail.viewPermit==4){
      if ([CTStringUtil stringNotBlank:self.detail.html]&&[CTStringUtil stringNotBlank:self.detail.qiniuUrl]) {
        self.detailType = 3;
        self.webView.hidden = NO;
        self.permissionsBGView.hidden = YES;
      }else{
        self.webView.hidden = YES;
        self.permissionsBGView.hidden = NO;
        NSString *integral = [NSString stringWithFormat:@"%ld",(long)self.detail.integral];
        NSString *str = [NSString stringWithFormat:@"需支付%ld知识币才能查看",(long)self.detail.integral];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [str length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [str length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, integral.length+3)];
        
        self.permissionsLabel.attributedText = attributedString;
        self.permissionsButton.hidden = NO;
        [self.permissionsButton setTitle:@"付费" forState:UIControlStateNormal];
      }
    }else if (self.detail.viewPermit == 9){
      self.webView.hidden = YES;
      self.permissionsLabel.text = self.detail.viewPrompt;;
      self.permissionsButton.hidden = YES;
    }else{
      self.detailType = self.originalDetailType;
      if (self.detail.pageCount>0) {
        self.detailType = 5;
      }else if (self.detail.appList.count>0) {
        self.detailType = 4;
      }
      self.webView.hidden = NO;
      self.permissionsBGView.hidden = YES;
      if (self.isOpenErcode) {
        [self hiddenHUD];
        self.qrCodeView.hidden = NO;
        self.fileNameLabel.text = self.detail.fileName;
        if ([self.detail.fileName hasSuffix:@".rar"]||[self.detail.fileName hasSuffix:@".zip"]) {
          self.tipLabel.text = @"*rar/zip文件分享后无法打开浏览，可分享到电脑端下载后解压打开";
        }else{
          self.tipLabel.text = @"如需打开文档请分享到微信上打开";
        }
        self.fileSizeLabel.text = [NSString stringWithFormat:@"扫我即可下载(%.2fMb)",self.detail.fileSize/(1024.0*1024.0)];
        self.qrcodeIV.image = [QRCodeGenerator qrImageForString:self.detail.downloadUrl imageSize:self.qrcodeIV.frame.size.width];
      }
    }
    [self updateContent];
  }
}

-(void)getDetailState{
  __weak typeof(self)weakSelf = self;
  [self.biz headlinesInfoDetailStateWithID:self.infoId type:self.type success:^(NSInteger isFollow, NSInteger commentCount) {
    weakSelf.detail.isFollow = isFollow;
    weakSelf.detail.commentCount = commentCount;
    [[[HeadLineDao alloc]init]updateInfoDataByKey:HeadlineInfo_isFollow value:[NSString stringWithFormat:@"%ld",(long)isFollow] infoId:weakSelf.detail.infoId table:HeadlineInfoDetail_tableName];
    [[[HeadLineDao alloc]init]updateInfoDataByKey:HeadlineInfoDetail_commentCount value:[NSString stringWithFormat:@"%ld",(long)commentCount] infoId:weakSelf.detail.infoId table:HeadlineInfoDetail_tableName];
    [weakSelf updateState];
  } fail:^(NSError *error) {
    
  }];
}

-(void)updateContent{
  if (self.detail.pageCount>0&&[self.detail.infoPic hasSuffix:@".svg.png"]) {
    [self updateView];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"htmlDetailTemplate" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"#html#" withString:self.svgStr];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    [self getCopyrightView];
    [self.view addSubview:self.countLabel];
    [self.view bringSubviewToFront:self.qrCodeView];
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.detail.pageCount];
  }else if([CTStringUtil stringNotBlank:self.detail.html]){
    if ([CTStringUtil stringNotBlank:self.detail.qiniuUrl]) {
      if (self.detailType == 1) {
        if ([self.info.label isEqualToString:@"附件"]) {
          self.detailType = 2;
        }
      }
    }
    [self updateView];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"htmlTemplate" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"#html#" withString:self.detail.html];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    [self getCopyrightView];
    self.copyrightTipsButton.hidden = YES;
  }else if ([CTStringUtil stringNotBlank:self.detail.qiniuUrl]){
    [self updateView];
    if (self.detail.pageCount>0) {
      self.webView.hidden = YES;
    }else{
      NSString *url = [self.detail.qiniuUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]]];
    }
  }else{
    [self updateView];
    if (self.detail.pageCount>0) {
      self.webView.hidden = YES;
    }else{
      self.isUrlFrist = YES;
      NSString *url = [self.detail.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
  }
  [self updateState];
}

-(void)updateState{
  [self.toolbar updateToolBar:self.detail isDocument:self.detailType];
}

- (IBAction)backAction:(id)sender {
  [self baseBackAction];
}


#pragma WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
  if (self.qrCodeView.hidden == YES) {
    [self showHUD];
  }
  [self executeFontSize];
  [self executeJS];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
  [self executeJS];
  decisionHandler(WKNavigationResponsePolicyAllow);
}

-(void)executeJS{
  if(![CTStringUtil stringNotBlank:self.detail.html] ){
    [self executeFontSize];
    if([self.webView.URL.absoluteString containsString:@"toutiao.com"]){
      //隐藏今日头条js
      NSString *hideJs = @"document.getElementsByClassName('banner-pannel pannel-top show-top-pannel')[0].parentNode.style.display='none';";
      [self.webView evaluateJavaScript:hideJs completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"隐藏今日头条banner");
      }];
      //隐藏今日头条的红包js
      NSString *hongbao = @"document.getElementsByTagName('i')[0].parentNode.style.display='none';";
      [self.webView evaluateJavaScript:hongbao completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"隐藏今日头条的红包");
      }];
      //隐藏今日头条底部评论js
      NSString *commentJs = @"document.getElementsByClassName('comments-container box-content')[0].parentNode.style.display='none';";
      [self.webView evaluateJavaScript:commentJs completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"隐藏今日头条底部评论");
      }];
    }
  }
}

//改变字体
-(void)executeFontSize{
  NSInteger fontSize = 100;
  switch ([ObjectShareTool sharedInstance].settingEntity.fontSize) {
    case 1:
      fontSize = 100;
      break;
    case 2:
      fontSize = 120;
      break;
    case 3:
      fontSize = 140;
      break;
    case 4:
      fontSize = 160;
      break;
      
    default:
      break;
  }
  NSInteger font;
  if([CTStringUtil stringNotBlank:self.detail.html]){
    font = fontSize;
  }else if ([CTStringUtil stringNotBlank:self.detail.qiniuUrl]){
    font = 100;
  }else{
    font = fontSize;
  }
  
  NSString *fontSizeJS = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(long)font];
  [self.webView evaluateJavaScript:fontSizeJS completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    NSLog(@"改变字体完成");
  }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
  [self setPictureClickEvent:webView];
  if([self.webView.URL.absoluteString containsString:@"toutiao.com"]&&self.isUrlFrist == YES){
    self.isUrlFrist = NO;
    NSString *url = [self.detail.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
  }
  [self executeJS];
  [self hiddenHUD];
  //  if (!self.isQiniuUrl) {
  //    __weak typeof(self) weakSelf = self;
  //    [self.webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
  ////      weakSelf.webView.frame = CGRectMake(0, weakSelf.webView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT-60);
  //      CGFloat height = [result doubleValue];
  //      weakSelf.webViewHeight = height;
  //      [weakSelf changeWebHeight:height];
  //      weakSelf.isHtml5Finish = YES;
  //      [weakSelf.tableView reloadData];
  //    }];
  //  }
}

//注册图片点击事件
-(void)setPictureClickEvent:(WKWebView *)webView{
  static  NSString * const jsGetImages =
  @"function getImages(){\
  var objs = document.getElementsByTagName(\"img\");\
  var imgScr = '';\
  for(var i=0;i<objs.length;i++){\
  imgScr = imgScr + objs[i].src + '+';\
  };\
  return imgScr;\
  };";
  
  [webView evaluateJavaScript:jsGetImages completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    
  }];
  __weak typeof(self) weakSelf = self;
  [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    NSString *urlResurlt = result;
    weakSelf.mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    if (weakSelf.mUrlArray.count >= 2) {
      [weakSelf.mUrlArray removeLastObject];
    }
  }];
  [webView evaluateJavaScript:@"function registerImageClickAction(){\
   var imgs=document.getElementsByTagName('img');\
   var length=imgs.length;\
   for(var i=0;i<length;i++){\
   img=imgs[i];\
   img.onclick=function(){\
   window.location.href='image-preview:'+this.src}\
   }\
   }" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
     
   }];
  
  [webView evaluateJavaScript:@"registerImageClickAction();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    
  }];
  
  
  static NSString * const js = @"function setCopyright(tag, title, url, content){\
  var isTitleEmpty = (title == null || title.trim().length == 0);\
  var isUrlEmpty = (url == null || url.trim().length == 0);\
  var isContentEmpty = (content == null || content.trim().length == 0);\
  var tmp = null;\
  var tagTmp = document.getElementById('copyright_source_message_tag');\
  tagTmp.style.display = 'compact';\
  tagTmp.innerHTML = tag;\
  tmp = document.getElementById('copyright_source_message_title');\
  if(isTitleEmpty){\
  tmp.style.display = 'none';\
  } else{\
  tmp.style.display = 'compact';\
  tmp.innerHTML = title;\
  }\
  tmp = document.getElementById('copyright_content');\
  if(isContentEmpty){\
  document.getElementById('copyright_title').style.display = 'none';\
  document.getElementById('copyright_bottom_line').style.display = 'none';\
  tmp.style.display = 'none';\
  } else{\
  tmp.style.display = 'compact';\
  tmp.innerHTML = content;\
  }\
  tmp = document.getElementById('copyright_source');\
  if(isTagEmpty && isTitleEmpty && isUrlEmpty){\
  tmp.style.display = 'none';\
  } else{\
  tmp.style.display = 'compact';\
  }\
  tmp = document.getElementById('copyright');\
  if(isTagEmpty && isTitleEmpty && isUrlEmpty && isContentEmpty){\
  tmp.style.display = 'none';\
  } else{\
  }\
  tmp = document.getElementById('copyright_source_message_text');\
  if(isTagEmpty && isTitleEmpty){\
  tmp.style.display = 'none';\
  } else{\
  tmp.style.display = 'compact';\
  }\
  tmp = document.getElementById('copyright_source_url');\
  if(isUrlEmpty){\
  tmp.style.display = 'none';\
  } else{\
  tmp.style.display = 'compact';\
  }\
  }";
  
  [webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    
    
  }];
  NSString *copyright = [NSString stringWithFormat:@"setCopyright('%@', '%@', '%@', '%@')",[CTStringUtil stringNotBlank:self.detail.authorName]?self.detail.authorName:@"",[CTStringUtil stringNotBlank:self.detail.source]?self.detail.source:@"",[CTStringUtil stringNotBlank:self.detail.url]?self.detail.url:@"",[CTStringUtil stringNotBlank:self.detail.notice]?self.detail.notice:@""];
  [webView evaluateJavaScript:copyright completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    
    
  }];
}


// 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  //预览图片
  if ([navigationAction.request.URL.scheme isEqualToString:@"image-preview"]) {
    if (![CTStringUtil stringNotBlank:self.detail.html]&&[CTStringUtil stringNotBlank:self.detail.qiniuUrl]) {
      decisionHandler(WKNavigationActionPolicyCancel);
      return;
    }
    NSString* path = [navigationAction.request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray* tmps = [[NSMutableArray alloc] init];
    int index = 0;
    for (int i = 0; i < self.mUrlArray.count; i ++) {
      NSString *picUrl = self.mUrlArray[i];
      if([picUrl isEqualToString:path]){
        index = i;
      }
      
      LWImageBrowserModel* model = [[LWImageBrowserModel alloc]initWithplaceholder:[UIImage imageNamed:@"morentuzhengfangxing"] thumbnailURL:[NSURL URLWithString:picUrl] HDURL:[NSURL URLWithString:picUrl] containerView:self.view positionInContainer:CGRectMake((SCREEN_WIDTH-100)/2, (SCREEN_HEIGHT-100)/2,100 , 100)index:i];
      [tmps addObject:model];
    }
    
    LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps currentIndex:index];
    browser.isShowPageControl = NO;
    [browser show];
    decisionHandler(WKNavigationActionPolicyCancel);
  }else{
    decisionHandler(WKNavigationActionPolicyAllow);
  }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    completionHandler();
  }]];
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
  [app.navi presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    completionHandler(YES);
  }]];
  [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
    completionHandler(NO);
  }]];
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
  [app.navi presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:webView.URL.host preferredStyle:UIAlertControllerStyleAlert];
  [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.text = defaultText;
  }];
  
  [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    NSString *input = ((UITextField *) alertController.textFields.firstObject).text;
    completionHandler(input);
  }]];
  
  [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    completionHandler(nil);
  }]];
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
  [app.navi presentViewController:alertController animated:YES completion:^{}];
}

#pragma ToobarDelegate

//弹出话题评论view
-(void)detailToolbarOpenTopicCommentAction{
  if(!self.detail){
    return;
  }
  [self openCommentView];
}

//打开评论界面
-(void)openCommentView{
  NSString *placeholder = nil;
  //    if(![CTStringUtil stringNotBlank:self.detail.topicInfo.topicId] || [self.detail.topicInfo.topicId rangeOfString:@"null"].location !=NSNotFound){//未有话题
  //        placeholder = @"请将你想讨论的话题观点详细写出，不能小于10个汉字";
  //    }
  placeholder = @"优质评论将会被优先展示";
  __weak typeof(self) weakSelf = self;
  CGCommentView *comment = [[CGCommentView alloc]initWithContent:self.inputStr placeholder:placeholder finish:^(NSString *data) {
    weakSelf.inputStr = data;
    if(![CTStringUtil stringNotBlank:weakSelf.inputStr]){
      [[CTToast makeText:@"请输入内容"]show:weakSelf.view];
      return;
    }
    [weakSelf.biz.component startBlockAnimation];
    [weakSelf.biz postTopicCommentWithContent:weakSelf.inputStr infoId:weakSelf.detail.infoId type:weakSelf.detail.type success:^(CGCommentEntity *topic) {
      [weakSelf.biz.component stopBlockAnimation];
      //            if(![CTStringUtil stringNotBlank:weakSelf.detail.topicInfo.topicId] || [weakSelf.detail.topicInfo.topicId rangeOfString:@"null"].location !=NSNotFound){//未有话题
      //                [[CTToast makeText:@"话题抢开成功"]show:weakSelf.view];
      //                //查询话题信息
      ////                [weakSelf queryInfoDetailStateById];
      //            }else{
      [[CTToast makeText:@"评论成功"]show:weakSelf.view];
      weakSelf.detail.commentCount ++;
      [weakSelf.toolbar updateToolBar:weakSelf.detail isDocument:weakSelf.detailType];
      //            }
      weakSelf.inputStr = @"";
    } fail:^(NSError *error) {
      [weakSelf.biz.component stopBlockAnimation];
      if(error.code == 110113){//未登录
        CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]init];
        //        [weakSelf presentViewController:controller animated:YES completion:nil];
        [weakSelf.navigationController pushViewController:controller animated:YES];
      }
    }];
  } cancel:^(NSString *data) {
    weakSelf.inputStr = data;
  }];
  [comment showInView:self.view];
}

-(void)openTopicMainControllerAction{
  if(!self.detail){
    return;
  }
  CGTopicMainViewController *controller = [[CGTopicMainViewController alloc]initWithDetail:self.detail];
  controller.info = self.info;
  [self.navigationController pushViewController:controller animated:YES];
}

-(void)detailToolbarDocumentAction{
  CommonWebViewController *vc = [[CommonWebViewController alloc]init];
  NSString *url = [self.detail.qiniuUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  vc.url = [NSString stringWithFormat:@"%@",url];
  [self.navigationController pushViewController:vc animated:YES];
}

//爆料
-(void)detailToolbarScoopAction{
  NSMutableArray *menuItems = [NSMutableArray arrayWithObjects:[KxMenuItem menuItem:@"分享到"
                                                                              image:[UIImage imageNamed:@"gw_fxshare"]
                                                                             target:self
                                                                             action:@selector(detailToolbarShareAction)], nil];
  if ([self isHaveTeamCircel]) {
    [menuItems addObject:[KxMenuItem menuItem:@"发到企业圈"
                                        image:[UIImage imageNamed:@"sentto_tuanduiquan"]
                                       target:self
                                       action:@selector(toTeamCircleAction)]];
  }
  if ([self isHaveEnterpriseHousekeeper]) {
    [menuItems addObject:[KxMenuItem menuItem:@"发到管家区"
                                        image:[UIImage imageNamed:@"sentto_tuanduiquan"]
                                       target:self
                                       action:@selector(toEnterpriseHousekeeperAction)]];
  }
  if ([CTStringUtil stringNotBlank:self.detail.qiniuUrl]) {
    [menuItems addObject:[KxMenuItem menuItem:@"下载文档"
                                        image:[UIImage imageNamed:@"downloadocument"]
                                       target:self
                                       action:@selector(toEmailAction)]];
  }
  [KxMenu setTintColor:[UIColor blackColor]];
  CGRect fromRect = CGRectMake(SCREEN_WIDTH-40, SCREEN_HEIGHT-40, 24,24);
  [KxMenu showMenuInView:self.view
                fromRect:fromRect
               menuItems:menuItems];
  //  [self toTeamCircleAction];
}

-(BOOL)isHaveTeamCircel{
  BOOL ishave = NO;
  for (CGUserOrganizaJoinEntity *companyEntity in [ObjectShareTool sharedInstance].currentUser.companyList) {
    if (companyEntity.auditStete == 1&&companyEntity.companyType !=4) {
      ishave = YES;
      break;
    }
  }
  return ishave;
}

-(BOOL)isHaveEnterpriseHousekeeper{
  BOOL ishave = NO;
  if ([ObjectShareTool sharedInstance].currentUser.housekeeper) {
    for (CGUserOrganizaJoinEntity *companyEntity in [ObjectShareTool sharedInstance].currentUser.companyList) {
      if (companyEntity.auditStete == 1&&companyEntity.companyType ==4) {
        ishave = YES;
        break;
      }
    }
  }
  return ishave;
}

//下载文档
-(void)toEmailAction{
  [self hiddenHUD];
  if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
    if (self.detail.viewPermit == 8) {
      NSString *message = [NSString stringWithFormat:@"是否确定支付%ld知识币下载内容",(long)self.detail.integral];
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:message
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定",nil];
      alert.tag = 1001;
      self.isOpenErcode = YES;
      [alert show];
    }else{
      self.qrCodeView.hidden = NO;
      self.fileNameLabel.text = self.detail.fileName;
      if ([self.detail.fileName hasSuffix:@".rar"]||[self.detail.fileName hasSuffix:@".zip"]) {
        self.tipLabel.text = @"*rar/zip文件分享后无法打开浏览，可分享到电脑端下载后解压打开";
      }else{
        self.tipLabel.text = @"如需打开文档请分享到微信上打开";
      }
      self.fileSizeLabel.text = [NSString stringWithFormat:@"扫我即可下载(%.2fMb)",(float)self.detail.fileSize/(1024.0*1024.0)];
      self.qrcodeIV.image = [QRCodeGenerator qrImageForString:self.detail.downloadUrl imageSize:self.qrcodeIV.frame.size.width];
    }
  }else{
    [self clickToLoginAction];
  }
}

//发送到企业圈
-(void)toTeamCircleAction{
  //    __weak typeof(self) weakSelf = self;
  NSUserDefaults *fact = [NSUserDefaults standardUserDefaults];
  [fact setObject:@YES forKey:@"fact"];
  self.toolbar.admireButton.hidden = YES;
  CGDiscoverReleaseSourceViewController *vc = [[CGDiscoverReleaseSourceViewController alloc]initWithBlock:^(BOOL isCurrent, NSInteger reloadIndex, BOOL isOutside) {
    if (isOutside == NO) {
      if (isCurrent) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HEADLINE_FACT object:[NSNumber numberWithInteger:0]];
      }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HEADLINE_FACT object:[NSNumber numberWithInteger:reloadIndex]];
      }
    }
  }];
  if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
    for (int i =0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
      CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
      if (companyEntity.companyType !=4) {
        CGHorrolEntity *entity;
        if (companyEntity.companyType == 2) {
          entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.classId rolName:companyEntity.companyName sort:0];
        }else{
          entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.companyId rolName:companyEntity.companyName sort:0];
        }
        entity.rolType = [NSString stringWithFormat:@"%d",companyEntity.companyType];
        vc.currentEntity = entity;
        vc.releaseType = DiscoverReleaseTypeCompany;
        break;
      }
    }
  }else{
    vc.releaseType = DiscoverReleaseTypeNoCompany;
  }
  
  CGDiscoverLink *link = [[CGDiscoverLink alloc]init];
  link.linkIcon = self.detail.infoPic;
  link.linkId = self.detail.infoId;
  link.linkTitle = self.detail.title;
  link.linkType = self.detail.type;
  vc.link = link;
  if ([ObjectShareTool sharedInstance].currentUser.companyList.count > 0) {
    vc.releaseType = HeadlineReleaseTypeCompany;
  }else{
    vc.releaseType = HeadlineReleaseTypeNoCompany;
  }
  vc.type = 0;
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)toEnterpriseHousekeeperAction{
  CGDiscoverReleaseSourceViewController *vc = [[CGDiscoverReleaseSourceViewController alloc]initWithBlock:^(BOOL isCurrent, NSInteger reloadIndex, BOOL isOutside) {
    if (isOutside == NO) {
      if (isCurrent) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HEADLINE_FACT object:[NSNumber numberWithInteger:0]];
      }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HEADLINE_FACT object:[NSNumber numberWithInteger:reloadIndex]];
      }
    }
  }];
  if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
    for (int i =0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
      CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
      if (companyEntity.companyType ==4) {
        CGHorrolEntity *entity;
        if (companyEntity.companyType == 2) {
          entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.classId rolName:companyEntity.companyName sort:0];
        }else{
          entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.companyId rolName:companyEntity.companyName sort:0];
        }
        entity.rolType = [NSString stringWithFormat:@"%d",companyEntity.companyType];
        vc.currentEntity = entity;
        vc.releaseType = DiscoverReleaseTypeCompany;
        break;
      }
    }
  }else{
    vc.releaseType = DiscoverReleaseTypeNoCompany;
  }
  
  CGDiscoverLink *link = [[CGDiscoverLink alloc]init];
  link.linkIcon = self.detail.infoPic;
  link.linkId = self.detail.infoId;
  link.linkTitle = self.detail.title;
  link.linkType = self.detail.type;
  vc.link = link;
  if ([ObjectShareTool sharedInstance].currentUser.companyList.count > 0) {
    vc.releaseType = HeadlineReleaseTypeCompany;
  }else{
    vc.releaseType = HeadlineReleaseTypeNoCompany;
  }
  vc.type = 1;
  [self.navigationController pushViewController:vc animated:YES];
}

//支付费用
-(void)detailToolbarPayFeeAction{
  //初始化AlertView
  [self hiddenHUD];
  NSString *message = [NSString stringWithFormat:@"是否确定支付%ld知识币查看内容",self.detail.integral];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定",nil];
  alert.tag = 1001;
  [alert show];
}

//访问工具网址
-(void)detailToolbarAccessWebSitesAction{
  if (self.detail.appList.count>0) {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<self.detail.appList.count>0; i++) {
      CGAppListEntity *entity = self.detail.appList[i];
      [array addObject:[KxMenuItem menuItem:entity.appName
                                      image:nil
                                     target:self
                                     action:@selector(todown:)]];
    }
    CGRect fromRect = CGRectMake(10, SCREEN_HEIGHT-40, SCREEN_WIDTH-167-10,24);
    //  CGRect toRect = [sender convertRect:fromRect toView:self.view];
    [KxMenu setTintColor:[UIColor blackColor]];
    [KxMenu showMenuInView:self.view
                  fromRect:fromRect
                 menuItems:array];
  }
}

//下载文档
-(void)detailToolbarDownloadDocumentAction{
  [self hiddenHUD];
  if ([ObjectShareTool sharedInstance].currentUser.isLogin) {
    if (self.detail.viewPermit == 8) {
      NSString *message = [NSString stringWithFormat:@"是否确定支付%ld知识币下载内容",(long)self.detail.integral];
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:message
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定",nil];
      alert.tag = 1001;
      self.isOpenErcode = YES;
      [alert show];
    }else{
      self.qrCodeView.hidden = NO;
      self.fileNameLabel.text = self.detail.fileName;
      if ([self.detail.fileName hasSuffix:@".rar"]||[self.detail.fileName hasSuffix:@".zip"]) {
        self.tipLabel.text = @"*rar/zip文件分享后无法打开浏览，可分享到电脑端下载后解压打开";
      }else{
        self.tipLabel.text = @"如需打开文档请分享到微信上打开";
      }
      self.fileSizeLabel.text = [NSString stringWithFormat:@"扫我即可下载(%.2fMb)",(float)self.detail.fileSize/(1024.0*1024.0)];
      self.qrcodeIV.image = [QRCodeGenerator qrImageForString:self.detail.downloadUrl imageSize:self.qrcodeIV.frame.size.width];
    }
  }else{
    [self clickToLoginAction];
  }
}


-(void)todown:(KxMenuItem *)sender{
  for (CGAppListEntity *entity in self.detail.appList) {
    if ([sender.title isEqualToString:entity.appName]) {
      if ([entity.appName isEqualToString:@"Iphone下载"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:entity.appUrl]];
      }else if ([entity.appName isEqualToString:@"微信公众号"]){
        [self hiddenHUD];
        self.qrCodeView.hidden = NO;
        self.qrcodeIV.image = [QRCodeGenerator qrImageForString:entity.appUrl imageSize:self.qrcodeIV.frame.size.width];
      }else{
        CommonWebViewController *vc = [[CommonWebViewController alloc]init];
        vc.url = entity.appUrl;
        [self.navigationController pushViewController:vc animated:YES];
      }
      break;
    }
  }
}

//收藏事件
-(void)detailToolbarCollectAction{
  if(![CTStringUtil stringNotBlank:self.detail.infoId]){
    return;
  }
  int collect = 1;
  if(self.detail.isFollow == 0){
    collect = 1;
  }else{
    collect = 0;
  }
  [[[HeadLineDao alloc]init]updateInfoDataByKey:HeadlineInfo_isFollow value:[NSString stringWithFormat:@"%d",collect] infoId:self.info.infoId table:HeadlineInfo_tableName];
  [[[HeadLineDao alloc]init]updateInfoDataByKey:HeadlineInfoDetail_isFollow value:[NSString stringWithFormat:@"%d",collect] infoId:self.detail.infoId table:HeadlineInfoDetail_tableName];
  self.detail.isFollow = self.detail.isFollow == 0 ? 1 : 0;
  self.info.isFollow = collect;
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATECOLLECTSTATE object:nil];
  [self updateState];
  self.biz = [[HeadlineBiz alloc]init];
  __weak typeof(self) weakSelf = self;
  [self.biz collectWithId:self.detail.infoId type:self.detail.type collect:collect success:^{
  } fail:^(NSError *error) {
    weakSelf.toolbar.collectImage.userInteractionEnabled = YES;
  }];
}


//分享
-(void)detailToolbarShareAction{
  if(!self.detail){
    return;
  }
  NSUserDefaults *share = [NSUserDefaults standardUserDefaults];
  [share setObject:@YES forKey:@"share"];
  self.toolbar.prizeButton.hidden = YES;
  self.shareUtil = [[ShareUtil alloc]init];
  __weak typeof(self) weakSelf = self;
  NSString *desc = @"";
  if (self.detailType == 4) {
    desc = @"我在会议猫发现了这个非常优质的岗位工具，现在也推荐给你";
  }else if (self.type == 1){
    desc = @"我在会议猫发现了这份非常优质的知识，现在也推荐给你";
  }else{
    desc = @"我在会议猫发现了这份非常优质的文档，现在也推荐给你";
  }
  [self.shareUtil showShareMenuWithTitle:self.detail.title desc:desc isqrcode:1 image:[UIImage imageNamed:@"login_image"] url:self.detail.shareUrl block:^(NSMutableArray *array) {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
    [weakSelf presentViewController:activityVC animated:YES completion:nil];
  }];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
  return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  self.manMadeScroll = YES;
  if (self.webView.scrollView == scrollView) {
    [self hiddenHUD];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  self.currentPostion = scrollView.contentOffset.y;
  if(self.manMadeScroll){
    if(self.currentPostion <= 0){
      [self hideStatusBar:NO];
    }else{
      [self hideStatusBar:YES];
    }
  }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  self.manMadeScroll = NO;
  [self hideStatusBar:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  self.manMadeScroll = NO;
}

//显示/隐藏状态栏
-(void)hideStatusBar:(BOOL)show{
  self.isStatusBar = show;
  CGRect tuiRect = self.tuiBtn.frame;
  CGRect competeRect = self.rightBtn.frame;
  CGRect copyrighRect = self.copyrightTipsButton.frame;
  CGRect bgScrollViewRect = self.webView.frame;
  CGFloat horizontalHeight = self.isHorizontal?0:44;
  UIColor *btnColor;
  if(show){
    tuiRect.origin.y = 10;
    competeRect.origin.y = 10;
    copyrighRect.origin.y = 15;
    bgScrollViewRect.size.height = SCREEN_HEIGHT - horizontalHeight;
    bgScrollViewRect.origin.y = 0;
    btnColor = [CTCommonUtil convert16BinaryColor:HeadlineTopCircelColor];
  }else{
    if(self.currentPostion <= 0){
      if ([self.detail.qiniuUrl hasSuffix:@"xls"]||[self.detail.qiniuUrl hasSuffix:@"xlsx"]){
        btnColor = [CTCommonUtil convert16BinaryColor:HeadlineTopCircelColor];
      }else{
        btnColor = [UIColor clearColor];
      }
      tuiRect.origin.y = 30;
      competeRect.origin.y = 30;
      copyrighRect.origin.y = 35;
      
      bgScrollViewRect.size.height = SCREEN_HEIGHT -horizontalHeight -20;
      bgScrollViewRect.origin.y = 20;
    }else{
      btnColor = [CTCommonUtil convert16BinaryColor:HeadlineTopCircelColor];
    }
  }
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.3 animations:^{
    [[UIApplication sharedApplication] setStatusBarHidden:!(weakSelf.currentPostion <= 0) withAnimation:UIStatusBarAnimationSlide];
    weakSelf.webView.frame = bgScrollViewRect;
    weakSelf.tableView.frame = bgScrollViewRect;
    weakSelf.tuiBtn.frame = tuiRect;
    weakSelf.rightBtn.frame = competeRect;
    weakSelf.copyrightTipsButton.frame = copyrighRect;
    [weakSelf.tuiBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:btnColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [weakSelf.rightBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:btnColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(void)dealloc{
  self.webView.scrollView.delegate = nil;
  self.webView.navigationDelegate = nil;
  self.webView.UIDelegate = nil;
  if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f){
    NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                    WKWebsiteDataTypeDiskCache,
                                                    WKWebsiteDataTypeOfflineWebApplicationCache,
                                                    WKWebsiteDataTypeMemoryCache,
                                                    WKWebsiteDataTypeCookies,
                                                    WKWebsiteDataTypeSessionStorage,
                                                    WKWebsiteDataTypeIndexedDBDatabases,
                                                    WKWebsiteDataTypeWebSQLDatabases
                                                    ]];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
      
    }];
  }else{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    NSError *errors;
    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
  }
}

-(void)showHUD{
  [self.view addSubview:self.hudIV];
  [self.view bringSubviewToFront:self.hudIV];
}

- (void)hiddenHUD{
  [self.hudIV removeFromSuperview];
}

-(UIImageView *)hudIV{
  if (!_hudIV) {
    _hudIV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-152)/2, (SCREEN_HEIGHT-152)/2, 152, 152)];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    _hudIV.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
  }
  return _hudIV;
}

-(void)sourceClick{
  CommonWebViewController *vc = [[CommonWebViewController alloc]init];
  vc.url = self.detail.url;
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)headerDidSelectButtonWithIndex:(NSInteger)index{
  self.selectType = index;
}

- (IBAction)hiddenQrcodeAction:(UIButton *)sender {
  self.qrCodeView.hidden = YES;
  self.isOpenErcode = NO;
}

- (IBAction)shareDownUrlAction:(UIButton *)sender {
  self.shareUtil = [[ShareUtil alloc]init];
  __weak typeof(self) weakSelf = self;
  NSString *desc = @"";
  if ([self.detail.fileName hasSuffix:@"rar"]||[self.detail.fileName hasSuffix:@"zip"]) {
    desc = @"此压缩文件无法在手机上浏览，请在电脑端下载后解压打开";
  }else{
    desc = @"我在会议猫上面下载了这份文件，现在也发送给你";
  }
  self.shareUtil.isDownFire = YES;
  [self.shareUtil showShareMenuWithTitle:self.detail.fileName desc:desc isqrcode:1 image:[UIImage imageNamed:@"login_image"] url:self.detail.downloadUrl block:^(NSMutableArray *array) {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
    [weakSelf presentViewController:activityVC animated:YES completion:nil];
  }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.detail.width<=0) {
    return 150;
  }
  return SCREEN_WIDTH*self.detail.height/self.detail.width+10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if (section != 0) {
    return 5;
  }
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
  view.backgroundColor = [UIColor whiteColor];
  return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  if (self.detail.width<=0) {
    return 0;
  }
  return self.imageList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSMutableArray *tmps = [NSMutableArray array];
  for (int i = 0; i < self.imageList.count; i ++) {
    NSString *picUrl = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg",self.imageList[i]];
    [tmps addObject:picUrl];
  }
  CGDetailBigImageViewController *vc = [[CGDetailBigImageViewController alloc]initWithArray:tmps currIndex:indexPath.section];
  [self.navigationController pushViewController:vc animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString* cellIdentifier = @"CGDetailTableViewCell";
  CGDetailTableViewCell *cell = (CGDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDetailTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  NSString *url = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg",self.imageList[indexPath.section]];
  if (self.detail.width>1920) {
    url = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/!30p",self.imageList[indexPath.section]];
  }
  [cell updateDetailString:url];
  return cell;
}

-(void)updateimageList{
  SDWebImageManager* manager = [SDWebImageManager sharedManager];
  SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
  __weak typeof(self) weakSelf = self;
  if (self.imageList.count>0) {
    NSString *url = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg",self.imageList[0]];
    [manager loadImageWithURL:[NSURL URLWithString:url] options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
      
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
      if (finished && image) {
        weakSelf.detail.width = image.size.width;
        weakSelf.detail.height = image.size.height;
        [weakSelf.tableView reloadData];
      }
    }];
  }
}
@end
