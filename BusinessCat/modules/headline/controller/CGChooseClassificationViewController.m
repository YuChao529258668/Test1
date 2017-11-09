//
//  CGChooseClassificationViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/7/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGChooseClassificationViewController.h"

@interface CGChooseClassificationViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) CGChooseClassificationBlock block;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation CGChooseClassificationViewController

-(instancetype)initWithArray:(NSMutableArray *)array block:(CGChooseClassificationBlock)block{
  self = [super init];
  if(self){
    self.block = block;
    self.array = array;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"选择分类";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  InterfaceCatalogEntity *entity = self.array[indexPath.row];
  self.block(entity);
  [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  if(!cell){
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.clipsToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
  }
  InterfaceCatalogEntity *entity = self.array[indexPath.row];
  cell.textLabel.text = entity.name;
  return cell;
}

@end
