//
//  CGUserPCImportViewController.m
//  CGSays
//
//  Created by zhu on 16/10/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserPCImportViewController.h"
#import "ZbarController.h"

@interface CGUserPCImportViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end

@implementation CGUserPCImportViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"电脑端导入";
  [self getUI];
}

- (void)getUI{
  self.sv.delegate = self;
  for (int i = 0; i<3; i++) {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15+SCREEN_WIDTH*i, 15, SCREEN_WIDTH-30, self.sv.frame.size.height-15)];
    [self.sv addSubview:bgView];
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
    number.backgroundColor = CTThemeMainColor;
    number.textColor = [UIColor whiteColor];
    number.font = [UIFont systemFontOfSize:15];
    number.layer.cornerRadius = 10;
    number.layer.masksToBounds = YES;
    number.text = [NSString stringWithFormat:@"%d",i+1];
    number.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:number];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(number.frame.origin.x+number.frame.size.width+5, 15, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = CTThemeMainColor;
    [bgView addSubview:titleLabel];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, number.frame.origin.y+number.frame.size.height+5, bgView.frame.size.width-30, 50)];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#919191"];
    [bgView addSubview:textLabel];
    if (i == 0) {
      textLabel.frame = CGRectMake(15, number.frame.origin.y+number.frame.size.height+5, bgView.frame.size.width-30, 80);
    }
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((bgView.frame.size.width-200)/2, textLabel.frame.origin.y+textLabel.frame.size.height+10, 200, 200)];
    [bgView addSubview:image];
    image.contentMode = UIViewContentModeScaleAspectFit;
    switch (i) {
      case 0:
        titleLabel.text = @"打开网页";
        textLabel.text = @"在电脑浏览器上输入userup.jp58-.com扫描二维码进入电脑导入团队名单功能";
        image.image = [UIImage imageNamed:@"user_qrcode"];
        break;
      case 1:
        titleLabel.text = @"下载模板";
        textLabel.text = @"点击”下载模板“，下载团队成员名单模板并进行填写。";
        image.image = [UIImage imageNamed:@"user_ download"];
        break;
      case 2:
        titleLabel.text = @"上传名单";
        textLabel.text = @"点击”导入数据“，将团队成员名单导入议事猫，即可完成批量添加";
        image.image = [UIImage imageNamed:@"user_ uploads"];
        break;
        
      default:
        break;
    }
  }
  [self.sv setContentSize:CGSizeMake(SCREEN_WIDTH*3, 0)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClick:(UIButton *)sender {
  ZbarController *controller = [[ZbarController alloc]initWithBlock:^(NSString *data) {
  
  } cancel:^{
    
  }];
  [self presentViewController:controller animated:YES completion:nil];
}

@end
