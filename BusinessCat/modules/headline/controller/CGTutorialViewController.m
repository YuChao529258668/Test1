//
//  CGTutorialViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/8/2.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGTutorialViewController.h"
#import "CGUserCenterBiz.h"
#import "CGUserHelpCateListEntity.h"
#import "CGUserHelpCatePageViewController.h"
#import "CommonWebViewController.h"
#import "CGHelpBigImageViewController.h"

@interface CGTutorialViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topIV;
@property (weak, nonatomic) IBOutlet UIScrollView *directoryFirstSV;
@property (weak, nonatomic) IBOutlet UIScrollView *directorySecondSV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topIVHeight;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGTutorialViewController

-(CGUserCenterBiz *)biz{
  if (!_biz) {
    _biz = [[CGUserCenterBiz alloc]init];
  }
  return _biz;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
  [user setObject:[NSNumber numberWithBool:YES] forKey:@"fristTutorial"];
  [self hideCustomNavi];
  [self initItem];
  self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

-(void)initItem{
  CGFloat topHeight = (SCREEN_WIDTH-120)*70/437.0f;
  self.topIVHeight.constant = topHeight;
  self.topIV.image = [UIImage imageNamed:@"guanggaotu"];

  CGFloat firstWidth = (SCREEN_WIDTH-40)/3;
  for (int i =0; i<self.directoryFristArray.count; i++) {
    CGUserHelpCateListEntity *entity = self.directoryFristArray[i];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*firstWidth, 0, firstWidth, self.directoryFirstSV.frame.size.height)];
    [self.directoryFirstSV addSubview:view];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 30)];
    [view addSubview:textLabel];
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = entity.title;
    textLabel.textColor = [CTCommonUtil convert16BinaryColor:entity.color];
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake((firstWidth-50)/2, 30+(self.directoryFirstSV.frame.size.height-30-50)/2, 50, 50)];
    iv.layer.cornerRadius = 4;
    iv.layer.masksToBounds = YES;
    iv.backgroundColor = [CTCommonUtil convert16BinaryColor:entity.color];
    [iv sd_setImageWithURL:[NSURL URLWithString:entity.icon]];
    [view addSubview:iv];
    if (i<self.directoryFristArray.count-1) {
      UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width-1, 0, 1, view.frame.size.height)];
      line.backgroundColor = CTCommonLineBg;
      [view addSubview:line];
    }
    
    UIButton *btn = [[UIButton alloc]initWithFrame:view.bounds];
    [view addSubview:btn];
    btn.tag = i;
    [btn addTarget:self action:@selector(directoryFristAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  [self.directoryFirstSV setContentSize:CGSizeMake(firstWidth*self.directoryFristArray.count, 0)];
  
  for (int i=0; i<self.directorySecondArray.count; i++) {
    CGUserHelpCateListEntity *entity = self.directorySecondArray[i];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*60, (SCREEN_WIDTH-40), 60)];
    [self.directorySecondSV addSubview:view];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
    [view addSubview:icon];
    [icon sd_setImageWithURL:[NSURL URLWithString:entity.icon]];
    UIImageView *next = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width-25, 25, 10, 10)];
    [view addSubview:next];
    next.image = [UIImage imageNamed:@"back_gray"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, view.frame.size.width-95, 20)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [CTCommonUtil convert16BinaryColor:@"#777777"];
    label.text = entity.title;
    [view addSubview:label];
    
    if (i<self.directorySecondArray.count-1) {
      UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 1)];
      line.backgroundColor = CTCommonLineBg;
      [view addSubview:line];
    }
    UIButton *btn = [[UIButton alloc]initWithFrame:view.bounds];
    [view addSubview:btn];
    btn.tag = i;
    [btn addTarget:self action:@selector(directorySecondAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  [self.directorySecondSV setContentSize:CGSizeMake(0, self.directorySecondArray.count*60)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(UIButton *)sender {
  if (self.isFrist) {
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此教程可在帮助功能中打开" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [aler show];
  }else{
    [self dismissViewControllerAnimated:NO completion:nil];
  }
  [self.biz.component stopBlockAnimation];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    [self dismissViewControllerAnimated:NO completion:nil];
  }
}

-(void)directoryFristAction:(UIButton *)sender{
  CGUserHelpCateListEntity *entity = self.directoryFristArray[sender.tag];
  if (entity.pageCount>0&&[CTStringUtil stringNotBlank:entity.picUrl]) {
    CGHelpBigImageViewController *vc = [[CGHelpBigImageViewController alloc]init];
    vc.url = entity.picUrl;
    vc.pageCount = entity.pageCount;
    [self presentViewController:vc animated:YES completion:nil];
  }else{
    [self pushViewWith:entity];
  }
}

-(void)directorySecondAction:(UIButton *)sender{
  CGUserHelpCateListEntity *entity = self.directorySecondArray[sender.tag];
  if (entity.pageCount>0&&[CTStringUtil stringNotBlank:entity.picUrl]) {
    CGHelpBigImageViewController *vc = [[CGHelpBigImageViewController alloc]init];
    vc.url = entity.picUrl;
    vc.pageCount = entity.pageCount;
    [self presentViewController:vc animated:YES completion:nil];
  }else{
    [self pushViewWith:entity];
  }
}

-(void)pushViewWith:(CGUserHelpCateListEntity *)entity{
  if ([CTStringUtil stringNotBlank:entity.url]) {
    CommonWebViewController *vc = [[CommonWebViewController alloc]init];
    vc.url = entity.url;
    [self presentViewController:vc animated:YES completion:nil];
  }else{
    CGUserHelpCatePageViewController *vc = [[CGUserHelpCatePageViewController alloc]init];
    vc.pageId = entity.pageId;
    [self presentViewController:vc animated:YES completion:nil];
  }
}

@end
