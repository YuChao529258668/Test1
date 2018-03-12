//
//  CGKnowledgeCatalogController.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/26.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKnowledgeCatalogController.h"
#import "CGDiscoverCircleNullTableViewCell.h"
#import "CGInfoHeadEntity.h"
#import "CGKnowledgeBiz.h"
#import "HeadlineLeftPicTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "HeadlineCatalogTableViewCell.h"
#import "CGHeadlineInfoDetailController.h"
#import "KxMenu.h"
#import "HeadlineBiz.h"
#import "ShareUtil.h"
#import "XRWaterfallLayout.h"
#import "CGInterfaceImageViewCollectionViewCell.h"
#import "CGHeadlineBigImageViewController.h"
#import "CGMainLoginViewController.h"
#import "CGEnterpriseMemberViewController.h"
#import "CGBuyVIPViewController.h"
#import "commonViewModel.h"
#import "QRCodeGenerator.h"
#import "CGKnowLedgeListEntity.h"
#import "CGKonwledgeLeftTableViewCell.h"
#import "CGKonwledgeRightTableViewCell.h"
#import "CGKonwledgeTextTableViewCell.h"
#import "CGKonwledgeMoreTableViewCell.h"
#import "SDCycleScrollView.h"

@interface CGKnowledgeCatalogController ()<HeadlineLeftPicTableViewCellDelegate,HeadlineMorePicTableViewCellDelegate,HeadlineRightPicTableViewCellDelegate,HeadlineOnlyTitleTableViewCellDelegate,HeadlineCatalogTableViewCellDelegate,XRWaterfallLayoutDelegate>
@property (nonatomic, strong) HeadlineBiz *biz;
@property (nonatomic, copy) NSString *mainId;
@property (nonatomic, copy) NSString *packageId;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *cataId;
@property (nonatomic, assign) NSInteger isFirst;
@property(nonatomic,assign)int page;
@property(nonatomic,retain)ShareUtil *shareUtil;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, assign) NSInteger type;
@property (weak, nonatomic) IBOutlet UILabel *viewPromptLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) CGPermissionsEntity *permission;
@property (nonatomic, strong) commonViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIView *qrBgView;
@property (weak, nonatomic) IBOutlet UILabel *qrDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UILabel *qrTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) SDCycleScrollView *topView;
@property (nonatomic, assign) NSInteger isPay;//点击下载文档支付完成
@property (nonatomic, strong) CGKnowledgePackageEntity *dataList;
@end
static NSString * const Identifier = @"CGInterfaceImageViewCell";
//#define KnowledgeKey [NSString stringWithFormat:@"%@%@%@%ld",self.packageId,self.mainId,self.cataId,self.type]

@implementation CGKnowledgeCatalogController

-(instancetype)initWithmainId:(NSString *)mainId packageId:(NSString *)packageId companyId:(NSString *)companyId cataId:(NSString *)cataId{
    self = [super init];
    if(self){
        self.mainId = mainId;
        self.packageId = packageId;
        self.companyId = companyId;
        self.cataId = cataId;
    }
    return self;
}

-(SDCycleScrollView *)topView{
    if(!_topView){
        _topView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOPIMAGEHEIGHT) delegate:nil placeholderImage:[UIImage imageNamed:@"faxianmorentu"]];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _topView.currentPageDotColor = [UIColor colorWithWhite:0.7 alpha:0.5]; // 自定义分页控件小圆标颜色
        _topView.pageDotColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        _topView.autoScrollTimeInterval = 30;
    }
    return _topView;
}

-(commonViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[commonViewModel alloc]init];
    }
    return _viewModel;
}

-(HeadlineBiz *)biz{
    if(!_biz){
        _biz = [[HeadlineBiz alloc]init];
    }
    return _biz;
}


- (void)viewDidLoad {
    self.page = 1;
    [super viewDidLoad];
    self.shareButton.layer.cornerRadius = 4;
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.backgroundColor = CTThemeMainColor;
    //  self.title = self.titleStr;
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
    self.rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setImage:[UIImage imageNamed:@"radar_Subject_library_more"] forState:UIControlStateNormal];
    [self.navi addSubview:self.rightBtn];
    self.rightBtn.hidden = YES;
    self.tableview.separatorColor = CTCommonLineBg;
    //  CGKnowledgePackageEntity *dataList = [[ObjectShareTool sharedInstance].knowledgeDict objectForKey:KnowledgeKey];
    //  self.title = dataList.title;
    //  self.isFirst = dataList.list.count>0?NO:YES;
    self.isFirst = YES;
    [self.tableview registerNib:[UINib nibWithNibName:@"HeadlineOnlyTitleTableViewCell" bundle:nil] forCellReuseIdentifier:identifierOnlyTitle];
    [self.tableview registerNib:[UINib nibWithNibName:@"HeadlineLeftPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPic];
    [self.tableview registerNib:[UINib nibWithNibName:@"HeadlineRightPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierRightPic];
    [self.tableview registerNib:[UINib nibWithNibName:@"HeadlineMorePicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierMorePic];
    [self.tableview registerNib:[UINib nibWithNibName:@"HeadlineCatalogTableViewCell" bundle:nil] forCellReuseIdentifier:identifierCatalog];
    self.button.layer.cornerRadius = 4;
    self.button.layer.masksToBounds = YES;
    self.button.backgroundColor = CTThemeMainColor;
    self.tableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    //创建瀑布流布局
    XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    //或者一次性设置
    [waterfall setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    //设置代理，实现代理方法
    waterfall.delegate = self;
    [self.collectionView setCollectionViewLayout:waterfall];
    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGInterfaceImageViewCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:Identifier];
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        [[ObjectShareTool sharedInstance].knowledgeDict removeObjectForKey:KnowledgeKey];
        weakSelf.page = 1;
        [self queryListWithMode:0 page:weakSelf.page];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"下拉加载" forState:MJRefreshStatePulling];
    [header setTitle:@"玩命加载中" forState:MJRefreshStateRefreshing];
    self.tableview.mj_header = header;
    
    //  if (self.showType == 0) {
    //上拉加载更多
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [self queryListWithMode:1 page:weakSelf.page];
    }];
    //  }
    [self.tableview.mj_header beginRefreshing];
    //    [self queryListWithMode:0 page:self.page];
    //购买会员成功回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bugVipSuccess) name:NOTIFICATION_BUYMEMBER object:nil];
}

-(void)bugVipSuccess{
    [self.tableview.mj_header beginRefreshing];
}

-(void)rightBtnAction:(UIButton *)sender{
    NSMutableArray *menuItems = [NSMutableArray array];
    if (!self.dataList.showType) {
        [menuItems addObject:[KxMenuItem menuItem:self.type == 0?@"只显示图片":@"全部显示"
                                            image:[UIImage imageNamed:@"phinterface"]
                                           target:self
                                           action:@selector(doChangeAction)]];
    }
    [menuItems addObject:[KxMenuItem menuItem:self.dataList.isFollow==0?@"收藏":@"取消收藏"
                                        image:[UIImage imageNamed:@"minecollectionwb"]
                                       target:self
                                       action:@selector(doCollectAction)]];
    [menuItems addObject:[KxMenuItem menuItem:@"分享"
                                        image:[UIImage imageNamed:@"gw_fxshare"]
                                       target:self
                                       action:@selector(doShareAction)]];
    if ([CTStringUtil stringNotBlank:self.dataList.downloadUrl]||self.dataList.viewPermit == 8) {
        [menuItems addObject:[KxMenuItem menuItem:@"下载文档"
                                            image:[UIImage imageNamed:@"downloadocument"]
                                           target:self
                                           action:@selector(doDownLoadAction)]];
    }
    
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
    [KxMenu setTintColor:[UIColor blackColor]];
}

-(void)doDownLoadAction{
    if (self.dataList.viewPermit == 8) {
        self.isPay = YES;
        NSString *message = [NSString stringWithFormat:@"是否确定支付%ld金币下载文档",self.dataList.integral];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = 1001;
        [alert show];
    }else{
        [self openFire];
    }
}

-(void)openFire{
    self.qrBgView.hidden = NO;
    self.qrTitleLabel.text = self.dataList.fileName;
    if ([self.dataList.fileName hasSuffix:@".rar"]) {
        self.tipLabel.hidden = NO;
    }else{
        self.tipLabel.hidden = YES;
    }
    self.qrDescLabel.text = [NSString stringWithFormat:@"扫我即可下载(%.2fMb)",self.dataList.fileSize/(1024.0*1024.0)];
    self.qrImageView.image = [QRCodeGenerator qrImageForString:self.dataList.downloadUrl imageSize:self.qrImageView.frame.size.width];
}

- (IBAction)shareAction:(UIButton *)sender {
    self.shareUtil = [[ShareUtil alloc]init];
    __weak typeof(self) weakSelf = self;
    NSString *desc = @"";
    if ([self.dataList.fileName hasSuffix:@"rar"]||[self.dataList.fileName hasSuffix:@"zip"]) {
        desc = @"此压缩文件无法在手机上浏览，请在电脑端下载后解压打开";
    }else{
        desc = @"我在议事猫上面下载了这份文件，现在也发送给你";
    }
    [self.shareUtil showShareMenuWithTitle:self.dataList.fileName desc:desc isqrcode:1 image:[UIImage imageNamed:@"login_image"] url:self.dataList.downloadUrl block:^(NSMutableArray *array) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
        [weakSelf presentViewController:activityVC animated:YES completion:nil];
    }];
}

- (IBAction)hiddenQrBgView:(UIButton *)sender {
    self.qrBgView.hidden = YES;
}

-(void)doCollectAction{
    self.dataList.isFollow = !self.dataList.isFollow;
    [self.biz collectWithId:self.packageId type:26 collect:(int)self.dataList.isFollow success:^{
        
    } fail:^(NSError *error) {
    }];
}

-(void)doChangeAction{
    if (self.type == 0) {
        self.type = 15;
        self.collectionView.hidden = NO;
    }else{
        self.type = 0;
        self.collectionView.hidden = YES;
    }
    [self.tableview.mj_header beginRefreshing];
}

-(void)doShareAction{
    NSString *url = self.dataList.shareUrl;
    //  url = [self encodeString:url];
    __weak typeof(self) weakSlef = self;
    self.shareUtil = [[ShareUtil alloc]init];
    [self.shareUtil showShareMenuWithTitle:self.dataList.title desc:@"我在议事猫发现了这份非常优质的专辑，现在也推荐给你" isqrcode:1 image:self.dataList.cover url:url block:^(NSMutableArray *array) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
        [weakSlef presentViewController:activityVC animated:YES completion:nil];
    }];
}

-(void)updateWith:(CGPermissionsEntity *)entity{
    self.bgView.hidden = NO;
    if (entity.viewPermit == -1||entity.viewPermit == 6) {
        self.viewPromptLabel.text = entity.viewPrompt;
        self.button.hidden = NO;
        [self.button setTitle:@"登录" forState:UIControlStateNormal];
    }else if (entity.viewPermit==2||entity.viewPermit==3) {
        self.viewPromptLabel.text = entity.viewPrompt;
        self.button.hidden = YES;
    }else if (entity.viewPermit==1||entity.viewPermit==5||entity.viewPermit==7){
        self.viewPromptLabel.text = entity.viewPrompt;
        self.button.hidden = NO;
        [self.button setTitle:entity.viewPermit==1||entity.viewPermit==7?@"我要升级":@"我要成为VIP企业" forState:UIControlStateNormal];
        if (entity.viewPermit == 5 &&[ObjectShareTool sharedInstance].currentUser.companyList.count!=1) {
            self.button.hidden = YES;
            self.viewPromptLabel.text = @"你无权限阅读";
        }
    }else if (entity.viewPermit==4){
        NSString *integral = [NSString stringWithFormat:@"%ld",entity.integral];
        NSString *str = [NSString stringWithFormat:@"需支付%ld金币才能查看",entity.integral];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [str length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [str length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, integral.length+3)];
        
        self.viewPromptLabel.attributedText = attributedString;
        self.button.hidden = NO;
        [self.button setTitle:@"付费" forState:UIControlStateNormal];
    }else if (entity.viewPermit == 9){
        self.viewPromptLabel.text = entity.viewPrompt;
        self.button.hidden = YES;
    }
}

- (IBAction)permissionClick:(UIButton *)sender {
    if (self.permission.viewPermit == -1||self.permission.viewPermit == 6) {
        [self clickToLoginAction];
    }else if (self.permission.viewPermit==1||self.permission.viewPermit == 7){
        CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
        vc.type = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.permission.viewPermit==5){
        CGEnterpriseMemberViewController *vc = [[CGEnterpriseMemberViewController alloc]init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.permission.viewPermit == 4){
        //初始化AlertView
        NSString *message = [NSString stringWithFormat:@"是否确定支付%ld金币查看专辑",self.permission.integral];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = 1001;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        self.isPay = NO;
    }
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            if ([ObjectShareTool sharedInstance].currentUser.integralNum<self.permission.integral) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"金币不够提示"
                                                                message:@"你可以通过以下两个方式增加金币：\n1）按金币奖励规则完成任务获得金币\n2）在线支付充值金币"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"我要充值",nil];
                alert.tag = 1002;
                [alert show];
                return;
            }
            __weak typeof(self) weakSelf = self;
            NSString *ID = [CTStringUtil stringNotBlank:self.mainId]?self.mainId:self.packageId;
            [[[HeadlineBiz alloc]init] headlinesInfoDetailsIntegralPurchaseWithType:0 ID:ID integral:self.permission.integral success:^{
                weakSelf.page = 1;
                [weakSelf queryListWithMode:0 page:weakSelf.page];
            } fail:^(NSError *error) {
                
            }];
        }
    }else if (alertView.tag == 1002){
        if (buttonIndex ==1) {
            CGBuyVIPViewController *vc = [[CGBuyVIPViewController alloc]init];
            vc.type = 4;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//点击登录
-(void)clickToLoginAction{
    __weak typeof(self) weakSelf = self;
    CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]initWithBlock:^(CGUserEntity *user) {
        [weakSelf queryListWithMode:0 page:weakSelf.page];
    } fail:^(NSError *error) {
        
    }];
    //    [self presentViewController:controller animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

-(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString*encodedString=(NSString*)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)unencodedString,
                                                              
                                                              NULL,
                                                              
                                                              (CFStringRef)@"!*'();@&+$,?%#[]",
                                                              
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
    
}


#pragma mark - Data

-(void)queryListWithMode:(int)mode page:(int)page{
    __weak typeof(self) weakSelf = self;
    //    if(mode == 1||!self.dataList){
    CGKnowledgeBiz *biz = [[CGKnowledgeBiz alloc]init];
    NSString *packageID = self.packageId;
    if ([CTStringUtil stringNotBlank:self.mainId]) {
        packageID = @"";
    }
    
    if (self.isPresendByMyDocumentController) {
        [biz getMyDocumentWithMainId:self.mainId packageId:packageID cataId:self.cataId page:page type:self.type success:^(CGKnowledgePackageEntity *result,CGPermissionsEntity *entity) {
            if (entity) {
                weakSelf.permission = entity;
                [weakSelf updateWith:entity];
                weakSelf.title = entity.title;
            }else{
                weakSelf.title = result.title;
                weakSelf.bgView.hidden = YES;
                weakSelf.isFirst = NO;
                if(result){
                    if (!weakSelf.isShowMenu) {
                        weakSelf.rightBtn.hidden = NO;
                    }
                    if (result.list.count>0) {
                        if ([result.list[0] isKindOfClass:[CGInfoHeadEntity class]]) {
                            for (CGInfoHeadEntity *entity in result.list) {
                                if ([entity.label isEqualToString:@"附件"]) {
                                    entity.label = @"";
                                }
                            }
                        }
                    }
                    if (weakSelf.type == 15&&result.showType == 1) {
                        NSMutableArray *coverArray = [NSMutableArray array];
                        for (CGKnowLedgeListEntity *entity in result.list) {
                            [coverArray addObjectsFromArray:entity.list];
                        }
                        result.list = coverArray;
                    }
                    if (result.showType&&[CTStringUtil stringNotBlank:result.cover]) {
                        weakSelf.tableview.tableHeaderView = weakSelf.topView;
                        weakSelf.topView.imageURLStringsGroup = @[result.cover];
                    }else{
                        weakSelf.tableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
                    }
                    
                    //把列表放到内存
                    if(mode == 0){
                        //              [[ObjectShareTool sharedInstance].knowledgeDict setObject:result forKey:KnowledgeKey];
                        weakSelf.dataList = result;
                        if (result.showType) {
                            weakSelf.tableview.mj_footer = nil;
                        }
                        weakSelf.tableview.mj_footer.state = MJRefreshStateIdle;
                        [weakSelf.tableview.mj_header endRefreshing];
                    }else{
                        //              CGKnowledgePackageEntity *dataList = [[ObjectShareTool sharedInstance].knowledgeDict objectForKey:KnowledgeKey];
                        if (result.list.count>0) {
                            [weakSelf.dataList.list addObjectsFromArray:result.list];
                            [weakSelf.tableview.mj_footer endRefreshing];
                        }else{
                            weakSelf.tableview.mj_footer.state = MJRefreshStateNoMoreData;
                        }
                        //              [[ObjectShareTool sharedInstance].knowledgeDict setObject:dataList forKey:KnowledgeKey];
                    }
                }else{
                    if (mode == 1) {
                        weakSelf.tableview.mj_footer.state = MJRefreshStateNoMoreData;
                    }else{
                        [weakSelf.tableview.mj_header endRefreshing];
                        [weakSelf.tableview.mj_footer endRefreshing];
                    }
                }
                if (weakSelf.type == 0) {
                    [weakSelf.tableview reloadData];
                }else{
                    [weakSelf.collectionView reloadData];
                }
            }
            if (weakSelf.isPay) {
                weakSelf.isPay = NO;
                [weakSelf openFire];
            }
        } fail:^(NSError *error) {
            [weakSelf.tableview.mj_header endRefreshing];
            [weakSelf.tableview.mj_footer endRefreshing];
        }];
        return;
    }
    
    
    
    // 获取公司文档，楼上是获取我的文档
    
    [biz queryKnowledgePackageWithMainId:self.mainId packageId:packageID companyId:self.companyId cataId:self.cataId page:page type:self.type success:^(CGKnowledgePackageEntity *result,CGPermissionsEntity *entity) {
        if (entity) {
            weakSelf.permission = entity;
            [weakSelf updateWith:entity];
            weakSelf.title = entity.title;
        }else{
            weakSelf.title = result.title;
            weakSelf.bgView.hidden = YES;
            weakSelf.isFirst = NO;
            if(result){
                if (!weakSelf.isShowMenu) {
                    weakSelf.rightBtn.hidden = NO;
                }
                if (result.list.count>0) {
                    if ([result.list[0] isKindOfClass:[CGInfoHeadEntity class]]) {
                        for (CGInfoHeadEntity *entity in result.list) {
                            if ([entity.label isEqualToString:@"附件"]) {
                                entity.label = @"";
                            }
                        }
                    }
                }
                if (weakSelf.type == 15&&result.showType == 1) {
                    NSMutableArray *coverArray = [NSMutableArray array];
                    for (CGKnowLedgeListEntity *entity in result.list) {
                        [coverArray addObjectsFromArray:entity.list];
                    }
                    result.list = coverArray;
                }
                if (result.showType&&[CTStringUtil stringNotBlank:result.cover]) {
                    weakSelf.tableview.tableHeaderView = weakSelf.topView;
                    weakSelf.topView.imageURLStringsGroup = @[result.cover];
                }else{
                    weakSelf.tableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
                }
                
                //把列表放到内存
                if(mode == 0){
                    //              [[ObjectShareTool sharedInstance].knowledgeDict setObject:result forKey:KnowledgeKey];
                    weakSelf.dataList = result;
                    if (result.showType) {
                        weakSelf.tableview.mj_footer = nil;
                    }
                    weakSelf.tableview.mj_footer.state = MJRefreshStateIdle;
                    [weakSelf.tableview.mj_header endRefreshing];
                }else{
                    //              CGKnowledgePackageEntity *dataList = [[ObjectShareTool sharedInstance].knowledgeDict objectForKey:KnowledgeKey];
                    if (result.list.count>0) {
                        [weakSelf.dataList.list addObjectsFromArray:result.list];
                        [weakSelf.tableview.mj_footer endRefreshing];
                    }else{
                        weakSelf.tableview.mj_footer.state = MJRefreshStateNoMoreData;
                    }
                    //              [[ObjectShareTool sharedInstance].knowledgeDict setObject:dataList forKey:KnowledgeKey];
                }
            }else{
                if (mode == 1) {
                    weakSelf.tableview.mj_footer.state = MJRefreshStateNoMoreData;
                }else{
                    [weakSelf.tableview.mj_header endRefreshing];
                    [weakSelf.tableview.mj_footer endRefreshing];
                }
            }
            if (weakSelf.type == 0) {
                [weakSelf.tableview reloadData];
            }else{
                [weakSelf.collectionView reloadData];
            }
        }
        if (weakSelf.isPay) {
            weakSelf.isPay = NO;
            [weakSelf openFire];
        }
    } fail:^(NSError *error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
    //    }else{
    //        [weakSelf.tableview reloadData];
    //        [weakSelf.tableview.mj_header endRefreshing];
    //        [weakSelf.tableview.mj_footer endRefreshing];
    //    }
}



#pragma mark -



//-(NSMutableArray *)queryDataListFromLocal{
//    CGKnowledgePackageEntity *dataList = [[ObjectShareTool sharedInstance].knowledgeDict objectForKey:KnowledgeKey];
//    return dataList.list;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isFirst) {
        return 0;
    }
    if(self.dataList.list.count <= 0){
        return 1;
    }else if (self.dataList.showType){
        CGKnowLedgeListEntity *entity = self.dataList.list[section];
        if (entity.direction == 3) {
            return 1;
        }
        return entity.list.count;
    }else{
        return self.dataList.list.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataList.list.count <= 0){
        NSString*identifier = @"CGDiscoverCircleNullTableViewCell";
        CGDiscoverCircleNullTableViewCell *cell = (CGDiscoverCircleNullTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGDiscoverCircleNullTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"暂无数据~";
        cell.icon.image = [UIImage imageNamed:@"no_data"];
        return cell;
    }
    
    if (self.dataList.showType) {
        CGKnowLedgeListEntity *entity = self.dataList.list[indexPath.section];
        CGInfoHeadEntity *info = entity.list[indexPath.row];
        if (entity.direction == 1){//左图
            NSString*identifier = @"CGKonwledgeLeftTableViewCell";
            CGKonwledgeLeftTableViewCell *cell = (CGKonwledgeLeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGKonwledgeLeftTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                cell.backgroundColor = [UIColor clearColor];
            }
            cell.titleLabel.text = info.title;
            NSString *url;
            if (info.imglist.count>0) {
                NSDictionary *dic = info.imglist[0];
                url = dic[@"src"];
                [cell.icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"morentu"]];
                cell.titleTrailing.constant = 120;
                cell.icon.hidden = NO;
            }else{
                cell.titleTrailing.constant = 15;
                cell.icon.hidden = YES;
            }
            return cell;
        }else if (entity.direction == 2){//右图
            NSString*identifier = @"CGKonwledgeRightTableViewCell";
            CGKonwledgeRightTableViewCell *cell = (CGKonwledgeRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGKonwledgeRightTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                cell.backgroundColor = [UIColor clearColor];
            }
            cell.titleLabel.text = info.title;
            NSString *url;
            if (info.imglist.count>0) {
                NSDictionary *dic = info.imglist[0];
                url = dic[@"src"];
                [cell.icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"morentu"]];
                cell.titleLeading.constant = 120;
                cell.icon.hidden = NO;
            }else{
                cell.titleLeading.constant = 15;
                cell.icon.hidden = YES;
            }
            return cell;
        }else if (entity.direction == 0){//仅标题
            NSString*identifier = @"CGKonwledgeTextTableViewCell";
            CGKonwledgeTextTableViewCell *cell = (CGKonwledgeTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGKonwledgeTextTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                cell.backgroundColor = [UIColor clearColor];
            }
            cell.titleLabel.text = info.title;
            return cell;
        }else{
            NSString*identifier = @"CGKonwledgeMoreTableViewCell";
            CGKonwledgeMoreTableViewCell *cell = (CGKonwledgeMoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGKonwledgeMoreTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                cell.backgroundColor = [UIColor clearColor];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) weakSelf = self;
            [cell update:entity.list block:^(CGInfoHeadEntity *item) {
                [weakSelf.viewModel messageCommandWithCommand:item.command parameterId:item.parameterId commpanyId:item.commpanyId recordId:item.recordId messageId:item.messageId detial:nil typeArray:nil];
            }];
            return cell;
        }
    }
    
    NSInteger fontSize = 17;
    switch ([ObjectShareTool sharedInstance].settingEntity.fontSize) {
        case 1:
            fontSize = 17;
            break;
        case 2:
            fontSize = 19;
            break;
        case 3:
            fontSize = 20;
            break;
        case 4:
            fontSize = 24;
            break;
            
        default:
            break;
    }
    CGInfoHeadEntity *info = self.dataList.list[indexPath.row];
    if (info.layout == ContentLayoutLeftPic||info.layout == ContentLayoutUnknown){//左图标
        HeadlineLeftPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPic];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineLeftPicTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.close.hidden = YES;
        cell.timeType = 0;
        [cell updateItem:info];
        cell.title.font = [UIFont systemFontOfSize:fontSize];
        cell.delegate = self;
        return cell;
    }else if (info.layout == ContentLayoutMorePic){//多图
        HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineMorePicTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.close.hidden = YES;
        cell.timeType = 0;
        [cell updateItem:info];
        cell.title.font = [UIFont systemFontOfSize:fontSize];
        cell.delegate = self;
        return cell;
    }else if (info.layout == ContentLayoutRightPic){//右图
        HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineRightPicTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.close.hidden = YES;
        cell.timeType = 0;
        [cell updateItem:info];
        cell.title.font = [UIFont systemFontOfSize:fontSize];
        cell.delegate = self;
        return cell;
    }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
        HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineOnlyTitleTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.close.hidden = YES;
        cell.timeType = 0;
        [cell updateItem:info];
        cell.title.font = [UIFont systemFontOfSize:fontSize];
        cell.delegate = self;
        return cell;
    }else if(info.layout == ContentLayoutCatalog){//目录
        HeadlineCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCatalog];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HeadlineCatalogTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell updateItem:info];
        cell.textLabel.font = [UIFont systemFontOfSize:fontSize];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.dataList.list.count <= 0){
        return 1;
    }
    if (self.dataList.showType) {
        return self.dataList.list.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.dataList.list.count <= 0||self.dataList.showType==0){
        return 0.01;
    }else{
        if (section == 0) {
            return 50;
        }
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.dataList.list.count <= 0||self.dataList.showType==0){
        return nil;
    }else{
        CGKnowLedgeListEntity *entity = self.dataList.list[section];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        view.backgroundColor = [UIColor whiteColor];
        CGFloat labelY = 0;
        if (section > 0) {
            UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            [view addSubview:topView];
            topView.backgroundColor = CTCommonViewControllerBg;
            labelY = 10;
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, labelY, SCREEN_WIDTH-30, 50)];
        label.text = entity.title;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        label.textColor = TEXT_MAIN_CLR;
        [view addSubview:label];
        
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(15, labelY, SCREEN_WIDTH-30, 50)];
        tip.text = entity.tip;
        tip.font = [UIFont systemFontOfSize:13];
        tip.textColor = [UIColor lightGrayColor];
        [view addSubview:tip];
        tip.textAlignment = NSTextAlignmentRight;
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 49.5+labelY, SCREEN_WIDTH-30, 0.5)];
        line.backgroundColor = CTCommonLineBg;
        [view addSubview:line];
        
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataList.list.count <= 0){
        return tableView.bounds.size.height;
    }
    if (self.dataList.showType) {
        CGKnowLedgeListEntity *entity = self.dataList.list[indexPath.section];
        CGInfoHeadEntity *info = entity.list[indexPath.row];
        if (entity.direction == 1){//左图
            if (info.imglist.count<=0) {
                return 70;
            }
            return 100;
        }else if (entity.direction == 2){//右图
            if (info.imglist.count<=0) {
                return 70;
            }
            return 100;
        }else if (entity.direction == 0){//仅标题
            return 70;
        }else{
            return [CGKonwledgeMoreTableViewCell height:entity.list];
        }
    }
    
    CGInfoHeadEntity *info = self.dataList.list[indexPath.row];
    
    if (info.layout == ContentLayoutLeftPic||info.layout == ContentLayoutUnknown){//左图标
        return 116;
    }else if (info.layout == ContentLayoutMorePic){//多图
        HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
        [cell updateItem:info];
        return cell.height;
    }else if (info.layout == ContentLayoutRightPic){//右图
        HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
        [cell updateItem:info];
        return cell.height;
    }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
        HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
        [cell updateItem:info];
        return cell.height;
    }else if(info.layout == ContentLayoutCatalog){//目录
        return 55;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.dataList.list.count <= 0){
        return;
    }
    if (self.dataList.showType) {
        CGKnowLedgeListEntity *entity = self.dataList.list[indexPath.section];
        CGInfoHeadEntity *info = entity.list[indexPath.row];
        [self.viewModel messageCommandWithCommand:info.command parameterId:info.parameterId commpanyId:info.commpanyId recordId:info.recordId messageId:info.messageId detial:nil typeArray:nil];
    }else{
        CGInfoHeadEntity *item = self.dataList.list[indexPath.row];
        if(item.layout == ContentLayoutCatalog){//目录
            CGKnowledgeCatalogController *controller = [[CGKnowledgeCatalogController alloc]initWithmainId:nil packageId:item.packageId companyId:nil cataId:item.infoId];
            controller.icon = item.packageId;
            controller.titleStr = item.title;
            [self.navigationController pushViewController:controller animated:YES];
        }else{//非目录
            [self.viewModel messageCommandWithCommand:item.command parameterId:item.parameterId commpanyId:item.commpanyId recordId:item.recordId messageId:item.messageId detial:item typeArray:nil];
        }
    }
}


#pragma CellDelegate

-(void)headlineCloseInfoCallBack:(CGInfoHeadEntity *)info cell:(UITableViewCell *)cell closeBtnY:(float)closeBtnY{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGInterfaceImageViewCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    CGInfoHeadEntity *product = self.dataList.list[indexPath.item];
    cell.product = product;
    return cell;
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    CGInfoHeadEntity *interface = self.dataList.list[indexPath.row];
    if (interface.layout == ContentLayoutCatalog) {
        CGKnowledgeCatalogController *controller = [[CGKnowledgeCatalogController alloc]initWithmainId:nil packageId:interface.packageId companyId:nil cataId:interface.infoId];
        controller.icon = interface.packageId;
        controller.titleStr = interface.title;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self doProductDetailWithIndex:indexPath.item];
    }
}

#pragma mark  - <XRWaterfallLayoutDelegate>

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    CGInfoHeadEntity *interface = self.dataList.list[indexPath.row];
    if (interface.layout == ContentLayoutCatalog) {
        return 150;
    }
    if (interface.width<=0) {
        return 300;
    }
    return itemWidth * interface.height / interface.width+40;
    
}

- (void)doProductDetailWithIndex:(NSInteger )index{
    CGHeadlineBigImageViewController *vc = [[CGHeadlineBigImageViewController alloc]init];
    vc.array = self.dataList.list;
    vc.currentPage = index;
    [self.navigationController pushViewController:vc animated:NO];
}

@end

