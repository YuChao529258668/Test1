//
//  AttentionMenuCell.m
//  CGSays
//
//  Created by mochenyang on 2016/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "AttentionMenuCell.h"

@interface AttentionMenuCell()<UIScrollViewDelegate>{
    UIPageControl *pageControl;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end
@implementation AttentionMenuCell

- (void)awakeFromNib {
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    self.scrollview.delegate = self;
    [super awakeFromNib];
    [self initMenuItem];
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 160, self.contentView.frame.size.width, 20)];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = CTCommonLineBg;
    pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:pageControl];
}

-(void)initMenuItem{
    float margin = (SCREEN_WIDTH - 240)/4;
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIButton *button1 = [self menuItem:CGRectMake(margin, 20, 80, 55) title:@"竞币商城" index:0 image:@"faxiansahngcheng.png" enable:YES];
    [_scrollview addSubview:button1];
    UIButton *button2 = [self menuItem:CGRectMake(margin*2+80, 20, 80, 55) title:@"产品库" index:1 image:@"faxianchanpinku" enable:YES];
    [_scrollview addSubview:button2];
    UIButton *button3 = [self menuItem:CGRectMake(margin*3+80*2, 20, 80, 55) title:@"公司库" index:2 image:@"faxiangongsiku"enable:YES];
    [_scrollview addSubview:button3];
    UIButton *button4 = [self menuItem:CGRectMake(margin, 95, 80, 55) title:@"人物库" index:3 image:@"faxianrenwuku"enable:YES];
    [_scrollview addSubview:button4];
    UIButton *button5 = [self menuItem:CGRectMake(margin*2+80, 95, 80, 55) title:@"频道" index:4 image:@"faxianpindao"enable:YES];
    [_scrollview addSubview:button5];
    UIButton *button6 = [self menuItem:CGRectMake(margin*3+80*2, 95, 80, 55) title:@"全民分享" index:5 image:@"faxianfenxiang" enable:NO];
    [_scrollview addSubview:button6];
    UIButton *button7 = [self menuItem:CGRectMake(SCREEN_WIDTH + margin, 20, 80, 55) title:@"请问" index:6 image:@"faxianqingwen" enable:NO];
    [_scrollview addSubview:button7];
    UIButton *button8 = [self menuItem:CGRectMake(SCREEN_WIDTH + margin*2+80, 20, 80, 55) title:@"行业排行榜" index:7 image:@"faxianpaihangbang" enable:NO];
    [_scrollview addSubview:button8];
    UIButton *button9 = [self menuItem:CGRectMake(SCREEN_WIDTH + margin*3+80*2, 20, 80, 55) title:@"技能广场" index:8 image:@"faxianjinengguangchang" enable:NO];
    [_scrollview addSubview:button9];
    UIButton *button10 = [self menuItem:CGRectMake(SCREEN_WIDTH + margin, 95, 80, 55) title:@"创将说" index:9 image:@"faxianchuangjiangshuo" enable:NO];
    [_scrollview addSubview:button10];
    UIButton *button11 = [self menuItem:CGRectMake(SCREEN_WIDTH + margin*2+80, 95, 80, 55) title:@"原创交易" index:10 image:@"faxianjiaoyi" enable:NO];
    [_scrollview addSubview:button11];
}

-(UIButton *)menuItem:(CGRect)rect title:(NSString *)title index:(int)index image:(NSString *)image         enable:(BOOL)enable{
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    button.enabled = enable;
    button.tag = index;
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((rect.size.width-35)/2, 0, 35, 35)];
    img.clipsToBounds = YES;
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.image = [UIImage imageNamed:image];
    [button addSubview:img];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, rect.size.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.text = title;
    [button addSubview:label];
    if(enable){
        label.textColor = [UIColor blackColor];
    }else{
        label.textColor = [UIColor grayColor];
    }
    [button addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)menuAction:(UIButton *)button{
    NSString *content = nil;
    int index = (int)button.tag;
    if(index == 0){//竞币商城
        
    }else if (index == 1){//产品库
        content = @"discover/productList";
    }else if (index == 2){//公司库
        content = @"discover/companyList";
    }else if (index == 3){//人物库
        content = @"discover/CharacterList";
    }else if (index == 4){//频道
        content = @"discover/channelList";
    }else if (index == 5){//全民分享
        
    }else if (index == 6){//请问
        
    }else if (index == 7){//行业排行榜
        
    }else if (index == 8){//技能广场
        
    }else if (index == 9){//创将说
        
    }else if (index == 10){//原创交易
        
    }
    if(content){
        if(self.delegate && [self.delegate respondsToSelector:@selector(callbackAttentionToH5:)]){
            [self.delegate callbackAttentionToH5:content];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControl.currentPage = [self currentPage];
}
-(int)currentPage{
    CGFloat pageWidth = self.scrollview.frame.size.width;
    return floor((self.scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
