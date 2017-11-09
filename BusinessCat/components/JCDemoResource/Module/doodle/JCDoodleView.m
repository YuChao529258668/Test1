//
//  DoodleView.m
//  UltimateShow
//
//  Created by young on 17/1/4.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCDoodleView.h"
#import "JCDoodleDrawView.h"

@interface JCDoodleView ()

@property (nonatomic, strong) UIImageView *backgroundView;
//缓存轨迹的画布
@property (nonatomic, strong) JCDoodleDrawView *cacheCanvas;
//临时的画布
@property (nonatomic, strong) JCDoodleDrawView *tempCanvas;

@end

@implementation JCDoodleView

- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        if (_backgroundImage) {
            _backgroundView.image = _backgroundImage;
        }
    }
    return _backgroundView;
}

- (JCDoodleDrawView *)cacheCanvas
{
    if (!_cacheCanvas) {
        _cacheCanvas = [[JCDoodleDrawView alloc] init];
        _cacheCanvas.backgroundColor = [UIColor clearColor];
    }
    return _cacheCanvas;
}

- (JCDoodleDrawView *)tempCanvas
{
    if (!_tempCanvas) {
        _tempCanvas = [[JCDoodleDrawView alloc] init];
        _tempCanvas.backgroundColor = [UIColor clearColor];
    }
    return _tempCanvas;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
        if (_backgroundView) {
            _backgroundView.image = backgroundImage;
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImage = image;
        
        [self addViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame image:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addViews];
}

- (void)layoutSubviews
{
    if (_backgroundView) {
        _backgroundView.frame = self.bounds;
    }
    
    if (_cacheCanvas) {
        _cacheCanvas.frame = self.bounds;
    }
    
    if (_tempCanvas) {
        _tempCanvas.frame = self.bounds;
    }
}

- (void)addViews
{
    [self addSubview:self.backgroundView];
    [self addSubview:self.cacheCanvas];
    [self addSubview:self.tempCanvas];
}

- (void)drawInCacheWithPath:(CGPathRef)path lineWidth:(CGFloat)width lineColor:(UIColor *)color
{
    if (_tempCanvas) {
        [_tempCanvas cleanAllPath];
    }
    
    if (_cacheCanvas) {
        [_cacheCanvas drawInCacheWithPath:path width:width color:color];
    }
}

- (void)drawInTempWithPath:(CGPathRef)path lineWidth:(CGFloat)width lineColor:(UIColor *)color
{
    if (_tempCanvas) {
        [_tempCanvas drawInTempWithPath:path width:width color:color];
    }
}

- (void)eraseInCacheWithPath:(CGPathRef)path lineWidth:(CGFloat)width
{
    if (_cacheCanvas) {
        [_cacheCanvas eraseInCacheWithPath:path width:width];
    }
}

- (void)cleanAllPath
{
    if (_cacheCanvas) {
        [_cacheCanvas cleanAllPath];
    }
    
    if (_tempCanvas) {
        [_tempCanvas cleanAllPath];
    }
}
@end
