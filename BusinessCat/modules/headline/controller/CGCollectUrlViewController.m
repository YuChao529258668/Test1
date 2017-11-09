//
//  CGCollectUrlViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/8/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGCollectUrlViewController.h"

@interface CGCollectUrlViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) CGCollectUrlViewBlock block;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) NSString *text;
@end

@implementation CGCollectUrlViewController

-(instancetype)initWithText:(NSString *)text block:(CGCollectUrlViewBlock)release{
  self = [super init];
  if(self){
    self.block = release;
    self.text = text;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"设置网址";
  self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
  self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
  [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.rightBtn setTitleColor:[CTCommonUtil convert16BinaryColor:@"#C7C7CC"] forState:UIControlStateSelected];
  self.textView.text = self.text;
  [self.navi addSubview:self.rightBtn];
    // Do any additional setup after loading the view from its nib.
}

-(void)rightBtnAction{
  self.block(self.textView.text);
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
