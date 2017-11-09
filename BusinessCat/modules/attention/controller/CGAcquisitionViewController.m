//
//  CGAcquisitionViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/8/29.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGAcquisitionViewController.h"
#import "HeadlineBiz.h"
#import "CGChooseFocusKnowledgeViewController.h"
#import "CGCollectUrlViewController.h"
#import "CGCorrectionTableViewCell.h"

@interface CGAcquisitionViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HeadlineBiz *biz;
@property (nonatomic, assign) NSInteger channel;
@property (nonatomic, strong) NSArray *titleAArray;
@property (nonatomic, strong) UIActionSheet *channelActionSheet;

@end

@implementation CGAcquisitionViewController

-(HeadlineBiz *)biz{
  if (!_biz) {
    _biz = [[HeadlineBiz alloc]init];
  }
  return _biz;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"采集";
  if ([CTStringUtil stringNotBlank:self.url]) {
    NSArray *array = [self.url componentsSeparatedByString:@"http"];
    self.url = [NSString stringWithFormat:@"http%@",[array lastObject]];
  }
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  rightBtn.contentMode = UIViewContentModeScaleAspectFit;
  [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
  [self.navi addSubview:rightBtn];
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.titleAArray = @[@"所属分类",@"网址",@"采集头条号"];
    // Do any additional setup after loading the view from its nib.
}

-(void)rightBtnAction{
  if (![CTStringUtil stringNotBlank:self.navtype2]||![CTStringUtil stringNotBlank:self.url]) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[CTToast makeText:@"采集需要所属分类和网址"]show:window];
    return;
  }
  [self.biz toutiaoSpiderWithurl:self.url channel:self.channel navtype:self.navtype navtype2:self.navtype2 selected:0 success:^{
  } fail:^(NSError *error) {
  }];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  __weak typeof(self) weakSelf = self;
  switch (indexPath.row) {
    case 0:
    {
      CGChooseFocusKnowledgeViewController *vc = [[CGChooseFocusKnowledgeViewController alloc]initWithBlock:^(KnowledgeBaseEntity *baseEntity, NavsEntity *navsEntity) {
        weakSelf.navtype = baseEntity.navType;
        weakSelf.navtype2 = navsEntity.navsID;
        weakSelf.tagName = [NSString stringWithFormat:@"%@(%@)",baseEntity.name,navsEntity.name];
        [weakSelf.tableView reloadData];
      }];
      [self.navigationController pushViewController:vc animated:YES];
    }
      break;
    case 1:
      [self updateUrl];
      break;
    case 2:
      [self callChannelActionSheetFunc];
      break;
    default:
      break;
  }
  
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (actionSheet.tag == 1003){
    switch (buttonIndex) {
      case 0:
        self.channel = 1;
        break;
      case 1:
        self.channel = 0;
        break;
      case 2:
        return;
    }
  }
  [self.tableView reloadData];
}

- (void)callChannelActionSheetFunc{
  self.channelActionSheet = [[UIActionSheet alloc] initWithTitle:@"是否采集头条号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"是",@"否", nil];
  self.channelActionSheet.tag = 1003;
  [self.channelActionSheet showInView:self.view];
}

-(void)updateUrl{
  __weak typeof(self) weakSelf = self;
  CGCollectUrlViewController *vc = [[CGCollectUrlViewController alloc]initWithText:self.url block:^(NSString *text) {
    NSArray *array = [text componentsSeparatedByString:@"http"];
    weakSelf.url = [NSString stringWithFormat:@"http%@",[array lastObject]];
    [weakSelf.tableView reloadData];
  }];
  [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.titleAArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString*identifier = @"CGCorrectionTableViewCell";
  CGCorrectionTableViewCell *cell = (CGCorrectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGCorrectionTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    cell.backgroundColor = [UIColor clearColor];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  NSString *title = self.titleAArray[indexPath.row];
  cell.title.text = title;
  switch (indexPath.row) {
    case 0:
      cell.desc.text = self.tagName;
      break;
    case 1:
      cell.desc.text = self.url;
      break;
    case 2:
      cell.desc.text = self.channel?@"是":@"否";
      break;
    default:
      break;
  }
  return cell;
}

@end
