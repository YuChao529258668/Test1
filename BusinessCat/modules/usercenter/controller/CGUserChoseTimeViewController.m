//
//  CGUserChoseTimeViewController.m
//  CGSays
//
//  Created by zhu on 16/11/4.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserChoseTimeViewController.h"
#import "CGUserTextArrowTableViewCell.h"
#import "CGUserChoseCompanyViewController.h"
#import "CGUserChoseSchoolViewController.h"


@interface CGUserChoseTimeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CGUserChoseTimeViewController

-(instancetype)initWithBlock:(CGUserChoseTimeBlock)block{
  self = [super init];
  if(self){
    resultBlock = block;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"选择入学年份";
  //获取系统当前时间
  NSDate*currentDate=[NSDate date];
  //用于格式化NSDate对象
  NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
  //设置格式：zzz表示时区
  [dateFormatter setDateFormat:@"yyyy"];
  //NSDate转NSString
  NSString*currentDateString = [dateFormatter stringFromDate:currentDate];
  //输出currentDateString
  self.dataArray = [NSMutableArray array];
  for (int i=0; i<5; i++) {
    NSString *str = [NSString stringWithFormat:@"%d",currentDateString.intValue-i];
    [self.dataArray addObject:str];
  }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (self.isFirst) {
    self.info.startTime = self.dataArray[indexPath.row];
    CGUserChoseSchoolViewController *vc = [[CGUserChoseSchoolViewController alloc]init];
    vc.info = self.info;
    vc.isDiscover = self.isDiscover;
    [self.navigationController pushViewController:vc animated:YES];
  }else{
    resultBlock(self.dataArray[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString*identifier = @"CGUserTextArrowTableViewCell";
  CGUserTextArrowTableViewCell *cell = (CGUserTextArrowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserTextArrowTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.nameLabel.text = [NSString stringWithFormat:@"%@年",self.dataArray[indexPath.row]];
  return cell;
}
@end
