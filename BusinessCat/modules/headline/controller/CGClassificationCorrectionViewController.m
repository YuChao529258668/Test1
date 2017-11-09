//
//  CGClassificationCorrectionViewController.m
//  CGSays
//
//  Created by zhu on 2016/12/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGClassificationCorrectionViewController.h"
#import "CGHorrolEntity.h"
#import "UIColor+colorToImage.h"
#import "CGInfoHeadEntity.h"
#import "HeadlineBiz.h"

@interface CGClassificationCorrectionViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation CGClassificationCorrectionViewController

-(instancetype)initWithBlock:(CGClassificationCorrectionBlock)block{
    self = [super init];
    if(self){
        resultBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类校正";
    [self initItem];
    // Do any additional setup after loading the view from its nib.
}

-(void)initItem{
    [self.sv.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int columnNum = 3;
    float margin = 20;
    float height = 30;
    int totalLine = (int)[ObjectShareTool sharedInstance].bigTypeData.count%columnNum == 0?(int)[ObjectShareTool sharedInstance].bigTypeData.count/3:(int)[ObjectShareTool sharedInstance].bigTypeData.count/3+1;
    float contentSizeHeight = margin*(totalLine+1)+totalLine*height;
    if(contentSizeHeight <= self.sv.frame.size.height){
        contentSizeHeight = self.sv.frame.size.height+1;
    }
    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH, contentSizeHeight);
    float length = (SCREEN_WIDTH-80)/columnNum;
    for(int i=0;i<[ObjectShareTool sharedInstance].bigTypeData.count;i++){
        CGHorrolEntity *bigtype = [ObjectShareTool sharedInstance].bigTypeData[i];
        int currentColumn = i%columnNum;//列
        int currentLine = i/columnNum;//行
        CGRect rect = CGRectMake((currentColumn+1)*margin+length*currentColumn,(currentLine+1)*margin+height*currentLine, length, height);
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        button.tag = i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor] Rect:button.bounds] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIColor createImageWithColor:CTThemeMainColor Rect:button.bounds] forState:UIControlStateSelected];
        if ([bigtype.rolId isEqualToString:self.bigtype]) {
            button.selected = YES;
            self.selectButton = button;
        }
        
        [button setTitle:bigtype.rolName forState:UIControlStateNormal];
        button.layer.borderColor = CTCommonLineBg.CGColor;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 3;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(clickItenAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.sv addSubview:button];
    }
}

- (void)clickItenAction:(UIButton *)sender{
    self.selectButton.selected = NO;
    sender.selected = YES;
    self.selectButton = sender;
}

- (IBAction)changeClick:(UIButton *)sender {
    CGHorrolEntity *bigtype = [ObjectShareTool sharedInstance].bigTypeData[self.selectButton.tag];
    resultBlock(bigtype.rolId);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
