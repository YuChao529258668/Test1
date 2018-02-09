//
//  YCChatListMenu.m
//  BusinessCat
//
//  Created by 余超 on 2018/2/3.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#define kMenuW 106
#define kRowW 76
#define kRowH 30

#import "YCChatListMenu.h"
@interface YCChatListMenu()
@property (nonatomic, strong) NSMutableArray<UIButton *> *btns;
@property (nonatomic, strong) UIView *containView; // 放按钮
@property (nonatomic, strong) UIImageView *iv;// 三角形
@property (nonatomic, strong) UIView *menu;// 放 iv 和 containView

@end


@implementation YCChatListMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *fullBtn = [[UIButton alloc]initWithFrame:self.bounds];
        [fullBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fullBtn];
        
        
        UIView *menu = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:menu];
        _menu = menu;

        
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 10)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.image = [UIImage imageNamed:@"news_blackblock"];
        [menu addSubview:iv];
        _iv = iv;
        
        
        UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kMenuW, 100)];
        containView.backgroundColor = [UIColor blackColor];
        containView.layer.cornerRadius = 6;
        [menu addSubview:containView];
        _containView = containView;
        
        [self addButtons];

    }
    return self;
}

- (void)addButtons {
    NSArray *titles = @[@" 发起会议", @" 发起群聊", @" 添加好友"];
    NSArray *imageNames = @[@"news_icon_met", @"news_icon_pors", @"news_icon_addpeo"];
    
    float x = 15;
    float y = 0;
    float edgeH = 5;
    
    NSUInteger count = titles.count;
    self.btns = [NSMutableArray arrayWithCapacity:count];

    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btns addObject:btn];
        [_containView addSubview:btn];
        
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

        y = i * kRowH + edgeH;
        btn.frame = CGRectMake(x, y, kRowW, kRowH);

        if (i != 0) {
            UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_line_block"]];
            line.frame = CGRectMake(0, 0, kRowW, 1);
            [btn addSubview:line];
        }
    }

}

//- (void)addButtonWithTitle:(NSString *)title imageName:(NSString *)imageName target:(id)target selector:(SEL)aSelector {
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btns addObject:btn];
//    [_containView addSubview:btn];
//
//    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
//}

- (void)addButtonTarget:(id)target selector:(SEL)aSelector buttonIndex:(NSInteger)index {
    [self.btns[index] addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect menuF = CGRectZero;
    menuF.origin.x = self.frame.size.width - kMenuW - 5;
    menuF.origin.y = self.menuY;
    menuF.size.width = kMenuW;
    menuF.size.height = 115;
    self.menu.frame = menuF;
    
    
    CGPoint center = [self.pointToView.superview convertPoint:self.pointToView.center toView:self.menu];
    center.y = self.iv.center.y;
    self.iv.center = center;

//    int i;
//    NSUInteger count = self.btns.count;
//
//    float x = 0;
//    float y = 0;
//    float edgeH = 20;
//    float rowH = 30;
//    float rowW = 30;
//
//    for (int i = 0; i < count; i++) {
//        y = i * rowH + edgeH;
//        self.btns[i].frame = CGRectMake(x, y, rowW, rowH);
//    }


}

- (void)dismiss {
    self.hidden = YES;
}

@end
