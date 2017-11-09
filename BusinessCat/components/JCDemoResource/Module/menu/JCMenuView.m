//
//  MenuView.m
//  UltimateShow
//
//  Created by 沈世达 on 17/4/6.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCMenuView.h"
#import "UIButton+MenuTitleSpacing.h"

@interface JCMenuView ()

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic) NSUInteger count;                 // 按钮的个数
@property (nonatomic) CGSize buttonSize;                // 按钮的长宽
@property (nonatomic) NSUInteger buttonSpacing;         // 按钮的间距

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;  // 按钮的数组

@end

@implementation JCMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initView];
    }
    return self;
}

- (UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"function_close"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"function_close_highlighted"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

// 通过xib加载时候，会调用awakeFromNib方法，所有必须在awakeFromNib方法中同样调用一下initView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initView];
}

- (void)initView
{
    _count = 3;
    _buttonSize = CGSizeMake(114, 114);
    _buttonSpacing = 48;
    _buttonArray = [NSMutableArray array];
    NSArray *titles = @[@"视频会议", @"白板涂鸦", @"屏幕共享"];
    NSArray *images = @[@"video_conference", @"doodle", @"screen_share"];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

    for (int i = 0; i < _count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blackColor];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:12];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:button];
        [_buttonArray addObject:button];
    }
    
    [self addSubview:self.closeButton];
}

- (NSArray<UIButton *> *)buttons
{
    return _buttonArray;
}

- (void)buttonAction:(UIButton *)sender
{
    if (_delegte) {
        [_delegte menuView:self clickButton:sender buttonType:[_buttonArray indexOfObject:sender]];
    }
}

- (void)closeAction:(UIButton *)sender
{
    if (_delegte) {
        [_delegte closeMenu];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    CGFloat totalWidth = _buttonSize.width * _count + _buttonSpacing * (_count - 1);
    for (int i = 0; i < _count; i++) {
        UIButton *button = [_buttonArray objectAtIndex:i];
        button.frame = CGRectMake((viewWidth - totalWidth) / 2 + (_buttonSpacing + _buttonSize.width) * i,
                                  ((viewHeight - _buttonSize.height) / 2),
                                  _buttonSize.width,
                                  _buttonSize.height);
    }
    
    if (_closeButton) {
        _closeButton.frame = CGRectMake(16, 16, 24, 24);
    }
}

@end
