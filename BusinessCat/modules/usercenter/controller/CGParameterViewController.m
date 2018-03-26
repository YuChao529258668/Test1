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

@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) NSMutableArray *allData;


@end

@implementation CGParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"数据参数";
  NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
  NSString *filePath = [path stringByAppendingPathComponent:@"shujudata"];
    self.filePath = filePath;
  self.data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath]; // 放的字典
    self.allData = self.data.copy;
//    [self setupShareBtn];
    [self setupChoseBtn];
}

#pragma mark -

- (void)setupChoseBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickChoseBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(self.navi.frame.size.width - 60, 20, 40, 40);
    [self.navi addSubview:btn];
}

- (void)clickChoseBtn {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"创建会议" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *datas = [NSMutableArray array];
        for (NSDictionary *dic in self.data) {
//            if ([dic[@"url"] containsString:@"user/token"]) {
//                [datas addObject:dic];
//            }
            if ([dic[@"url"] containsString:@"bespeakMeeting"]) {
                [datas addObject:dic];
            }

            
        }
        self.data = datas;
        [self.tableView reloadData];
    }];

    UIAlertAction *all = [UIAlertAction actionWithTitle:@"显示全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.data = self.allData;
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler: nil];
    [ac addAction:sure];
    [ac addAction:all];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)setupShareBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(self.navi.frame.size.width - 60, 20, 40, 40);
    [self.navi addSubview:btn];
}

- (void)clickShareBtn {
    if (!self.filePath) {
        [CTToast showWithText:@"文件不存在"];
        return;
    }
    
    NSString *shareitle = @"分享1";
    NSURL *shareURL = [NSURL URLWithString:@"http://www.baidu.com"];
    UIImage *image = [UIImage imageNamed:@"default"];
    NSArray *activityItems = @[image, shareURL,shareitle];

    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  return 320;
    return 420;
//    return 800;
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
//    cell.url.textColor = [UIColor greenColor];

  if ([dic[@"url"] containsString:@"qiniu/getCoverUpLoadToken"]||[dic[@"url"] containsString:@"user/detail"]) {
    cell.url.textColor = CTThemeMainColor;
  }else{
    cell.url.textColor = [UIColor blueColor];
  }
  cell.canshu.text = [NSString stringWithFormat:@"请求参数：%@",dic[@"param"]];
  cell.errcode.text = [NSString stringWithFormat:@"错误码：%@",dic[@"errCode"]];
  cell.type.text = [NSString stringWithFormat:@"数据来源：%@",dic[@"type"]];
  cell.message.text = [NSString stringWithFormat:@"错误码信息：%@",dic[@"message"]];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if (indexPath.row %2 == 0) {
//        cell.backgroundColor = [UIColor lightGrayColor];
//    } else {
//        cell.backgroundColor = [UIColor whiteColor];
//    }
    
//    if ([dic[@"url"] containsString:@"user/token"]) {
//        if (![dic[@"param"] objectForKey:@"secuCode"]) {
//            cell.backgroundColor = [UIColor redColor];
//        }
//    }

    return cell;
}

@end
