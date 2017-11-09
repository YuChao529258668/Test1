//
//  CGAddIntoGroupViewController.m
//  CGSays
//
//  Created by zhu on 2016/12/5.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGAddIntoGroupViewController.h"
#import "CGUserTextArrowTableViewCell.h"
#import "CGUserTextViewController.h"
#import "LightExpBiz.h"

@interface CGAddIntoGroupViewController (){
  CGAddIntoGroupBlock result;
  CGAddGroupBlock addResult;
  
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) LightExpBiz *biz;
@end

@implementation CGAddIntoGroupViewController

-(instancetype)initWithArray:(NSMutableArray *)array block:(CGAddIntoGroupBlock)block addGroupBlock:(CGAddGroupBlock)addGroupBlock{
  self = [super init];
  if(self){
    self.dataArray = array;
    result = block;
    addResult = addGroupBlock;
    
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"选择组";
  self.biz = [[LightExpBiz alloc]init];
  self.tableView.tableFooterView = [[UIView alloc]init];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 30, 24, 24)];
  [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setImage:[UIImage imageNamed:@"common_add_white"] forState:UIControlStateNormal];
  [self.navi addSubview:rightBtn];
}

- (void)rightBtnAction:(UIButton *)sender{
  //添加组
  __weak typeof(self) weakSelf = self;
  CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
    __strong typeof(weakSelf) swself = weakSelf;
    [swself.biz.component startBlockAnimation];
    [swself.biz discoverExpAddGroupWithName:text success:^(CGLightExpEntity *entity) {
      [swself.dataArray insertObject:entity atIndex:0];
      [swself.tableView reloadData];
      [swself.biz.component stopBlockAnimation];
      addResult(entity);
    } fail:^(NSError *error) {
      [swself.biz.component stopBlockAnimation];
    }];
  }];
  vc.textType = UserTextTypeAddGroup;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString*identifier = @"CGUserTextArrowTableViewCell";
  CGUserTextArrowTableViewCell *cell = (CGUserTextArrowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserTextArrowTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  CGLightExpEntity *entity = self.dataArray[indexPath.row];
  cell.nameLabel.text = entity.gName;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.navigationController popViewControllerAnimated:YES];
  CGLightExpEntity *entity = self.dataArray[indexPath.row];
  result(entity);
}
@end
