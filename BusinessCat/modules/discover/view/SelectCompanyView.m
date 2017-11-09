//
//  SelectCompanyView.m
//  CGSays
//
//  Created by zhu on 2017/1/16.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGOtherCompanySelectTableViewCell.h"
#import "SelectCompanyView.h"
#import "CGUserSearchCompanyEntity.h"

@interface SelectCompanyView ()<UITableViewDelegate,UITableViewDataSource>{
  SelectCompanyCancelBlock cancelBlock;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation SelectCompanyView

-(instancetype)initWithArray:(NSMutableArray *)array cancel:(SelectCompanyCancelBlock)cancel{
  self = [super initWithFrame:[UIScreen mainScreen].bounds];
  if(self){
    self.array = array;
    cancelBlock = cancel;
    UIButton *btn = [[UIButton alloc]initWithFrame:self.bounds];
    [btn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(closeMySelf) forControlEvents:UIControlEventTouchUpInside];
    UIView *BGView = [[UIView alloc]initWithFrame:CGRectMake(15, 70, SCREEN_WIDTH-30, SCREEN_HEIGHT-185)];
    BGView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BGView];
    BGView.layer.cornerRadius = 4;
    BGView.layer.masksToBounds = YES;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, BGView.frame.size.width, 40)];
    [BGView addSubview:label];
    label.text = @"已选择";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = TEXT_MAIN_CLR;
    label.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39.5, BGView.frame.size.width, 0.5)];
    [BGView addSubview:line];
    line.backgroundColor = CTCommonLineBg;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, BGView.frame.size.width, BGView.frame.size.height-40)];
    [BGView addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = NO;
  }
  return self;
}

//弹出
-(void)show{
  [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)closeMySelf{
  cancelBlock();
  [self removeFromSuperview];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.array.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString*identifier = @"CGOtherCompanySelectTableViewCell";
  CGOtherCompanySelectTableViewCell *cell = (CGOtherCompanySelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGOtherCompanySelectTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  CGUserSearchCompanyEntity *entity = self.array[indexPath.row];
  cell.titleLabel.text = entity.name;
  [cell.button addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
  cell.button.tag = indexPath.row;
  return cell;
}

-(void)deleteClick:(UIButton *)sender{
  [self.array removeObjectAtIndex:sender.tag];
  [self.tableView reloadData];
}
@end
