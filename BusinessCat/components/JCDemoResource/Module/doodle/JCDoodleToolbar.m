//
//  OptionButton.m
//  ButtonView
//
//  Created by 沈世达 on 2017/1/16.
//  Copyright © 2017年 Justin. All rights reserved.
//

#import "JCDoodleToolbar.h"

@interface JCDoodleToolbar ()

@property (nonatomic) NSUInteger count;                 // 按钮的个数
@property (nonatomic) CGSize buttonSize;                // 按钮的长宽
@property (nonatomic) NSUInteger buttonSpacing;         // 按钮的间距

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;  // 按钮的数组

@end;

@implementation JCDoodleToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _horizontalCenter = YES;
        [self initView];
    }
    return self;
}

// 通过xib加载时候，会调用awakeFromNib方法，所有必须在awakeFromNib方法中同样调用一下initView
- (void)awakeFromNib
{
    [super awakeFromNib];
    _horizontalCenter = YES;
    [self initView];
}

- (void)initView
{
    NSArray *backgroundNormals = @[@"brush_off",@"colour",@"clean",@"undo"];
    NSArray *backgourndHighlights = @[@"brush_off_highlighted",@"",@"clean_highlighted",@"undo_highlighted"];
    _buttonArray = [NSMutableArray array];
    _buttonSize = CGSizeMake(35, 35);
    _buttonSpacing = 13;
    _count = 4;
    
    for (int i = 0; i < _count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:backgroundNormals[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:backgourndHighlights[i]] forState:UIControlStateHighlighted];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"brush_on"] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:@"brush_on_highlighted"] forState:UIControlStateHighlighted | UIControlStateSelected];
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttonArray addObject:button];
    }
}// 初始化View

- (NSArray *)buttons
{
    return _buttonArray;
}

- (void)buttonAction:(UIButton *)sender
{
    if (_delegate)
    {
        [_delegate doodleToolbar:self clickButton:sender buttonType:[_buttonArray indexOfObject:sender]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    CGFloat leftSide = _buttonSpacing;
    CGFloat totalWidth = _buttonSize.width * _count + _buttonSpacing * (_count - 1);
    if (_horizontalCenter) {
        leftSide = (viewWidth - totalWidth) / 2;
    }
    
    for (int i = 0; i < _count; i++) {
        UIButton *button = [_buttonArray objectAtIndex:i];
        button.frame = CGRectMake(leftSide + (_buttonSpacing + _buttonSize.width) * i,
                                  ((viewHeight - _buttonSize.height) / 2),
                                  _buttonSize.width,
                                  _buttonSize.height);
    }
}
@end
