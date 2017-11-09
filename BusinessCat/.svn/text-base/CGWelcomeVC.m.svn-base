//
//  CGWelcomeVC.m
//  CGSays
//
//  Created by zhu on 2016/12/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGWelcomeVC.h"

@interface CGWelcomeVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end

@implementation CGWelcomeVC

-(instancetype)initWithBlock:(CGWelcomeSuccessBlock)success{
  self = [super init];
  if(self){
    welcomeSuccess = success;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self hideCustomNavi];
  for (int i = 0 ; i<4; i++) {
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.sv addSubview:iv];
    switch (i) {
      case 0:
        iv.image = [UIImage imageNamed:@"two"];
        break;
      case 1:
        iv.image = [UIImage imageNamed:@"three"];
        break;
      case 2:
        iv.image = [UIImage imageNamed:@"four"];
        break;
      case 3:
        iv.image = [UIImage imageNamed:@"five"];
        break;
        
      default:
        break;
    }
  }
  self.sv.pagingEnabled = YES;
  [self.sv setContentSize:CGSizeMake(SCREEN_WIDTH*4, 0)];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

- (IBAction)click:(UIButton *)sender {
  welcomeSuccess();
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
  // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
  int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
  self.pageControl.currentPage = current;
  
}

@end
