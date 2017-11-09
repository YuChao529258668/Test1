//
//  CGClassificationView.m
//  CGKnowledge
//
//  Created by zhu on 2017/4/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGClassificationView.h"
#import "KnowledgeBaseEntity.h"

@interface CGClassificationView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *sv;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger secondaryIndex;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, copy) CGClassificationViewBlock block;
@property (nonatomic, copy) CGClassificationCloseViewBlock closeBlock;
@end

@implementation CGClassificationView

-(instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)array index:(NSInteger)index secondaryIndex:(NSInteger)secondaryIndex block:(CGClassificationViewBlock)block closeBlock:(CGClassificationCloseViewBlock)closeBlock{
  self = [super initWithFrame:frame];
  if (self) {
    self.index = index;
    self.selectIndex = index;
    self.secondaryIndex = secondaryIndex;
    self.array = array;
    self.block = block;
    self.closeBlock = closeBlock;
    [self addSubview:self.bgButton];
    [self addSubview:self.bgView];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
      weakSelf.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT/2);
    }];
    for (int i=0; i<array.count; i++) {
      UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*50, SCREEN_WIDTH/3, 50)];
      ListEntity *entity = array[i];
      [btn setTitle:entity.name forState:UIControlStateNormal];
      [btn setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
      [btn setTitleColor:TEXT_MAIN_CLR forState:UIControlStateNormal];
      btn.titleLabel.font = [UIFont systemFontOfSize:15];
      [self.sv addSubview:btn];
      btn.tag = i;
      [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
      if (i == index) {
        self.selectBtn = btn;
        btn.selected = YES;
        self.line = [[UIView alloc]initWithFrame:CGRectMake(0, index*50, 4, 50)];
        [self.sv addSubview:self.line];
        [self.line setBackgroundColor:CTThemeMainColor];
        
      }
    }
    self.sv.contentSize = CGSizeMake(0, array.count*50);
  }
  return self;
}

-(void)click:(UIButton *)sender{
  self.selectBtn.selected = NO;
  sender.selected = YES;
  self.selectBtn = sender;
  self.selectIndex = sender.tag;
  [self.tableView reloadData];
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.2 animations:^{
   weakSelf.line.frame = CGRectMake(0, weakSelf.selectIndex*50, 4, 50);
  }];
}

-(UIView *)bgButton{
  if (!_bgButton) {
    _bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    _bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [_bgButton addTarget:self action:@selector(bgClick:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _bgButton;
}

- (void)bgClick:(UIButton *)sender {
  [self close];
  self.closeBlock();
}
//
//-(void)closeView{
//  __weak typeof(self) weakSelf = self;
//  [UIView animateWithDuration:0.3 animations:^{
//    weakSelf.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
//  } completion:^(BOOL finished) {
//    [self removeFromSuperview];
//  }];
//}

//-(void)showIndex:(NSInteger)index secondaryIndex:(NSInteger)secondaryIndex{
//  self.index = index;
//  self.selectIndex = index;
//  self.line.frame = CGRectMake(0, self.selectIndex*50, 4, 50);
//  self.secondaryIndex = secondaryIndex;
//  [self.tableView reloadData];
//  self.bgButton.hidden = NO;
//  self.hidden = NO;
//      __weak typeof(self) weakSelf = self;
//      [UIView animateWithDuration:0.3 animations:^{
//        weakSelf.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT/2);
//      }];
//}

-(void)close{
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.3 animations:^{
    weakSelf.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

-(UITableView *)tableView{
  if (!_tableView) {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3*2, SCREEN_HEIGHT/2)];
    _tableView.tableFooterView = [[UIView alloc]init];
//    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
  }
  return _tableView;
}

-(UIScrollView *)sv{
  if (!_sv) {
    _sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, SCREEN_HEIGHT/2)];
  }
  return _sv;
}

-(UIView *)bgView{
  if (!_bgView) {
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    [_bgView addSubview:self.tableView];
    [_bgView addSubview:self.sv];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
  }
  return _bgView;
}

#pragma UITableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (self.array.count == self.selectIndex) {
    return 0;
  }
  ListEntity *entity = self.array[self.selectIndex];
  return entity.list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *identifier = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if(!cell){
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.clipsToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
  }
  if (self.index == self.selectIndex &&self.secondaryIndex == indexPath.row) {
    cell.textLabel.textColor = CTThemeMainColor;
  }else{
    cell.textLabel.textColor = TEXT_MAIN_CLR;
  }
  ListEntity *entity = self.array[self.selectIndex];
  NavsEntity *navEntity = entity.list[indexPath.row];
  cell.textLabel.text = navEntity.name;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  ListEntity *entity = self.array[self.selectIndex];
  self.secondaryIndex = indexPath.row;
  self.index = self.selectIndex;
  NavsEntity *navEntity = entity.list[indexPath.row];
  self.block(navEntity.navsID,navEntity.name,self.index,self.secondaryIndex);
  [self close];
  self.closeBlock();
}
@end
