//
//  CGKnowledgePushView.m
//  CGKnowledge
//
//  Created by zhu on 2017/6/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKnowledgePushView.h"
#import "KnowledgeBaseEntity.h"
#import "AppDelegate.h"
#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define Duration 0.2

@interface CGKnowledgePushView ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSMutableArray *itemButtonArray;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, assign) CGHorrolEntity *select;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, copy) CGKnowledgeBlock block;
@end

@implementation CGKnowledgePushView

- (instancetype)initWithArray:(NSMutableArray *)array select:(CGHorrolEntity *)select block:(CGKnowledgeBlock)block{
    self.array = array;
    self.block = block;
    self.select = select;
    if ((self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT)])) {
        self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
        self.bgButton.alpha = 0;
        self.bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self addSubview:self.bgButton];
        [self.bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH-20, 0)];
        self.scrollview.layer.cornerRadius = 5;
        self.scrollview.layer.masksToBounds = YES;
        self.scrollview.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollview];
        [self initItem];
    }
    return self;
}

-(void)initItem{
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
        CGRect rect = CGRectMake((currentColumn+1)*margin+length*currentColumn,10+(currentLine+1)*margin+height*currentLine, length, height);
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
        if ([self.select.rolId isEqualToString:bigtype.navType]) {
            button.backgroundColor = CTThemeMainColor;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.selectButton = button;
        }
        [self.scrollview addSubview:button];
        [self.itemButtonArray addObject:button];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    [APPDELEGATE.window addSubview:self];
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
              weakSelf.bgButton.alpha = 1;
            CGFloat maxHeight = SCREEN_HEIGHT-200;
            if (contentSizeHeight>maxHeight) {
              weakSelf.scrollview.frame = CGRectMake(10, (SCREEN_HEIGHT-maxHeight)/2, SCREEN_WIDTH-20, maxHeight);
              [weakSelf.scrollview setContentSize:CGSizeMake(0, contentSizeHeight +10)];
            }else{
            weakSelf.scrollview.frame = CGRectMake(10, (SCREEN_HEIGHT-contentSizeHeight)/2, SCREEN_WIDTH-20, contentSizeHeight+10);
            }
          }completion:^(BOOL finished) {
             
          }];
}

-(void)click:(UIButton *)sender{
    self.selectButton.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.backgroundColor = CTThemeMainColor;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectButton = sender;
    KnowledgeBaseEntity *bigtype = self.array[sender.tag];
    self.block([[CGHorrolEntity alloc]initWithRolId:bigtype.navType rolName:bigtype.name sort:0]);
    [self dismiss];
}

-(void)bgButtonClick{
    [self dismiss];
}

- (void)dismiss{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.scrollview.frame = CGRectMake(10, 64, SCREEN_WIDTH-10, 0);
        weakSelf.bgButton.alpha = 0;
    }completion:^(BOOL finished) {
       [weakSelf removeFromSuperview];
    }];
}
@end
