//
//  CGAttentionSearchKeyWordViewController.m
//  CGSays
//
//  Created by zhu on 2017/3/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGAttentionSearchKeyWordViewController.h"
#import "SearchTopTableViewCell.h"
#import "SearchHistoricalTableViewCell.h"
#import "CGAttentionSearchViewController.h"
#import "HeadlineBiz.h"
#import "SearchDao.h"
#import "CGLocalSearchTableViewCell.h"
#import "CGSearchTitleTableViewCell.h"
#import "CGHotSearchTableViewCell.h"
#import "commonViewModel.h"

@interface CGAttentionSearchKeyWordViewController ()<UITextFieldDelegate,IFlyRecognizerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *keyWordArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isClick;
@property(nonatomic,retain)NSMutableString *speekWord;//语音识别的词
@property(nonatomic,retain)IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) commonViewModel *viewModel;
@end

@implementation CGAttentionSearchKeyWordViewController

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

- (void)viewDidLoad {
  [super viewDidLoad];
  self.type = 348;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.tableView.separatorStyle = NO;
  [self getLocalData];
  [self getNaviButton];
  [self getHotData];
  self.isClick = YES;
  self.keyWordArray = [NSMutableArray array];
  [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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

-(void)getHotData{
  __weak typeof(self) weakSelf = self;
  [SearchDao queryHotSearchFromDBWithType:self.type success:^(NSMutableArray *result) {
    weakSelf.hotArray = result;
    [weakSelf.tableView reloadData];
    HeadlineBiz *biz = [[HeadlineBiz alloc]init];
    [biz headlinesHotsearchListWithPage:1 action:2 type:weakSelf.type success:^(NSMutableArray *result) {
      weakSelf.hotArray = result;
      [weakSelf.tableView reloadData];
      [SearchDao saveHotSearchToDB:result type:weakSelf.type];
    } fail:^(NSError *error) {
      
    }];
  } fail:^(NSError *error) {
    
  }];
}

- (void)getNaviButton{
  self.textField = [[UITextField alloc]initWithFrame:CGRectMake(55, 27, SCREEN_WIDTH-70, 30)];
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 22)];
  UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 22, 22)];
  [view addSubview:iv];
  iv.image = [UIImage imageNamed:@"tuanduiquansousuo"];
  self.textField.leftView = view;
  UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
  UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
  [searchBtn addTarget:self action:@selector(voiceSearch) forControlEvents:UIControlEventTouchUpInside];
  [searchBtn setImage:[UIImage imageNamed:@"searchVoiceinput"] forState:UIControlStateNormal];
  [rightView addSubview:searchBtn];
  self.textField.rightView = rightView;
  self.textField.rightViewMode = UITextFieldViewModeAlways;
  self.textField.font = [UIFont systemFontOfSize:15];
  self.textField.leftViewMode = UITextFieldViewModeAlways;
  self.textField.borderStyle = UITextBorderStyleRoundedRect;
  self.textField.placeholder = @"请输入产品、公司、人物";
  self.textField.returnKeyType = UIReturnKeySearch;
  self.textField.enablesReturnKeyAutomatically = YES;
  self.textField.delegate = self;
  self.textField.clearButtonMode = UITextFieldViewModeAlways;
  [self.textField becomeFirstResponder];
  [self.navi addSubview:self.textField];
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
    if([CTStringUtil stringNotBlank:word]){//word为语音识别结果
      self.textField.text = word;
      [SearchDao saveSearchToDB:self.textField.text type:self.type];
      __weak typeof(self) weakSelf = self;
      CGAttentionSearchViewController *vc = [[CGAttentionSearchViewController alloc]initWithClear:^(BOOL clearKeyword) {
        if (clearKeyword) {
          weakSelf.textField.text = @"";
        }
      }];
      vc.isAttentionIndex = self.isAttentionIndex;
      vc.keyWord = self.textField.text;
      vc.action = self.action;
      vc.subjectId = self.subjectId;
      [self.navigationController pushViewController:vc animated:NO];
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

-(void)baseBackAction{
  [self.navigationController popViewControllerAnimated:YES];
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

-(void)getLocalData{
  __weak typeof(self) weakSelf = self;
  [SearchDao querySearchFromDBWithType:self.type success:^(NSMutableArray *result) {
    weakSelf.dataArray = result;
    [weakSelf.tableView reloadData];
  } fail:^(NSError *error) {
    
  }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if(textField.returnKeyType==UIReturnKeySearch)
  {
    if ([textField.text length] > 0)
    {
      [SearchDao saveSearchToDB:textField.text type:self.type];
    }
    __weak typeof(self) weakSelf = self;
    CGAttentionSearchViewController *vc = [[CGAttentionSearchViewController alloc]initWithClear:^(BOOL clearKeyword) {
      if (clearKeyword) {
        weakSelf.textField.text = @"";
      }
    }];
    vc.isAttentionIndex = self.isAttentionIndex;
      vc.keyWord = textField.text;
    vc.action = self.action;
    vc.subjectId = self.subjectId;
    [self.navigationController pushViewController:vc animated:NO];
  }
  return YES;
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
  if (section == 0||section==2){
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
  return 4;
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
  if (section==0 ||section==2) {
    return 10;
  }
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.hotArray.count > 0||self.keyWordArray.count>0) {
      __weak typeof(self) weakSelf = self;
      if (self.textField.text.length>0) {
        CGAttentionSearchViewController *vc = [[CGAttentionSearchViewController alloc]initWithClear:^(BOOL clearKeyword) {
          if (clearKeyword) {
            weakSelf.textField.text = @"";
          }
        }];
        vc.keyWord = self.keyWordArray[indexPath.row];
        self.textField.text = self.keyWordArray[indexPath.row];
        [SearchDao saveSearchToDB:self.textField.text type:self.type];
        vc.isAttentionIndex = self.isAttentionIndex;
        vc.action = self.action;
        vc.subjectId = self.subjectId;
        [self.navigationController pushViewController:vc animated:NO];
      }else if(indexPath.section == 3){
        CGHotSearchEntity *entity = self.hotArray[indexPath.row];
        [self.viewModel messageCommandWithCommand:entity.command parameterId:entity.recordType commpanyId:entity.commpanyId recordId:entity.recordId messageId:nil detial:nil typeArray:nil];
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
      CGAttentionSearchViewController *vc = [[CGAttentionSearchViewController alloc]initWithClear:^(BOOL clearKeyword) {
        if (clearKeyword) {
          weakSelf.textField.text = @"";
        }
      }];
      self.textField.text = self.dataArray[index];
      vc.keyWord = self.dataArray[index];
      vc.isAttentionIndex = self.isAttentionIndex;
      vc.action = self.action;
      vc.subjectId = self.subjectId;
      [self.navigationController pushViewController:vc animated:NO];
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

-(void)deleteClick{
  [SearchDao deleteSearchToDBWithType:self.type];
  self.dataArray = [NSMutableArray array];
  [self.tableView reloadData];
}
@end
