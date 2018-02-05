//
//  YCChatListMenu.m
//  BusinessCat
//
//  Created by 余超 on 2018/2/3.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCChatListMenu.h"
@interface YCChatListMenu()
@property (nonatomic, strong) NSMutableArray<UIButton *> *btns;

@end


@implementation YCChatListMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addButtons];
    }
    return self;
}

- (void)addButtons {
    NSArray *titles = @[@"发起会议", @"发起群聊", @"添加好友"];
    NSArray *imageNames = @[@"发起会议", @"发起群聊", @"添加好友"];
    
    float x = 0;
    float y = 0;
    float edgeH = 20;
    float rowH = 30;
    float rowW = 30;
    
    NSUInteger count = titles.count;
    self.btns = [NSMutableArray arrayWithCapacity:count];

    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btns addObject:btn];
        [self addSubview:btn];
        
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        y = i * rowH + edgeH;
        btn.frame = CGRectMake(x, y, rowW, rowH);

        if (i != 0) {
            UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            line.frame = CGRectMake(0, 0, rowW, 1);
            [btn addSubview:line];
        }
    }

}
- (void)addButtonWithTitle:(NSString *)title imageName:(NSString *)imageName target:(id)target selector:(SEL)aSelector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btns addObject:btn];
    [self addSubview:btn];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
}

//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
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
//
//
//}


@end
