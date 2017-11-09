//
//  CGHeadlineGlobalSearchCommonDetailViewController.m
//  CGSays
//
//  Created by zhu on 2016/11/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGHeadlineGlobalSearchCommonDetailViewController.h"
#import "SearchHistoricalTableViewCell.h"
#import "HeadlineMorePicTableViewCell.h"
#import "HeadlineRightPicTableViewCell.h"
#import "HeadlineOnlyTitleTableViewCell.h"
#import "CGSearchSourceCircleTableViewCell.h"
#import "HeadlineBiz.h"
#import "CGHeadlineInfoDetailController.h"
#import "HeadlineLeftPicAddTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "InterfaceTableViewCell.h"
#import "CGHeadlineBigImageViewController.h"
#import "CommentaryTableViewCell.h"
#import "SearchCompanyTableViewCell.h"
#import "SearchProductTableViewCell.h"
#import "CGAttentionProductViewController.h"
//带界面的语音识别控件
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import <iflyMSC/iflyMSC.h>
#import "CGInterfaceImageViewCollectionViewCell.h"
#import "XRWaterfallLayout.h"
#import "commonViewModel.h"

static NSString * const Identifier = @"CGInterfaceImageViewCell";
@interface CGHeadlineGlobalSearchCommonDetailViewController ()<UITextFieldDelegate,InterfaceDelegate,IFlyRecognizerViewDelegate,XRWaterfallLayoutDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) HeadlineBiz *biz;
@property (nonatomic, assign) BOOL isClick;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,retain)NSMutableString *speekWord;//语音识别的词
@property(nonatomic,retain)IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) commonViewModel *viewModel;
@end

@implementation CGHeadlineGlobalSearchCommonDetailViewController

-(commonViewModel *)viewModel{
  if (!_viewModel) {
    _viewModel = [[commonViewModel alloc]init];
  }
  return _viewModel;
}

-(NSMutableString *)speekWord{
  if(!_speekWord){
    _speekWord = [NSMutableString string];
  }
  return _speekWord;
}

-(instancetype)initWithClear:(CGHeadlineGlobalSearchCommonDetailClearBlock)cancel voiceSearchBlock:(CGHeadlineGlobalSearchCommonVoiceSearchBlock)voiceSearchBlock{
    self = [super init];
    if(self){
        clearBlock = cancel;
      voiceBlock = voiceSearchBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.biz = [[HeadlineBiz alloc]init];
    [self getNaviButton];
    self.isClick = YES;
  self.textField.text = self.keyWord;
  __weak typeof(self) weakSelf = self;
  if (self.type == 15) {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.hidden = NO;
    self.tableView.hidden = YES;
    //创建瀑布流布局
    XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    //或者一次性设置
    [waterfall setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    //设置代理，实现代理方法
    waterfall.delegate = self;
    [self.collectionView setCollectionViewLayout:waterfall];
    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGInterfaceImageViewCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:Identifier];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      [weakSelf getDataModel:0];
    }];
    //上拉刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
      [weakSelf getDataModel:1];
    }];
    [self.collectionView.mj_header beginRefreshing];
  }else{
    self.collectionView.hidden = YES;
    self.tableView.hidden = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
//    self.textField.text = self.keyWord;
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineOnlyTitleTableViewCell" bundle:nil] forCellReuseIdentifier:identifierOnlyTitle];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineLeftPicAddTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPic];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineRightPicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierRightPic];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadlineMorePicTableViewCell" bundle:nil] forCellReuseIdentifier:identifierMorePic];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPicCompany];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchProductTableViewCell" bundle:nil] forCellReuseIdentifier:identifierLeftPicProduct];
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      [weakSelf getDataModel:0];
    }];
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
      [weakSelf getDataModel:1];
    }];
    [self.tableView.mj_header beginRefreshing];
  }
}

-(void)getDataModel:(NSInteger)model{
  __weak typeof(self) weakSelf = self;
  if (model) {
    self.page = self.page+1;
  }else{
    weakSelf.page = 1;
  }
  if (self.type == 1){
    [weakSelf.biz commonSearchInfoWithKeyword:weakSelf.keyWord pageNo:weakSelf.page level:weakSelf.level action:weakSelf.infoAction ID:weakSelf.typeID success:^(NSMutableArray *result) {
      if (model) {
        if(result.count > 0){
          [weakSelf.dataArray addObjectsFromArray:result];
          if (weakSelf.type == 15) {
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.collectionView reloadData];
          }else{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
          }
        }else{
          if (weakSelf.type == 15) {
            weakSelf.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
          }else{
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
          }
        }
      }else{
        if (result.count<=0) {
          weakSelf.bgView.hidden = NO;
        }else{
          weakSelf.bgView.hidden = YES;
          weakSelf.dataArray = result;
        }
        if (weakSelf.type == 15) {
          weakSelf.collectionView.mj_footer.state = MJRefreshStateIdle;
          [weakSelf.collectionView.mj_header endRefreshing];
          [weakSelf.collectionView reloadData];
        }else{
          weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
          [weakSelf.tableView reloadData];
          [weakSelf.tableView.mj_header endRefreshing];
        }
      }
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
      [weakSelf.collectionView.mj_header endRefreshing];
    }];
  }else{
    [weakSelf.biz commonSearchWithKeyword:weakSelf.keyWord pageNo:weakSelf.page type:weakSelf.type action:weakSelf.action ID:weakSelf.typeID subType:weakSelf.subType success:^(NSMutableArray *result) {
      if (model) {
        if(result.count > 0){
          if (weakSelf.type == 16) {
            for (int i =0; i<result.count; i++) {
              CGSearchSourceCircleEntity *entity = result[i];
              SearchCellLayout *layout = [weakSelf layoutWithStatusModel:entity];
              [weakSelf.dataArray addObject:layout];
            }
          }else{
            [weakSelf.dataArray addObjectsFromArray:result];
          }
          if (weakSelf.type == 15) {
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.collectionView reloadData];
          }else{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
          }
        }else{
          if (weakSelf.type == 15) {
            weakSelf.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
          }else{
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
          }
        }
      }else{
        if (weakSelf.type == 16) {
          for (int i =0; i<result.count; i++) {
            CGSearchSourceCircleEntity *entity = result[i];
            SearchCellLayout *layout = [weakSelf layoutWithStatusModel:entity];
            [weakSelf.dataArray addObject:layout];
          }
        }else{
          weakSelf.dataArray = result;
        }
        if (weakSelf.type == 15) {
          weakSelf.collectionView.mj_footer.state = MJRefreshStateIdle;
          [weakSelf.collectionView.mj_header endRefreshing];
          [weakSelf.collectionView reloadData];
        }else{
          weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
          [weakSelf.tableView reloadData];
          [weakSelf.tableView.mj_header endRefreshing];
        }
      }
    } fail:^(NSError *error) {
      [weakSelf.tableView.mj_header endRefreshing];
      [weakSelf.collectionView.mj_header endRefreshing];
    }];
  }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if (self.type == 15) {
    if ((scrollView.contentOffset.y+self.collectionView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.collectionView.frame.size.height) {
      if (self.collectionView.mj_footer.isRefreshing == NO&&self.collectionView.mj_footer.state != MJRefreshStateNoMoreData){
        self.collectionView.mj_footer.state = MJRefreshStateRefreshing;
      }
    }
  }else{
    if ((scrollView.contentOffset.y+self.tableView.frame.size.height+AUTOREFRESHFOOTHEIGHT)>scrollView.contentSize.height&&scrollView.contentSize.height>self.tableView.frame.size.height) {
      if (self.tableView.mj_footer.isRefreshing == NO&&self.tableView.mj_footer.state != MJRefreshStateNoMoreData){
        self.tableView.mj_footer.state = MJRefreshStateRefreshing;
      }
    }
  }
}


-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.isClick = YES;
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if (self.type == 15) {
    [self.collectionView reloadData];
  }
}

- (void)getNaviButton{
  UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(55, 27, SCREEN_WIDTH-70, 30)];
  [self.navi addSubview:bgView];
  bgView.layer.cornerRadius = 4;
  bgView.backgroundColor = [UIColor whiteColor];
  bgView.layer.masksToBounds = YES;
  UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-30, 0, 30, 30)];
  [searchBtn addTarget:self action:@selector(voiceSearch) forControlEvents:UIControlEventTouchUpInside];
  [searchBtn setImage:[UIImage imageNamed:@"searchVoiceinput"] forState:UIControlStateNormal];
  [bgView addSubview:searchBtn];
  self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-70-30, 30)];
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 22)];
  UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 22, 22)];
  [view addSubview:iv];
  iv.image = [UIImage imageNamed:@"tuanduiquansousuo"];
  self.textField.leftView = view;
  self.textField.font = [UIFont systemFontOfSize:15];
  self.textField.leftViewMode = UITextFieldViewModeAlways;
  self.textField.borderStyle = UITextBorderStyleNone;
  self.textField.placeholder = @"请输入关键字";
  self.textField.returnKeyType = UIReturnKeySearch;
  self.textField.enablesReturnKeyAutomatically = YES;
  self.textField.delegate = self;
  self.textField.clearButtonMode = UITextFieldViewModeAlways;
  [self.navi addSubview:self.textField];
  [bgView addSubview:self.textField];
}

-(void)voiceSearch{
  [self.textField resignFirstResponder];
  //初始化语音识别控件
  self.iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
  self.iflyRecognizerView.delegate = self;
  [self.iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
  //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
  [self.iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
  //启动识别服务
  [self.iflyRecognizerView start];
}

/*科大讯飞语音识别回调
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast{
  for(NSString *key in [resultArray[0] allKeys]){
    NSData *wordData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *allWordDict = [NSJSONSerialization JSONObjectWithData:wordData options:kNilOptions error:nil];
    NSArray *wordArray = [allWordDict objectForKey:@"ws"];
    for(NSDictionary *wordDict in wordArray){
      for(NSDictionary *itemWord in [wordDict objectForKey:@"cw"]){
        NSString *end = [itemWord objectForKey:@"w"];
        if(![end containsString:@"。"] && ![end containsString:@"，"]&& ![end containsString:@"！"]){
          [self.speekWord appendString:end];
        }
      }
    }
  }
  if(isLast){//最后一次
    NSString *word = self.speekWord;
    self.textField.text = word;
    if([CTStringUtil stringNotBlank:word]){//word为语音识别结果
      self.keyWord = word;
      self.textField.text = word;
      voiceBlock(word);
      [self.tableView.mj_header beginRefreshing];
    }
    self.speekWord = nil;
    self.iflyRecognizerView = nil;
  }
}
/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error{
  
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.text.length<=0) {
        clearBlock(YES);
    }else{
        clearBlock(NO);
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)baseBackAction{
    if (self.isH5) {
        //通知H5当前已在APP打开
        if (self.isClick) {
            self.isClick = NO;
            __weak typeof(self) weakSelf = self;
            [WKWebViewController setPath:@"goBack" code:[NSNumber numberWithInt:-1] success:^(id response) {
                [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:(weakSelf.navigationController.viewControllers.count-3)]  animated:YES];
            } fail:^{
                weakSelf.isClick = YES;
            }];
        }
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count-3)]  animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.row] isKindOfClass:[CGInfoHeadEntity class]]) {
        CGInfoHeadEntity *info = self.dataArray[indexPath.row];
        if (info.type == 11) {
            return 212;
        }else if (info.type == 17|| info.type ==21){
            return [CommentaryTableViewCell height:info];
        }else if (info.type == 15){
            return 395;
        }else if (info.type == 1||info.type == 14){
            if (info.layout == ContentLayoutMorePic){//多图
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
            }
        }
      if (info.type == 3 ||info.type == 4 || info.type ==8) {
        return 70;
      }else{
        return 122;
      }
    }else{
        SearchCellLayout* layout = self.dataArray[indexPath.row];
        return layout.cellHeight;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 15) {
        return (self.dataArray.count / 2) + (self.dataArray.count % 2);
    }
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.dataArray[indexPath.row] isKindOfClass:[CGInfoHeadEntity class]]) {
        CGInfoHeadEntity *info = self.dataArray[indexPath.row];
      [self.viewModel messageCommandWithCommand:info.command parameterId:info.parameterId commpanyId:info.commpanyId recordId:info.recordId messageId:info.messageId detial:info typeArray:nil];
//        if (info.infoId.length<=0) {
//            return;
//        }
//      CGHeadlineInfoDetailController *detail = [[CGHeadlineInfoDetailController alloc]initWithInfoId:info.infoId type:info.type block:^{
//        
//      }];
//      detail.info = info;
//      [self.navigationController pushViewController:detail animated:YES];
    }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataArray[indexPath.row] isKindOfClass:[CGInfoHeadEntity class]]) {
        CGInfoHeadEntity *info = self.dataArray[indexPath.row];
        if (info.type == 11) {
            static NSString* cellIdentifier = @"RecommendTableViewCell";
            RecommendTableViewCell *cell = (RecommendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RecommendTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateInfo:info];
            return cell;
        }else if (info.type == 17|| info.type ==21){
            static NSString* cellIdentifier = @"CommentaryTableViewCell";
            CommentaryTableViewCell *cell = (CommentaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommentaryTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateInfo:info];
            return cell;
        }else if (info.type == 15){
            static NSString* cellIdentifier = @"InterfaceTableViewCell";
            InterfaceTableViewCell *cell = (InterfaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"InterfaceTableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //可能是奇数可能是偶数
            CGInfoHeadEntity *product1 = self.dataArray[indexPath.row * 2];
            cell.product1 = product1;
            cell.leftButton.tag = indexPath.row * 2;
          NSInteger lastcount = self.dataArray.count%2 == 0?self.dataArray.count/2:self.dataArray.count/2+1;
          if (lastcount-1==indexPath.row) {
            if (self.dataArray.count % 2 == 0) {
              CGInfoHeadEntity *product2 = self.dataArray[indexPath.row * 2 + 1];
              cell.product2 = product2;
              cell.rightButton.tag = indexPath.row * 2 + 1;
            }
          }else{
            CGInfoHeadEntity *product2 = self.dataArray[indexPath.row * 2 + 1];
            cell.product2 = product2;
            cell.rightButton.tag = indexPath.row * 2 + 1;
          }
            cell.delegate = self;
            return cell;
        }else if (info.type == 1||info.type == 14||info.type == 26){
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
            if (info.layout == ContentLayoutMorePic){//多图
                HeadlineMorePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMorePic];
                cell.title.font = [UIFont systemFontOfSize:fontSize];
              cell.timeType = 2;
                [cell updateItem:info];
                cell.close.hidden = YES;
                return cell;
            }else if (info.layout == ContentLayoutRightPic){//右图
                HeadlineRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRightPic];
                cell.title.font = [UIFont systemFontOfSize:fontSize];
              cell.timeType = 2;
                [cell updateItem:info];
                cell.close.hidden = YES;
                return cell;
            }else if (info.layout == ContentLayoutOnlyTitle){//仅标题
                HeadlineOnlyTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOnlyTitle];
                cell.title.font = [UIFont systemFontOfSize:fontSize];
              cell.timeType = 2;
                [cell updateItem:info];
                cell.close.hidden = YES;
                return cell;
            }else{
                HeadlineLeftPicAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPic];
              cell.timeType = 2;
                [cell updateItem:info action:self.action type:self.type typeID:self.typeID groupId:self.groupId isAttention:NO subjectId:nil];
                return cell;
            }
        }else{
          SearchProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeftPicProduct];
          [cell updateItem:info action:self.action type:self.type typeID:self.typeID groupId:self.groupId isAttention:NO subjectId:nil];
          return cell;
        }
    }else{
        static NSString* cellIdentifier = @"cellIdentifier";
        CGSearchSourceCircleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[CGSearchSourceCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [self confirgueCell:cell atIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)confirgueCell:(CGSearchSourceCircleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    SearchCellLayout* cellLayout = self.dataArray[indexPath.row];
    cell.cellLayout = cellLayout;
    [self callbackWithCell:cell];
}

- (void)callbackWithCell:(CGSearchSourceCircleTableViewCell *)cell {
    __weak typeof(self) weakSelf = self;
    cell.clickedReCommentCallback = ^(CGSearchSourceCircleTableViewCell* cell,SourceCircComments* model) {
        
    };
    //展开全文点击回调
    cell.clickedOpenCellCallback = ^(CGSearchSourceCircleTableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself openTableViewCell:cell];
    };
    //收起全文点击回调
    cell.clickedCloseCellCallback = ^(CGSearchSourceCircleTableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself closeTableViewCell:cell];
    };
    //头像点击回调
    cell.clickedAvatarCallback = ^(CGSearchSourceCircleTableViewCell* cell) {
    };
    //图片点击回调
    cell.clickedImageCallback = ^(CGSearchSourceCircleTableViewCell* cell,NSInteger imageIndex) {
    };
    //点击链接回调
    cell.linkCallback = ^(CGSearchSourceCircleTableViewCell* cell,CGDiscoverLink *link){
        __strong typeof(weakSelf) sself = weakSelf;
        CGHeadlineInfoDetailController *vc = [[CGHeadlineInfoDetailController alloc]initWithInfoId:link.linkId type:link.linkType block:^{
          
        }];
        [sself.navigationController pushViewController:vc animated:YES];
    };
}

//展开Cell
- (void)openTableViewCell:(CGSearchSourceCircleTableViewCell *)cell {
    SearchCellLayout* layout =  self.dataArray[cell.indexPath.row];
    CGSearchSourceCircleEntity* model = layout.entity;
    SearchCellLayout* newLayout = [[SearchCellLayout alloc] initWithStatusModel:model isUnfold:YES dateFormatter:self.dateFormatter];
    [self.dataArray replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

//折叠Cell
- (void)closeTableViewCell:(CGSearchSourceCircleTableViewCell *)cell {
    SearchCellLayout* layout =  self.dataArray[cell.indexPath.row];
    CGSearchSourceCircleEntity* model = layout.entity;
    SearchCellLayout* newLayout = [[SearchCellLayout alloc] initWithStatusModel:model isUnfold:NO dateFormatter:self.dateFormatter];
    
    [self.dataArray replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

- (SearchCellLayout *)layoutWithStatusModel:(CGSearchSourceCircleEntity *)statusModel{
    SearchCellLayout* layout = [[SearchCellLayout alloc] initWithStatusModel:statusModel isUnfold:NO dateFormatter:self.dateFormatter];
    return layout;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.biz.component stopBlockAnimation];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  
  return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  CGInterfaceImageViewCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
  CGInfoHeadEntity *product = self.dataArray[indexPath.item];
  cell.product = product;
  return cell;
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
  [self doProductDetailWithIndex:indexPath.item];
}

#pragma mark  - <XRWaterfallLayoutDelegate>

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
  //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
  CGInfoHeadEntity *interface = self.dataArray[indexPath.row];
  if (interface.width<=0) {
    return 300;
  }
  return itemWidth * interface.height / interface.width+40;
  
}

- (void)doProductDetailWithIndex:(NSInteger )index{
  //  NSMutableArray *array = [NSMutableArray array];
  //  for (int i = 0; i<self.dataArray.count; i++) {
  //    CGProductInterfaceEntity *entity = self.dataArray[i];
  //    NSString *cover = entity.cover;
  //    [array addObject:cover];
  //  }
  CGHeadlineBigImageViewController *vc = [[CGHeadlineBigImageViewController alloc]init];
  vc.array = self.dataArray;
  vc.currentPage = index;
  [self.navigationController pushViewController:vc animated:NO];
}

- (BOOL)isSupportPanReturnBack{
  return NO;
}

@end
