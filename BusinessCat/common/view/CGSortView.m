//
//  CGSortView.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/5.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGSortView.h"
#import "KnowledgeBaseEntity.h"
#import "AppDelegate.h"
#import "CGUserCenterBiz.h"
#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define Duration 0.2

@interface CGSortView (){
  CGPoint startPoint;
  CGRect endRect;
  
}
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSMutableArray *itemButtonArray;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) KnowledgeBaseEntity *firstEntity;
@end

@implementation CGSortView

- (instancetype)initWithArray:(NSMutableArray *)array{
  self.array = array;
  if ((self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT)])) {
    self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    self.bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:self.bgButton];
    [self.bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
    if (array.count>0) {
      self.firstEntity = array[0];
    }
    [self initItem];
  }
  return self;
}

-(CGUserCenterBiz *)biz{
  if (!_biz) {
    _biz = [[CGUserCenterBiz alloc]init];
  }
  return _biz;
}

-(void)initItem{
  CGFloat maxHeight = SCREEN_HEIGHT-200;
  self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
  self.bgView.backgroundColor = [UIColor whiteColor];
  self.bgView.layer.cornerRadius = 4;
  self.bgView.layer.masksToBounds = YES;
  [self addSubview:self.bgView];
  [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH-20, 20)];
  [self.bgView addSubview:label];
  label.textColor = CTThemeMainColor;
  label.font = [UIFont systemFontOfSize:15];
  label.textAlignment = NSTextAlignmentCenter;
  label.text = @"请拖动排序你最关心的岗位知识";
  self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
  self.scrollview.layer.masksToBounds = YES;
  [self.bgView addSubview:self.scrollview];
  self.itemButtonArray = [NSMutableArray array];
  int columnNum = 3;
  float margin = 20;
  float height = 35;
  int totalLine = (int)self.array.count%columnNum == 0?(int)self.array.count/3:(int)self.array.count/3+1;
  float contentSizeHeight = margin*(totalLine+1)+totalLine*height;
  float length = (SCREEN_WIDTH-20-80)/columnNum;
  for(int i=0;i<self.array.count;i++){
    KnowledgeBaseEntity *bigtype = self.array[i];
    int currentColumn = i%columnNum;//列
    int currentLine = i/columnNum;//行
    CGRect rect = CGRectMake((currentColumn+1)*margin+length*currentColumn,(currentLine+1)*margin+height*currentLine, length, height);
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    button.tag = i;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (bigtype.name.length>(int)length/15+1) {
      NSString *str2 = [bigtype.name substringToIndex:(int)length/15+1];
      [button setTitle:str2 forState:UIControlStateNormal];
    }else{
      [button setTitle:bigtype.name forState:UIControlStateNormal];
    }
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 0.5f;
    button.layer.cornerRadius = 4;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.scrollview addSubview:button];
    [self.itemButtonArray addObject:button];
    /** 拖动手势 */
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragItemAction:)];
    [button addGestureRecognizer:panGestureRecognizer];
  }
  CGFloat moreHeight = (height/2+15-(int)(maxHeight-135)%(int)(margin+height));
  if (contentSizeHeight>maxHeight-135) {
    if ((int)(maxHeight-135)%(int)(margin+height)<20) {
      contentSizeHeight = contentSizeHeight + moreHeight;
    }
    self.scrollview.frame = CGRectMake(0,label.frame.size.height+label.frame.origin.y, SCREEN_WIDTH-20, maxHeight-135+ moreHeight);
    [self.scrollview setContentSize:CGSizeMake(0,contentSizeHeight-moreHeight)];
  }else{
    self.scrollview.frame = CGRectMake(0, label.frame.size.height+label.frame.origin.y, SCREEN_WIDTH-20, contentSizeHeight);
  }
  
  UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.scrollview.frame.size.height+self.scrollview.frame.origin.y+15, SCREEN_WIDTH-20, 20)];
  [self.bgView addSubview:levelLabel];
  levelLabel.textColor = CTThemeMainColor;
  levelLabel.font = [UIFont systemFontOfSize:15];
  levelLabel.textAlignment = NSTextAlignmentCenter;
  levelLabel.text = @"请选择你的技能级别";
  NSArray *levelArray = [NSArray arrayWithObjects:@"初级",@"中级",@"高级", nil];
  for (int i =1; i<4; i++) {
    int currentColumn = (i-1)%columnNum;//列
    CGRect rect = CGRectMake((currentColumn+1)*margin+length*currentColumn,15+levelLabel.frame.size.height+levelLabel.frame.origin.y, length, height);
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    button.tag = i;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:[levelArray objectAtIndex:i-1] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 0.5f;
    button.layer.cornerRadius = 2;
    [button addTarget:self action:@selector(levelClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    if ([ObjectShareTool sharedInstance].currentUser.skillLevel == i) {
      button.backgroundColor = CTThemeMainColor;
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      self.selectButton = button;
    }
    [self.bgView addSubview:button];
  }
  contentSizeHeight = contentSizeHeight+135;
  if (contentSizeHeight>maxHeight) {
    self.bgView.frame = CGRectMake(10, (SCREEN_HEIGHT-maxHeight+moreHeight)/2, SCREEN_WIDTH-20, maxHeight+moreHeight);
//    [self.scrollview setContentSize:CGSizeMake(0, contentSizeHeight+30)];
  }else{
    self.bgView.frame = CGRectMake(10, (SCREEN_HEIGHT-contentSizeHeight)/2, SCREEN_WIDTH-20, contentSizeHeight+30);
  }
  
  [APPDELEGATE.window addSubview:self];
}

-(void)levelClick:(UIButton *)sender{
  [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  self.selectButton.backgroundColor = [UIColor whiteColor];
  sender.backgroundColor =CTThemeMainColor;
  [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.selectButton = sender;
  [self.biz userInfoUpdateSkillLevel:sender.tag success:^{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATESKILLLEVEL object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
  } fail:^(NSError *error) {
    
  }];
}

/** 拖动手势事件 */
- (void)dragItemAction:(UIPanGestureRecognizer *)gesture{
  UIButton *btn = (UIButton *)gesture.view;
  if (gesture.state == UIGestureRecognizerStateBegan){
    startPoint = [gesture locationInView:gesture.view];
    [UIView animateWithDuration:Duration animations:^{
      endRect = btn.frame;
      btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
      btn.alpha = 0.7;
    }];
  }else if (gesture.state == UIGestureRecognizerStateChanged){
    [self dragItem:gesture];
  }else if (gesture.state == UIGestureRecognizerStateEnded){
//    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:Duration animations:^{
      btn.transform = CGAffineTransformIdentity;
      btn.alpha = 1.0;
      btn.frame = endRect;
    }completion:^(BOOL finished) {
      [ObjectShareTool sharedInstance].knowledgeBigTypeData = self.array;
     [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_JOBKNOWLEDGE object:@[self.array,[NSNumber numberWithInteger:self.selectIndex]]];
      if (self.firstEntity != self.array[0]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_JOBKNOWLEDGEFIRST object:nil];
      }
    }];
  }
}
- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn{
  for (NSInteger i = 0;i<_itemButtonArray.count;i++){
    UIButton *button = _itemButtonArray[i];
    if (button != btn){
      if (CGRectContainsPoint(button.frame, point)){
        return i;
      }
    }
  }
  return -1;
}

-(void)dragItem:(UIGestureRecognizer *)sender{
  UIButton *btn = (UIButton *)sender.view;
  CGPoint newPoint = [sender locationInView:sender.view];
  CGFloat deltaX = newPoint.x-startPoint.x;
  CGFloat deltaY = newPoint.y-startPoint.y;
  btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
  NSInteger index = [self indexOfPoint:btn.center withButton:btn];
  if( index <= self.itemButtonArray.count - 1){
    NSLog(@"重叠了");
    UIButton *button = _itemButtonArray[index];
    //数据源的位置也要交换
    KnowledgeBaseEntity *bigtype = self.array[btn.tag];
    [self.array removeObjectAtIndex:btn.tag];
    [self.array insertObject:bigtype atIndex:button.tag];
    [_itemButtonArray removeObjectAtIndex:btn.tag];
    [_itemButtonArray insertObject:btn atIndex:index];
    self.selectIndex = index;
    [self index:button.tag oldIndex:btn.tag];
  }
}

-(void)index:(int)index oldIndex:(int)oldIndex{
  int columnNum = 3;
  float margin = 20;
  float height = 35;
  float length = (SCREEN_WIDTH-20-80)/columnNum;
  int index1;
  int index2;
  if (index>oldIndex) {
    index1 = oldIndex;
    index2 = index;
  }else{
    index1 = index;
    index2 = oldIndex;
  }
  endRect = CGRectMake((index%columnNum+1)*margin+length*(index%columnNum),(index/columnNum+1)*margin+height*(index/columnNum), length, height);
  for (int i=index1; i<index2+1; i++) {
    UIButton *btn = self.itemButtonArray[i];
    btn.tag = i;
    int currentColumn = i%columnNum;//列
    int currentLine = i/columnNum;//行
    CGRect rect = CGRectMake((currentColumn+1)*margin+length*currentColumn,(currentLine+1)*margin+height*currentLine, length, height);
    [UIView animateWithDuration:Duration animations:^{
      btn.frame = rect;
    }];
  }
}


-(void)bgButtonClick{
  [self dismiss];
}

- (void)dismiss{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:@YES forKey:DEF_First];
  [self removeFromSuperview];
}
@end
