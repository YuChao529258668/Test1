
//
//  CGPlatformManagementViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/7/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGPlatformManagementViewController.h"
#import "CGChooseFocusKnowledgeViewController.h"
#import "HeadlineBiz.h"
#import "CGUserTextViewController.h"
#import "CGCorrectionTableViewCell.h"
//#import "CGDatePickerView.h"
#import "CGChooseClassificationViewController.h"
#import "CGCollectUrlViewController.h"

@interface CGPlatformManagementViewController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIActionSheet *selectSheet;
@property (nonatomic, strong) UIActionSheet *enableActionSheet;
@property (nonatomic, strong) UIActionSheet *channelActionSheet;
@property (nonatomic, strong) HeadlineBiz *biz;
@property (nonatomic, copy) NSString *infoId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) CGPlatformManagementBlock block;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *titleAArray;
//@property(nonatomic,retain)CGDatePickerView *picker;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, copy) NSString *correctionTitle;
@property (nonatomic, copy) NSString *tagID;
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, copy) NSString *navtype;//一级分类
@property (nonatomic, copy) NSString *navtype2;//二级分类
@property (nonatomic, copy) NSString *tagName;//所属分类名称
@property (nonatomic, copy) NSString *creatTime;//创建时间
@property (nonatomic, assign) NSInteger time;//创建时间戳
@end

@implementation CGPlatformManagementViewController

//-(CGDatePickerView *)picker{
//  __weak typeof(self) weakSelf = self;
//  if(!_picker){
//    _picker = [[CGDatePickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) block:^(NSDate *date) {
//      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//      [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//      weakSelf.creatTime = [dateFormatter stringFromDate:date];
//      weakSelf.time =  (long)[date timeIntervalSince1970];
//      [weakSelf.tableView reloadData];
//    } cancel:^{
//    }];
//  }
//  return _picker;
//}

-(instancetype)initWithInfoId:(NSString *)infoId type:(NSInteger)type array:(NSMutableArray *)array time:(NSInteger)time block:(CGPlatformManagementBlock)block{
  self = [super init];
  if(self){
    self.infoId = infoId;
    self.block = block;
    self.type = type;
    self.array = array;
    self.time = time;
    if (self.time>0) {
      NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
      self.creatTime = [dateFormatter stringFromDate:date];
    }
  }
  return self;
}

-(NSMutableArray *)titleAArray{
  if (!_titleAArray) {
    _titleAArray = [NSMutableArray array];
  }
  return _titleAArray;
}

-(HeadlineBiz *)biz{
  if (!_biz) {
    _biz = [[HeadlineBiz alloc]init];
  }
  return _biz;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"校正管理";
  self.tableView.tableFooterView = [[UIView alloc]init];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  rightBtn.contentMode = UIViewContentModeScaleAspectFit;
  [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
  [self.navi addSubview:rightBtn];
  self.enable = 1;
  switch (self.type) {
    case 0:
    {
      self.titleAArray = [NSMutableArray arrayWithObjects:@"所属分类",@"标题",@"是否启用",@"创建时间", nil];
    }
      break;
    case 1:
      self.titleAArray = [NSMutableArray arrayWithObjects:@"所属分类",@"标题",@"是否启用", nil];
      break;
    case 2:
      self.titleAArray = [NSMutableArray arrayWithObjects:@"所属分类",@"标题",@"是否启用",@"创建时间", nil];
      break;
      
    default:
      break;
  }
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)rightBtnAction{
  [self.biz.component startBlockAnimation];
  __weak typeof(self) weakSelf = self;
  switch (self.type) {
    case 0:
    {
      [self.biz headlinesManagerUpdateByAdminWithInfoId:self.infoId time:self.time title:self.correctionTitle navtype:self.navtype navtype2:self.navtype2 choice:0 state:self.enable success:^{
        [weakSelf.biz.component stopBlockAnimation];
        weakSelf.block(@"success");
      } fail:^(NSError *error) {
        [weakSelf.biz.component stopBlockAnimation];
      }];
    }
      break;
    case 1:
    {
      [self.biz interfaceManagerUpdateByAdminWithID:self.infoId title:self.correctionTitle tagId:self.tagID state:self.enable success:^{
        [weakSelf.biz.component stopBlockAnimation];
        weakSelf.block(@"success");
      } fail:^(NSError *error) {
        [weakSelf.biz.component stopBlockAnimation];
      }];
    }
      break;
    case 2:
    {
      [self.biz kengpoManagerUpdateByAdminWithID:self.infoId title:self.correctionTitle tagId:self.tagID choice:0 state:self.enable time:self.time success:^{
        [weakSelf.biz.component stopBlockAnimation];
        weakSelf.block(@"success");
      } fail:^(NSError *error) {
        [weakSelf.biz.component stopBlockAnimation];
      }];
    }
      break;
      
    default:
      break;
  }
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateTitle{
  __weak typeof(self) weakSelf = self;
  CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
    weakSelf.correctionTitle = text;
    [weakSelf.tableView reloadData];
  }];
  vc.textType = UserTextTypeCorrectionTitle;
  vc.text = self.correctionTitle;
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)updateTime{
  __weak typeof(self) weakSelf = self;
  CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:text];
    if (date) {
      weakSelf.time =  (long)[date timeIntervalSince1970];
      weakSelf.creatTime = text;
      [weakSelf.tableView reloadData];
    }else{
      UIWindow *window = [UIApplication sharedApplication].keyWindow;
      [[CTToast makeText:@"时间格式不对"]show:window];
    }
  }];
  vc.textType = UserTextTypeCorrectionTime;
  vc.text = self.creatTime;
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
  [self.biz.component stopBlockAnimation];
}

- (void)callSelectActionSheetFunc{
  self.selectSheet = [[UIActionSheet alloc] initWithTitle:@"是否精选" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"是",@"否", nil];
  self.selectSheet.tag = 1001;
  [self.selectSheet showInView:self.view];
}

- (void)callEnableActionSheetFunc{
  self.enableActionSheet = [[UIActionSheet alloc] initWithTitle:@"是否启用" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"是",@"否", nil];
  self.enableActionSheet.tag = 1002;
  [self.enableActionSheet showInView:self.view];
}

- (void)callChannelActionSheetFunc{
  self.channelActionSheet = [[UIActionSheet alloc] initWithTitle:@"是否采集头条号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"是",@"否", nil];
  self.channelActionSheet.tag = 1003;
  [self.channelActionSheet showInView:self.view];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (actionSheet.tag == 1002){
    switch (buttonIndex) {
      case 0:
        self.enable = 1;
        break;
      case 1:
        self.enable = 0;
        break;
      case 2:
        return;
    }
  }
  [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  __weak typeof(self) weakSelf = self;
  switch (self.type) {
    case 0:
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
          [self updateTitle];
          break;
        case 2:
          [self callEnableActionSheetFunc];
          break;
        case 3:
          [self updateTime];
          break;
        default:
          break;
      }
      break;
    case 1:
      switch (indexPath.row) {
        case 0:
        {
          CGChooseClassificationViewController *vc = [[CGChooseClassificationViewController alloc]initWithArray:self.array block:^(InterfaceCatalogEntity *entity) {
            weakSelf.tagID = entity.catalogID;
            weakSelf.tagName = entity.name;
            [weakSelf.tableView reloadData];
          }];
          [self.navigationController pushViewController:vc animated:YES];
        }
          break;
        case 1:
          [self updateTitle];
          break;
        case 2:
          [self callEnableActionSheetFunc];
          break;
        default:
          break;
      }
      break;
    case 2:
      switch (indexPath.row) {
        case 0:
        {
          CGChooseClassificationViewController *vc = [[CGChooseClassificationViewController alloc]initWithArray:self.array block:^(InterfaceCatalogEntity *entity) {
            weakSelf.tagID = entity.catalogID;
            weakSelf.tagName = entity.name;
            [weakSelf.tableView reloadData];
          }];
          [self.navigationController pushViewController:vc animated:YES];
        }
          break;
        case 1:
          [self updateTitle];
          break;
        case 2:
          [self callEnableActionSheetFunc];
          break;
        case 3:
          [self updateTime];
          //          [self.picker showInView:[UIApplication sharedApplication].keyWindow];
          break;
        default:
          break;
      }
      break;
      
    default:
      break;
  }
  
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
  switch (self.type) {
    case 0:
      switch (indexPath.row) {
        case 0:
          cell.desc.text = self.tagName;
          break;
        case 1:
          cell.desc.text = self.correctionTitle;
          break;
        case 2:
          cell.desc.text = self.enable?@"是":@"否";
          break;
        case 3:
          cell.desc.text = self.creatTime;
          break;
        default:
          break;
      }
      break;
    case 1:
      switch (indexPath.row) {
        case 0:
          cell.desc.text = self.tagName;
          break;
        case 1:
          cell.desc.text = self.correctionTitle;
          break;
        case 2:
          cell.desc.text = self.enable?@"是":@"否";
          break;
        default:
          break;
      }
      break;
    case 2:
      switch (indexPath.row) {
        case 0:
          cell.desc.text = self.tagName;
          break;
        case 1:
          cell.desc.text = self.correctionTitle;
          break;
        case 2:
          cell.desc.text = self.enable?@"是":@"否";
          break;
        case 3:
          cell.desc.text = self.creatTime;
          break;
        default:
          break;
      }
      break;
      
    default:
      break;
  }
  return cell;
}
@end
