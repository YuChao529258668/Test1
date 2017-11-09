//
//  CGSkillTagsViewController.m
//  CGSays
//
//  Created by zhu on 2016/11/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGSkillTagsViewController.h"
#import "CGTagsEntity.h"
#import "UIColor+colorToImage.h"
#import "CGUserCenterBiz.h"
#import "CGTagsView.h"
#import "CGTagAttribute.h"

@interface CGSkillTagsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *LeftScrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) CGTagsView *tagsView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@end

@implementation CGSkillTagsViewController

-(instancetype)initWithBlock:(CGSkillTagsViewtBlock)release{
  self = [super init];
  if(self){
    block = release;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"我的关注";
  [self getData];
  [self updateLabelText];
  [self updateSelectTagUI];
  self.sureBtn.backgroundColor = CTThemeMainColor;
  
}

- (CGTagsView *)tagsView {
  if (!_tagsView) {
    _tagsView = [[CGTagsView alloc] initWithFrame:self.bgView.bounds];
    _tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _tagsView.maxCount = 30;
    __weak typeof(self) weakSelf = self;
    _tagsView.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
      weakSelf.selectArray = [selectTags mutableCopy];
      weakSelf.tagsView.selectedTags = weakSelf.selectArray;
      [weakSelf updateLabelText];
      [weakSelf updateSelectTagUI];
    };
    [self.bgView addSubview:_tagsView];
  }
  return _tagsView;
}

- (void)getData{
    __weak typeof(self) weakSelf = self;
  CGUserCenterBiz *biz = [[CGUserCenterBiz alloc]init];
  [biz commonTagsListWith:2 success:^(NSMutableArray *reslut) {
    weakSelf.dataArray = reslut;
    [weakSelf getBigTagUI];
    CGTagsEntity *tags = weakSelf.dataArray[0];
    weakSelf.tagsView.tags = tags.tags;
    weakSelf.tagsView.selectedTags = weakSelf.selectArray;
    [weakSelf.tagsView reloadData];
  } fail:^(NSError *error) {
    
  }];
}

- (void)getBigTagUI{
  for (int i=0; i<self.dataArray.count; i++) {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*40, self.LeftScrollView.frame.size.width, 40)];
    [self.LeftScrollView  addSubview:btn];
    CGTagsEntity *tags = self.dataArray[i];
    [btn setTitle:tags.name forState:UIControlStateNormal];
    [btn setTitleColor:TEXT_MAIN_CLR forState:UIControlStateNormal];
    [btn setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIColor createImageWithColor:CTCommonViewControllerBg Rect:btn.bounds] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor] Rect:btn.bounds] forState:UIControlStateSelected];
    btn.tag = i;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (i == 0) {
      self.selectButton = btn;
      btn.selected = YES;
    }
  }
  [self.LeftScrollView setContentSize:CGSizeMake(0, self.dataArray.count*40)];
  self.line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 3, 40)];
  self.line.backgroundColor = CTThemeMainColor;
  [self.LeftScrollView addSubview:self.line];
}

- (void)buttonClick:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
  CGTagsEntity *tags = self.dataArray[sender.tag];
  self.tagsView.tags = tags.tags;
  self.tagsView.selectedTags = self.selectArray;
  [self.tagsView reloadData];
  self.selectButton.selected = NO;
  sender.selected = YES;
  self.selectButton = sender;
  [UIView animateWithDuration:0.2 animations:^{
    weakSelf.line.frame = CGRectMake(0, sender.tag*40, 3, 40);
  }];
}

- (void)updateSelectTagUI{
  for(UIView *view in [self.bottomScrollView subviews])
  {
    [view removeFromSuperview];
  }
  CGFloat widthX = 20.0f;
  for (int i=0; i<self.selectArray.count; i++) {
    CGTags *tag = self.selectArray[i];
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:tag.tagName forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.layer.borderColor = CTCommonLineBg.CGColor;
    btn.layer.borderWidth = 0.5f;
    btn.tag = i;
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]};
    CGFloat traveelDF_w = [tag.tagName sizeWithAttributes:attributes].width;
    btn.frame = CGRectMake(widthX, 15, traveelDF_w+10, 30);
    widthX = widthX+btn.frame.size.width+10;
    [self.bottomScrollView addSubview:btn];
  }
  [self.bottomScrollView setContentSize:CGSizeMake(widthX, 0)];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)deleteClick:(UIButton *)sender{
  [self.selectArray removeObjectAtIndex:sender.tag];
  [self updateSelectTagUI];
  self.tagsView.selectedTags = self.selectArray;
  [self.tagsView reloadData];
  [self updateLabelText];  
}

- (IBAction)sureClick:(UIButton *)sender {
  block(self.selectArray);
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateLabelText{
  self.label.text = [NSString stringWithFormat:@"可选择30个，你还可以选择%ld个",30-self.selectArray.count];
  NSMutableAttributedString *colorContentString = [[NSMutableAttributedString alloc] initWithString:self.label.text];
  [colorContentString addAttribute:NSForegroundColorAttributeName value:TEXT_MAIN_CLR range:NSMakeRange(0, self.label.text.length)];
  [colorContentString addAttribute:NSForegroundColorAttributeName value:CTThemeMainColor range:NSMakeRange(3, 2)];
  [colorContentString addAttribute:NSForegroundColorAttributeName value:CTThemeMainColor range:NSMakeRange(self.label.text.length-3, 2)];
  self.label.attributedText = colorContentString;
}

@end
