//
//  CGHeadlineGlobalSearchViewController.m
//  CGSays
//
//  Created by zhu on 16/11/12.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGHeadlineGlobalSearchViewController.h"
#import "SearchTopTableViewCell.h"
#import "SearchHistoricalTableViewCell.h"
#import "CGHeadlineGlobalSearchDetailViewController.h"
#import "CGHeadlineGlobalSearchCommonDetailViewController.h"
#import "HeadlineBiz.h"
#import "CGLocalSearchTableViewCell.h"
#import "SearchDao.h"
#import "CGSearchTitleTableViewCell.h"
#import "CGHotSearchTableViewCell.h"
#import "commonViewModel.h"

@interface CGHeadlineGlobalSearchViewController ()<UITextFieldDelegate,IFlyRecognizerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *keyWordArray;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) UITextField *textField;
@property(nonatomic,retain)IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) commonViewModel *viewModel;
@property(nonatomic,retain)NSMutableString *speekWord;//语音识别的词
@end

@implementation CGHeadlineGlobalSearchViewController

-(NSMutableString *)speekWord{
  if(!_speekWord){
    _speekWord = [NSMutableString string];
  }
  return _speekWord;
}

-(commonViewModel *)viewModel{
  if (!_viewModel) {
    _viewModel = [[commonViewModel alloc]init];
  }
  return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = NO;
    [self getNaviButton];
    self.isClick = YES;
    self.keyWordArray = [NSMutableArray array];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  if (self.keyWord.length>0) {
    self.textField.text = self.keyWord;
    if (self.type) {
      [self gotoSearchView:self.textField.text];
    }else{
      [self gotoMoreSearchView:self.textField.text];
    }
  }
  
  [self getLocalData];
//  [self getHotData];
}

-(void)gotoMoreSearchView:(NSString *)keyword{
  __weak typeof(self) weakSelf = self;
  CGHeadlineGlobalSearchDetailViewController *vc = [[CGHeadlineGlobalSearchDetailViewController alloc]initWithClear:^(BOOL clearKeyword) {
    if (clearKeyword) {
      weakSelf.textField.text = @"";
    }
  } voiceSearchBlock:^(NSString *keyWord) {
    weakSelf.textField.text = keyWord;
  }];
  vc.searchType = self.searchType;
  vc.selectIndex = self.selectIndex;
  vc.action = self.action;
  vc.keyWord = keyword;
  vc.typeID = self.typeID;
  [self.navigationController pushViewController:vc animated:NO];
}

-(void)gotoSearchView:(NSString *)keyword{
  __weak typeof(self) weakSelf = self;
  CGHeadlineGlobalSearchCommonDetailViewController *vc = [[CGHeadlineGlobalSearchCommonDetailViewController alloc]initWithClear:^(BOOL clearKeyword) {
    if (clearKeyword) {
      weakSelf.textField.text = @"";
    }
  } voiceSearchBlock:^(NSString *keyWord) {
    weakSelf.textField.text = keyWord;
  }];
  vc.searchType = self.searchType;
  vc.isH5 = self.isHtml5;
  vc.keyWord = keyword;
  vc.type = self.type;
  vc.action = self.action;
  vc.typeID = self.typeID;
  vc.infoAction = self.infoAction;
  vc.level = self.level;
  vc.subType = self.subType;
  [self.navigationController pushViewController:vc animated:NO];
}

-(NSInteger)getHotSearchType{
  int type = self.type;
  if (self.type!=0||self.type!=3||self.type!=4||self.type!=8) {
    type = 18;
  }
  return type;
}

-(void)getHotData{
  __weak typeof(self) weakSelf = self;
  [SearchDao queryHotSearchFromDBWithType:[self getHotSearchType] success:^(NSMutableArray *result) {
    weakSelf.hotArray = result;
    [weakSelf.tableView reloadData];
    HeadlineBiz *biz = [[HeadlineBiz alloc]init];
    [biz headlinesHotsearchListWithPage:1 action:self.searchType==0?1:2 type:[weakSelf getHotSearchType] success:^(NSMutableArray *result) {
      weakSelf.hotArray = result;
      [weakSelf.tableView reloadData];
      [SearchDao saveHotSearchToDB:result type:[weakSelf getHotSearchType]];
    } fail:^(NSError *error) {
      
    }];
  } fail:^(NSError *error) {
    
  }];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.textField.text.length>0) {
        HeadlineBiz *biz = [[HeadlineBiz alloc]init];
        __weak typeof(self) weakSelf = self;
        [biz jpSearchWithKeyword:self.textField.text success:^(NSMutableArray *result) {
            weakSelf.keyWordArray = result;
            [weakSelf.tableView reloadData];
        } fail:^(NSError *error) {
            
        }];
    }else{
        [self.tableView reloadData];
    }
}

- (void)getNaviButton{
  UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(55, 27, SCREEN_WIDTH-70, 30)];
  [self.navi addSubview:bgView];
  bgView.layer.cornerRadius = 4;
  bgView.backgroundColor = [UIColor whiteColor];
  bgView.layer.masksToBounds = YES;
  
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-70-30, 30)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 22)];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 22, 22)];
    [view addSubview:iv];
    iv.image = [UIImage imageNamed:@"tuanduiquansousuo"];
    self.textField.leftView = view;
  UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-30, 0, 30, 30)];
  [searchBtn addTarget:self action:@selector(voiceSearch) forControlEvents:UIControlEventTouchUpInside];
  [searchBtn setImage:[UIImage imageNamed:@"searchVoiceinput"] forState:UIControlStateNormal];
  [bgView addSubview:searchBtn];
  
  self.textField.rightViewMode = UITextFieldViewModeAlways;
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.placeholder = @"请输入关键字";
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.enablesReturnKeyAutomatically = YES;
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    [self.textField becomeFirstResponder];
    [bgView addSubview:self.textField];
}

-(void)baseBackAction{
  if (self.isHtml5) {
    if (self.isClick) {
      self.isClick = NO;
      __weak typeof(self) weakSelf = self;
      [WKWebViewController setPath:@"goBack" code:[NSNumber numberWithInt:-1] success:^(id response) {
        weakSelf.isClick = YES;
        [weakSelf.navigationController popViewControllerAnimated:YES];
      } fail:^{
        weakSelf.isClick = YES;
      }];
    }
  }else{
    [self.navigationController popViewControllerAnimated:YES];
  }
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
    [SearchDao saveSearchToDB:self.textField.text type:self.searchType];
    if([CTStringUtil stringNotBlank:word]){//word为语音识别结果
      if (self.type) {
        [self gotoSearchView:self.textField.text];
      }else{
        [self gotoMoreSearchView:self.textField.text];
      }
    }else{
      [self.tableView reloadData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    if (self.textField.text.length>0) {
        HeadlineBiz *biz = [[HeadlineBiz alloc]init];
        __weak typeof(self) weakSelf = self;
        [biz jpSearchWithKeyword:self.textField.text success:^(NSMutableArray *result) {
            weakSelf.keyWordArray = result;
            [weakSelf.tableView reloadData];
        } fail:^(NSError *error) {
            
        }];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.isClick = YES;
  [self getLocalData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.returnKeyType==UIReturnKeySearch)
    {
        if ([textField.text length] > 0)
        {
          [SearchDao saveSearchToDB:textField.text type:self.searchType];
        }
        if (self.type) {
          [self gotoSearchView:self.textField.text];
        }else{
          [self gotoMoreSearchView:self.textField.text];
        }
    }
    return YES;
}

-(void)getLocalData{
  __weak typeof(self) weakSelf = self;
  [SearchDao querySearchFromDBWithType:self.searchType success:^(NSMutableArray *result) {
    weakSelf.dataArray = result;
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    
  }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textField resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    NSString*identifier = @"CGLocalSearchTableViewCell";
    CGLocalSearchTableViewCell *cell = (CGLocalSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGLocalSearchTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell update:self.dataArray];
    return cell.height;
  }
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  if ([CTStringUtil stringNotBlank:self.attentionType]&&section == 0&&self.textField.text.length == 0) {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [view addSubview:btn];
    view.backgroundColor = CTCommonViewControllerBg;
    [btn setTitle:self.attentionType forState:UIControlStateNormal];
    [btn setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(allAttentionCLick) forControlEvents:UIControlEventTouchUpInside];
    view.layer.masksToBounds = YES;
    return view;
  }else if (section == 0||section==2){
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = CTCommonViewControllerBg;
    return view;
  }
  return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  if (self.textField.text.length>0) {
    return 1;
  }
//    return 4;
  return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.textField.text.length > 0) {
        return self.keyWordArray.count;
    }
  if (section!=3) {
    return 1;
  }
  return self.hotArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([CTStringUtil stringNotBlank:self.attentionType]&&section==0&&self.textField.text.length == 0) {
    return 30;
  }else if (section==0 ||section==2) {
    return 10;
  }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type) {
        if (self.textField.text.length>0) {
          [self gotoSearchView:self.keyWordArray[indexPath.row]];
          [SearchDao saveSearchToDB:self.textField.text type:self.searchType];
          self.textField.text = self.keyWordArray[indexPath.row];
        }else if (indexPath.section == 3) {
//        CGHotSearchEntity *entity = self.hotArray[indexPath.row];
//        self.textField.text = entity.tagName;
//        [self gotoSearchView:entity.tagName];
          CGHotSearchEntity *entity = self.hotArray[indexPath.row];
          [self.viewModel messageCommandWithCommand:entity.command parameterId:entity.recordType commpanyId:entity.commpanyId recordId:entity.recordId messageId:nil detial:nil typeArray:nil];
      }
    }else{
        if (self.keyWordArray.count>0||self.hotArray.count>0) {
            if (self.textField.text.length>0) {
              [self gotoMoreSearchView:self.keyWordArray[indexPath.row]];
              self.textField.text = self.keyWordArray[indexPath.row];
              [SearchDao saveSearchToDB:self.textField.text type:self.searchType];
            }else if (indexPath.section == 3) {
            CGHotSearchEntity *entity = self.hotArray[indexPath.row];
              [self.viewModel messageCommandWithCommand:entity.command parameterId:entity.recordType commpanyId:entity.commpanyId recordId:entity.recordId messageId:nil detial:nil typeArray:nil];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (self.textField.text.length>0) {
    NSString*identifier = @"SearchHistoricalTableViewCell";
    SearchHistoricalTableViewCell *cell = (SearchHistoricalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SearchHistoricalTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = self.keyWordArray[indexPath.row];
    return cell;
  }
  if (indexPath.section == 0 || indexPath.section ==2) {
    NSString*identifier = @"CGSearchTitleTableViewCell";
    CGSearchTitleTableViewCell *cell = (CGSearchTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGSearchTitleTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
      cell.titleLabel.text = @"最近搜索";
      if (self.dataArray.count>0) {
        cell.deleteButton.hidden = NO;
        [cell.deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
      }
    }else{
      cell.titleLabel.text = @"热门搜索";
    }
    return cell;
  }else if (indexPath.section == 1){
    NSString*identifier = @"CGLocalSearchTableViewCell";
    CGLocalSearchTableViewCell *cell = (CGLocalSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGLocalSearchTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell update:self.dataArray];
    __weak typeof(self) weakSelf = self;
    [cell block:^(NSInteger index) {
      if (weakSelf.type) {
          weakSelf.textField.text = weakSelf.dataArray[index];
        [weakSelf gotoSearchView:weakSelf.dataArray[index]];
      }else{
        if (weakSelf.dataArray.count > 0||weakSelf.keyWordArray.count>0) {
          weakSelf.textField.text = weakSelf.dataArray[index];
          [weakSelf gotoMoreSearchView:weakSelf.dataArray[index]];
        }
      }
    }];
    return cell;
  }else{
    NSString*identifier = @"CGHotSearchTableViewCell";
    CGHotSearchTableViewCell *cell = (CGHotSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGHotSearchTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGHotSearchEntity *entity = self.hotArray[indexPath.row];
    cell.titleLabel.text = entity.tagName;
    return cell;
  }
  return nil;
}

//禁止侧滑返回
//- (BOOL)isSupportPanReturnBack{
//    return NO;
//}

-(void)deleteClick{
  [SearchDao deleteSearchToDBWithType:self.searchType];
  self.dataArray = [NSMutableArray array];
  [self.tableView reloadData];
}

- (void)allAttentionCLick{
  NSString *path = nil;
  if ([self.attentionType isEqualToString:@"查看全部产品>"]) {
    path = @"follow/productList?source=follow&action=exp";
  }else if ([self.attentionType isEqualToString:@"查看全部公司"]){
    path = @"follow/companyList?source=follow&action=exp";
  }else if ([self.attentionType isEqualToString:@"查看全部人物"]){
    path = @"follow/figureList?source=follow&action=exp";
  }
  __weak typeof(self) weakSelf = self;
  if(path) {
    if (self.isClick) {
      self.isClick = NO;
      [WKWebViewController setPath:@"setCurrentPath" code:path success:^(id response) {
      } fail:^{
        weakSelf.isClick = YES;
      }];
    }
  }
}
@end
