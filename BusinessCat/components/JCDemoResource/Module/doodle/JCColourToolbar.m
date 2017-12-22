//
//  ColourToolbarView.m
//  UltimateShow
//
//  Created by Nathan Zheng on 2017/1/18.
//  Copyright © 2017年 young. All rights reserved.
//

#define kBtnWidth 24
#define kBtnSpace 10

#import "JCColourToolbar.h"

@interface JCColourToolbar ()
{
    UIButton    *   _curBrushButton;    // 保存当前选中的画笔颜色按钮
    NSArray     *   _brushColorsArray;  // 颜色值的数组
    UIColor     *   _brushColor;        // 被选中的颜色
}
// UIButton的宽高
@property (nonatomic) CGSize buttonSize;                                // 按钮的长宽
// UIButton的间距
@property (nonatomic) NSUInteger buttonSpacing;                         // 按钮的间距
// UIButton的对象数组
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;  // 按钮的数组

@property (nonatomic,strong) NSArray *imageNames;

@end;

@implementation JCColourToolbar

- (NSArray *)buttons
{
    return _buttonArray;
}

- (UIColor *)currentColor
{
    return _brushColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initView];
    }
    return self;
}

// 通过xib加载时候，会调用awakeFromNib方法，所有必须在awakeFromNib方法中同样调用一下initView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initView];
}

- (void)initView
{
    NSString *brushColorPath = [[NSBundle mainBundle] pathForResource:@"brushColors" ofType:@"plist"];
    _brushColorsArray = [[NSArray alloc] initWithContentsOfFile:brushColorPath];
    _brushColor = [self colorWithHexString:[_brushColorsArray objectAtIndex:0]];
    _buttonArray = [NSMutableArray array];
    _buttonSize = CGSizeMake(28, 28);
    _buttonSpacing = 28;
    
    NSArray *images = @[@"icon_pan_red", @"icon_pan_orange", @"icon_pan_yellow", @"icon_pan_green", @"icon_pan_blue", @"icon_pan_purple"];
    self.imageNames = images;
    
    // 颜色图片
    //加颜色按钮
    for (int i = 0; i < _brushColorsArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:images[i]];
        [btn setImage:image forState:UIControlStateNormal];
        
////        UIImage *image = [UIImage imageNamed:@"white"];
//        // 图片
////        UIImage *image = [UIImage imageNamed:@"icon_pan_normal"];
//        UIImage *image = [UIImage imageNamed:@"icon_pan_black"];
//        UIColor *color = [self colorWithHexString:[_brushColorsArray objectAtIndex:i]];
//        UIImage *tintImage;
////        tintImage = [self imageWithColor:color originalImage:image];
//        tintImage = [image imageWithColor:color];
////        tintImage = [image imageWithTintColor:color];
////        tintImage = image;
////        btn.tintColor = color;
//        [btn setImage:tintImage forState:UIControlStateNormal];
        
        
        
////        UIImage *selImage = [UIImage imageNamed:@"white_selected"];
////        UIImage *selImage = [UIImage imageNamed:@"icon_pan_highlight"];
//        UIImage *selImage = [UIImage imageNamed:@"icon_pan_black"];
//        UIImage *selTintImage;
////        selTintImage = [self imageWithColor:color originalImage:selImage];
//        selTintImage = [selImage imageWithColor:color];
////        selTintImage = [selImage imageWithTintColor:color];
////        selTintImage = selImage;
//        [btn setImage:selTintImage forState:UIControlStateSelected];
        
        
        [btn addTarget:self action:@selector(chooseColorAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            btn.selected = YES;
            _curBrushButton = btn;
        }
        [self addSubview:btn];
        [_buttonArray addObject:btn];
    }
}// 初始化View

- (void)chooseColorAction:(UIButton *)sender
{
    if (sender == _curBrushButton) {
        self.hidden = YES;
        return;
    }
    _curBrushButton.selected = NO;
    sender.selected = YES;
    _curBrushButton = sender;
    NSUInteger index = [_buttonArray indexOfObject:sender];
    _brushColor = [self colorWithHexString:[_brushColorsArray objectAtIndex:index]];
    
    self.hidden = YES;
    
    if (_delegate)
    {
        UIImage *image = [UIImage imageNamed:self.imageNames[index]];
        [_delegate colourToolbar:self color:_brushColor colorImage:image];
    }
}// 按钮的触发事件

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat viewWidth = self.frame.size.width;
//    CGFloat viewHeight = self.frame.size.height;
//    CGFloat totalWidth = _buttonSize.width * _brushColorsArray.count + _buttonSpacing * (_brushColorsArray.count - 1);
//
//    for (int i = 0 ; i < _brushColorsArray.count; i++) {
//        UIButton *button = [_buttonArray objectAtIndex:i];
//        button.frame = CGRectMake((viewWidth - totalWidth) / 2 + (_buttonSpacing + _buttonSize.width) * i,
//                                  ((viewHeight - _buttonSize.height) / 2),
//                                  _buttonSize.width,
//                                  _buttonSize.height);
//    }
    
    float y;
    for (int i = 0 ; i < _brushColorsArray.count; i++) {
        y = i * (kBtnSpace + kBtnWidth);
        UIButton *button = [_buttonArray objectAtIndex:i];
        button.frame = CGRectMake(0, y, kBtnWidth, kBtnWidth);
    }

}

- (CGSize)mySize {
    return CGSizeMake(kBtnWidth, (kBtnWidth + kBtnSpace) * _brushColorsArray.count);
}

#pragma mark - util function

- (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

- (UIImage *)imageWithColor:(UIColor *)tintColor originalImage:(UIImage *)originalImage
{
    CGSize size = originalImage.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, originalImage.scale);
    
    CGRect drawRect = CGRectMake(0, 0, size.width, size.height);
    [originalImage drawInRect:drawRect];
    [tintColor set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceAtop);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 初始颜色图片
- (UIImage *)initialColorImage {
    return [UIImage imageNamed:self.imageNames.firstObject];
}

@end
