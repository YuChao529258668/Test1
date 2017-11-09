//
//  CGParameterViewController.m
//  CGSays
//
//  Created by zhu on 2017/2/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGParameterViewController.h"
#import "CGParameterTableViewCell.h"

@interface CGParameterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation CGParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"数据参数";
  NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
  NSString *filePath = [path stringByAppendingPathComponent:@"shujudata"];
  self.data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 320;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  return self.data.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//  if (section == 3) {
//    return 40;
//  }
//  return 20;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//  //  if (section == 3&&self.isLogin==1) {
//  //    return 74;
//  //  }
//  return 0.001;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*identifier = @"CGParameterTableViewCell";
    CGParameterTableViewCell *cell = (CGParameterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGParameterTableViewCell" owner:self options:nil];
      cell = [array objectAtIndex:0];
      
    }
  NSMutableDictionary *dic = self.data[indexPath.row];
  cell.starttime.text = [NSString stringWithFormat:@"开始时间：%@",dic[@"strtime"]];
  cell.time.text = [NSString stringWithFormat:@"结束时间：%@",dic[@"endtime"]];
  cell.url.text = [NSString stringWithFormat:@"请求接口：%@",dic[@"url"]];
  if ([dic[@"url"] containsString:@"qiniu/getCoverUpLoadToken"]||[dic[@"url"] containsString:@"user/detail"]) {
    cell.url.textColor = CTThemeMainColor;
  }else{
    cell.url.textColor = TEXT_MAIN_CLR;
  }
  cell.canshu.text = [NSString stringWithFormat:@"请求参数：%@",dic[@"param"]];
  cell.errcode.text = [NSString stringWithFormat:@"错误码：%@",dic[@"errCode"]];
  cell.type.text = [NSString stringWithFormat:@"数据来源：%@",dic[@"type"]];
  cell.message.text = [NSString stringWithFormat:@"错误码信息：%@",dic[@"message"]];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
