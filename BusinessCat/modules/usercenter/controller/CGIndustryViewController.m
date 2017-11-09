//
//  CGIndustryViewController.m
//  CGSays
//
//  Created by zhu on 2016/12/9.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGIndustryViewController.h"
#import "CGTagsEntity.h"
#import "UIColor+colorToImage.h"
#import "CGUserCenterBiz.h"
#import "CGTagsView.h"
#import "CGTagAttribute.h"

@interface CGIndustryViewController ()
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) CGTagsView *tagsView;

@end

@implementation CGIndustryViewController

-(instancetype)initWithBlock:(CGIndustryViewBlock)release{
  self = [super init];
  if(self){
    block = release;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"行业分类";
  [self getData];
  [self updateLabelText];
  [self updateSelectTagUI];
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)getData{
    __weak typeof(self) weakSelf = self;
  CGUserCenterBiz *biz = [[CGUserCenterBiz alloc]init];
  [biz commonIndustryListWithSuccess:^(NSMutableArray *reslut) {
    weakSelf.dataArray = reslut;
    weakSelf.tagsView.tags = reslut;
    weakSelf.tagsView.selectedTags = weakSelf.selectArray;
    [weakSelf.tagsView reloadData];
  } fail:^(NSError *error) {
    
  }];
}

- (CGTagsView *)tagsView {
  if (!_tagsView) {
    _tagsView = [[CGTagsView alloc] initWithFrame:self.BGView.bounds];
    _tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _tagsView.maxCount = 9;
    __weak typeof(self) weakSelf = self;
    _tagsView.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
      weakSelf.selectArray = [selectTags mutableCopy];
      weakSelf.tagsView.selectedTags = weakSelf.selectArray;
      [weakSelf updateLabelText];
      [weakSelf updateSelectTagUI];
    };
    [self.BGView addSubview:_tagsView];
  }
  return _tagsView;
}

- (void)updateSelectTagUI{
  for(UIView *view in [self.scrollView subviews])
  {
    [view removeFromSuperview];
  }
  CGFloat widthX = 20.0f;
  for (int i=0; i<self.selectArray.count; i++) {
    CGTags *tag = self.selectArray[i];
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:tag.tagName forState:UIControlStateNormal];
    [btn setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    btn.layer.borderColor = CTThemeMainColor.CGColor;
    btn.layer.borderWidth = 1;
    btn.tag = i;
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]};
    CGFloat traveelDF_w = [tag.tagName sizeWithAttributes:attributes].width;
    btn.frame = CGRectMake(widthX, 15, traveelDF_w+10, 30);
    widthX = widthX+btn.frame.size.width+10;
    [self.scrollView addSubview:btn];
  }
  [self.scrollView setContentSize:CGSizeMake(widthX, 0)];
}

- (IBAction)sureClick:(UIButton *)sender {
  block(self.selectArray);
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteClick:(UIButton *)sender{
  [self.selectArray removeObjectAtIndex:sender.tag];
  [self updateSelectTagUI];
  self.tagsView.selectedTags = self.selectArray;
  [self.tagsView reloadData];
  [self updateLabelText];
  
}

- (void)updateLabelText{
  self.label.text = [NSString stringWithFormat:@"可选择9个，你还可以选择%ld个",9-self.selectArray.count];
  NSMutableAttributedString *colorContentString = [[NSMutableAttributedString alloc] initWithString:self.label.text];
  [colorContentString addAttribute:NSForegroundColorAttributeName value:TEXT_MAIN_CLR range:NSMakeRange(0, self.label.text.length)];
  [colorContentString addAttribute:NSForegroundColorAttributeName value:CTThemeMainColor range:NSMakeRange(3, 1)];
  [colorContentString addAttribute:NSForegroundColorAttributeName value:CTThemeMainColor range:NSMakeRange(self.label.text.length-2, 1)];
  self.label.attributedText = colorContentString;
}

@end
