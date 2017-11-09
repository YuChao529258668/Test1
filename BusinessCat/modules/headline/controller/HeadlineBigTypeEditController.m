//
//  HeadlineBigTypeEditController.m
//  CGSays
//
//  Created by mochenyang on 2016/10/31.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadlineBigTypeEditController.h"
#import "HeadlineBiz.h"
#import "CGHorrolEntity.h"

#define Duration 0.2

@interface HeadlineBigTypeEditController (){
    UIScrollView *scrollview;
    CGPoint startPoint;
    CGRect endRect;
  
}
@property(nonatomic,retain)NSMutableArray *itemButtonArray;
@property(nonatomic,retain)HeadlineBiz *biz;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation HeadlineBigTypeEditController

-(NSMutableArray *)itemButtonArray{
    if(!_itemButtonArray)_itemButtonArray = [NSMutableArray array];
    return _itemButtonArray;
}

-(HeadlineBiz *)biz{
    if(!_biz){
        _biz = [[HeadlineBiz alloc]init];
    }
    return _biz;
}


-(instancetype)initWithSuccess:(CGHeadlineEditBlock)success cancel:(CGHeadlineEditCancelBlock)cancel{
    self = [super init];
    if(self){
        editBlock = success;
        cancelBlock = cancel;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类排序";
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.navi.frame), SCREEN_HEIGHT, 44)];
    label.textColor = [UIColor blackColor];
    label.text = @"头条分类(拖动改变顺序)";
    [self.view addSubview:label];
    self.array = [[ObjectShareTool sharedInstance].bigTypeData mutableCopy];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), SCREEN_WIDTH, 0.5)];
    line.backgroundColor = CTCommonLineBg;
    [self.view addSubview:line];
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(line.frame) - 44)];
    [self.view addSubview:scrollview];
    
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    [okBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [okBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];
  [okBtn addTarget:self action:@selector(sureBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initItem];
}

-(void)sureBackAction:(UIButton *)sender{
  [ObjectShareTool sharedInstance].bigTypeData = self.array;
  [sender setUserInteractionEnabled:NO];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    for (int i=0;i<[ObjectShareTool sharedInstance].bigTypeData.count;i++) {
      CGHorrolEntity *bigtype = [ObjectShareTool sharedInstance].bigTypeData[i];
      bigtype.sort = i;
    }
        NSMutableArray *bigTypeData = [ObjectShareTool sharedInstance].bigTypeData;
        NSMutableArray *dictArray = [NSMutableArray array];
        for(int i=0;i<bigTypeData.count;i++){
            CGHorrolEntity *entity = bigTypeData[i];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:entity.rolId,@"typeId",entity.rolName,@"typeName", nil];
            [dictArray addObject:dict];
        }
    [self.biz updateHeadlineBigtypeSortWithArray:dictArray success:^{
      dispatch_async(dispatch_get_main_queue(), ^{
        if(editBlock){
          editBlock(0);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
      });
    } fail:^(NSError *error) {
      [sender setUserInteractionEnabled:YES];
    }];
  });
}

-(void)baseBackAction{
    [super baseBackAction];
}

-(void)okBtnAction{
  
}


-(void)initItem{
    [scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int columnNum = 3;
    float margin = 20;
    float height = 35;
    int totalLine = (int)[ObjectShareTool sharedInstance].bigTypeData.count%columnNum == 0?(int)[ObjectShareTool sharedInstance].bigTypeData.count/3:(int)[ObjectShareTool sharedInstance].bigTypeData.count/3+1;
    float contentSizeHeight = margin*(totalLine+1)+totalLine*height;
    if(contentSizeHeight <= scrollview.frame.size.height){
        contentSizeHeight = scrollview.frame.size.height+1;
    }
    scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, contentSizeHeight);
    float length = (SCREEN_WIDTH-80)/columnNum;
    for(int i=0;i<self.array.count;i++){
        CGHorrolEntity *bigtype = self.array[i];
        int currentColumn = i%columnNum;//列
        int currentLine = i/columnNum;//行
        CGRect rect = CGRectMake((currentColumn+1)*margin+length*currentColumn,(currentLine+1)*margin+height*currentLine, length, height);
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        button.tag = i;
        if(button.tag == 0){
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [button setTitle:bigtype.rolName forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 2;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(clickItenAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:button];
        [self.itemButtonArray addObject:button];
        /** 拖动手势 */
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragItemAction:)];
        [button addGestureRecognizer:panGestureRecognizer];
    }
}

-(void)clickItenAction:(UIButton *)button{
    int tag = (int)button.tag;
    if(editBlock){
        editBlock(tag);
    }
    [self baseBackAction];
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
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:Duration animations:^{
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            btn.frame = endRect;
        }completion:^(BOOL finished) {
            [weakSelf okBtnAction];
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
    if(btn.tag > 0 && index > 0 && index <= self.itemButtonArray.count - 1){
      NSLog(@"重叠了");
        UIButton *button = _itemButtonArray[index];
      //数据源的位置也要交换
      CGHorrolEntity *bigtype = self.array[btn.tag];
      [self.array removeObjectAtIndex:btn.tag];
      [self.array insertObject:bigtype atIndex:button.tag];
      [_itemButtonArray removeObjectAtIndex:btn.tag];
      [_itemButtonArray insertObject:btn atIndex:index];
      [self index:button.tag oldIndex:btn.tag];
    }
}

-(void)index:(int)index oldIndex:(int)oldIndex{
  int columnNum = 3;
  float margin = 20;
  float height = 35;
  float length = (SCREEN_WIDTH-80)/columnNum;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
