//
//  WhiteBoardViewController.m
//  UltimateShow
//
//  Created by young on 17/1/3.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCWhiteBoardViewController.h"
#import <JCApi/JCApi.h>
#import "JCDoodleView.h"

typedef NS_ENUM(NSInteger, TouchActionMode) {
    TouchActionNone = 0,
    TouchActionDraw,
    TouchActionErase
};

@interface DoodlePathCache : NSObject

- (void)addPath:(JCDoodleAction *)doodle;

- (BOOL)removeLastPathWithUserId:(NSString *)userId pageNumber:(NSUInteger)page;

- (NSArray<JCDoodleAction *> *)getAllPath;

- (BOOL)containsPathWithUserId:(NSString *)userId pageNumber:(NSUInteger)page;

- (void)cleanAllPathWithPageNumber:(NSUInteger)page;

- (void)cleanAllPath;

@end

@implementation DoodlePathCache {
    NSMutableArray<JCDoodleAction *> *_doodleArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _doodleArray = [NSMutableArray array];
    }
    return self;
}

- (void)addPath:(JCDoodleAction *)doodle {
    if (!doodle) {
        return;
    }
    
    [_doodleArray addObject:doodle];
}

- (BOOL)removeLastPathWithUserId:(NSString *)userId pageNumber:(NSUInteger)page {
    if (!userId || userId.length == 0) {
        return NO;
    }
    
    __block NSInteger index = -1;
    
    [_doodleArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(JCDoodleAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([userId isEqualToString:obj.userId] && page == obj.pageNumber) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index == -1) {
        return NO;
    }
    
    [_doodleArray removeObjectAtIndex:index];
    return YES;
}

- (NSArray<JCDoodleAction *> *)getAllPath {
    return _doodleArray;
}

- (BOOL)containsPathWithUserId:(NSString *)userId pageNumber:(NSUInteger)page {
    BOOL contain = NO;
    for (JCDoodleAction *doodle in _doodleArray) {
        if ([doodle.userId isEqualToString:userId] && page == doodle.pageNumber) {
            contain = YES;
            break;
        }
    }
    return contain;
}

- (void)cleanAllPathWithPageNumber:(NSUInteger)page {
    NSMutableArray *temp = [NSMutableArray array];
    for (JCDoodleAction *doodle in _doodleArray) {
        if (doodle.pageNumber == page) {
            [temp addObject:doodle];
        }
    }
    
    [_doodleArray removeObjectsInArray:temp];
}

- (void)cleanAllPath {
    [_doodleArray removeAllObjects];
}
@end


@interface JCWhiteBoardViewController () <JCEngineDelegate, JCDoodleDelegate, DoodleToolbarDelegate, ColourToolbarDelegate>
{
    NSArray<UIColor *> *_backgroundColors;
    NSArray<UIImage *> *_backgroundImages;
    
    TouchActionMode _actionMode;
    CGMutablePathRef _path;
    
    //保存涂鸦轨迹数据
    DoodlePathCache *_doodlePathCache;
    
    UIColor *_brushColor;
    JCDoodleAction *_doodleDraw;
    
    BOOL _drawPathDidMoved;
    
    CGFloat _brushWidth; //画笔宽度
    CGFloat _eraseWidth; //橡皮擦宽度
}

//画涂鸦轨迹的view
@property (nonatomic, strong) JCDoodleView *doodleView;

@property (strong, nonatomic)  UIButton *brushButton;
@property (strong, nonatomic)  UIButton *colourButton;

@end

@implementation JCWhiteBoardViewController

#pragma mark - Setter and Getter

- (void)setCurrentPage:(NSUInteger)currentPage {
    if (currentPage >= _pageCount) {
        return;
    }
    
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        [self loadDoodleViewWithPageNumber:currentPage];
    }
    
    [JCDoodleManager selectPage:_currentPage];
}

- (void)setPageCount:(NSUInteger)pageCount {
    if (pageCount == 0) {
        _pageCount = 1;
    } else {
        _pageCount = pageCount;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (_backgroundColor != backgroundColor) {
        _backgroundColor = [backgroundColor copy];
        _doodleView.backgroundColor = _backgroundColor;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
        _doodleView.backgroundImage = _backgroundImage;
    }
}

- (JCDoodleView *)doodleView {
    if (!_doodleView) {
        _doodleView = [[JCDoodleView alloc] initWithFrame:self.view.bounds];
        _doodleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _doodleView;
}

- (JCDoodleToolbar *)doodletoolbar {
    if (!_doodletoolbar) {
        CGFloat x = (self.view.bounds.size.width - 179) / 2;
        CGFloat y = self.view.bounds.size.height - 35 - 32;
        _doodletoolbar = [[JCDoodleToolbar alloc] initWithFrame:CGRectMake(x, y, 179, 35)];
        //居中，与底部边距不变
        _doodletoolbar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return _doodletoolbar;
}

- (JCColourToolbar *)colorsToolbar {
    if (!_colorsToolbar) {
        CGFloat x = (self.view.bounds.size.width - 308) / 2;
        CGFloat y = self.view.bounds.size.height - 28 - 87;
        _colorsToolbar = [[JCColourToolbar alloc] initWithFrame:CGRectMake(x, y, 308, 28)];
        _colorsToolbar.hidden = YES;
        //居中，与底部边距不变
        _colorsToolbar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return _colorsToolbar;
}

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _actionMode = TouchActionDraw;
        _path = NULL;
        _pageCount = 1;
        _currentPage = 0;
        _brushWidth = 5.0;
        _eraseWidth = 15.0;
        _backgroundColor = [UIColor whiteColor];
        _backgroundImage = nil;
        _doodlePathCache = [[DoodlePathCache alloc] init];
        [[JCEngineManager sharedManager] setDelegate:self];
        [JCDoodleManager setDelegate:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"WhiteBoardViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self.view addSubview:self.doodleView];
    if (!self.doodletoolbar.superview) {
        [self.view addSubview:self.doodletoolbar];
    }
    
    if (!self.colorsToolbar.superview) {
        [self.view addSubview:self.colorsToolbar];
    }
    
    self.doodletoolbar.delegate = self;
    self.colorsToolbar.delegate = self;
        
    //设置colourButton的初始颜色
    _brushColor = [_colorsToolbar currentColor];
    UIImage *image = [UIImage imageNamed:@"colour"];
    UIImage *tintImage = [self imageWithColor:_brushColor originalImage:image];
    _colourButton = [_doodletoolbar.buttons objectAtIndex:1];
    [_colourButton setImage:tintImage forState:UIControlStateNormal];
    
    _brushButton = [_doodletoolbar.buttons objectAtIndex:0];
    _brushButton.selected = YES;
    
    [self loadDoodleViewWithPageNumber:_currentPage];
}

#pragma mark - DoodleToolbar delegate

- (void)doodleToolbar:(JCDoodleToolbar *)doodleToolbarView clickButton:(UIButton *)button buttonType:(DoodleToolbarButtonType)buttonType {
    
    switch (buttonType) {
        case DoodleToolbarButtonTypeDraw:
        {
            button.selected = !button.isSelected;
            
            if (button.isSelected) {
                _actionMode = TouchActionDraw;
            } else {
                _actionMode = TouchActionNone;
            }
        }
            break;
        case DoodleToolbarButtonTypeColour:
            
            _colorsToolbar.hidden = !_colorsToolbar.isHidden;
            
            break;
        case DoodleToolbarButtonTypeClear:
        {
            if ([JCDoodleManager cleanDoodleWithPageNumber:_currentPage] == JCOK) {
                [_doodleView cleanAllPath];
                [_doodlePathCache cleanAllPathWithPageNumber:_currentPage];
            }
        }
            break;
        case DoodleToolbarButtonTypeRevoke:
        {
            if ([_doodlePathCache containsPathWithUserId:[[JCEngineManager sharedManager] getOwnUserId] pageNumber:_currentPage]) {
                if ([JCDoodleManager undoWithPageNumber:_currentPage] == JCOK) {
                    [self undoDrawPathWithUserId:[[JCEngineManager sharedManager] getOwnUserId] pageNumber:_currentPage];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - ColourToolbar delegate

- (void)colourToolbar:(JCColourToolbar *)colourToolbar color:(UIColor *)color {
    UIImage *image = [UIImage imageNamed:@"colour"];
    UIImage *tintImage = [self imageWithColor:color originalImage:image];
    [_colourButton setImage:tintImage forState:UIControlStateNormal];

    _brushColor = color;
}

- (void)onJoinRoomSuccess {
    [JCDoodleManager fetchAllDrawAction];
}

#pragma mark - JCDoodleDelegate

- (void)receiveActionType:(JCDoodleActionType)type doodle:(JCDoodleAction *)doodle fromSender:(NSString *)userId {
    if (type == JCDoodleActionStop) {
        [self cleanAllPath];
        _currentPage = doodle.pageNumber;
        [self loadDoodleViewWithPageNumber:_currentPage];
    }
    else if (type == JCDoodleActionDraw || type == JCDoodleActionErase) {
        if (_doodlePathCache) {
            [_doodlePathCache addPath:doodle];
        }
        
        if (![self isViewLoaded]) {
            return;
        }
        
        if (doodle.pageNumber != _currentPage) {
            return;
        }
        
        [self drawDoodle:doodle];
        
    } else if (type == JCDoodleActionClean) {
        [_doodlePathCache cleanAllPathWithPageNumber:doodle.pageNumber];
        
        if (![self isViewLoaded]) {
            return;
        }
        
        if (doodle.pageNumber == _currentPage) {
            [_doodleView cleanAllPath];
        }
    } else if (type == JCDoodleActionUndo) {
        [self undoDrawPathWithUserId:userId pageNumber:doodle.pageNumber];
        
    } else if (type == JCDoodleActionSelectPage) {
        if (doodle.pageNumber < _pageCount) {
            if (_path) {
                //发送画的action
                //[JCDoodleManager sendDoodleAction:_doodleDraw];
                
                //保存画的action
                //if (_doodlePathCache) {
                //    [_doodlePathCache addPath:_doodleDraw];
                //}
                
                _doodleDraw = nil;
                CGPathRelease(_path);
                _path = NULL;
            }
            
            if (doodle.pageNumber != _currentPage) {
                _currentPage = doodle.pageNumber;
                [self loadDoodleViewWithPageNumber:_currentPage];
            }
        }
    } else if (type == JCDoodleActionFetch) {
        if ([[JCDoodleManager getUserIdOfDoodleOnwer] isEqualToString:[[JCEngineManager sharedManager] getOwnUserId]]) {
            JCDoodleAction *selectDoodle = [[JCDoodleAction alloc] init];
            selectDoodle.actionType = JCDoodleActionSelectPage;
            selectDoodle.pageNumber = _currentPage;
            [JCDoodleManager sendDoodleAction:selectDoodle toAnother:userId];
            
            [self sendAllPathToAnother:userId];
        }
    }
}

#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:_doodleView];
    
    if (_actionMode == TouchActionDraw || _actionMode == TouchActionErase) {
        if (!CGRectContainsPoint(_doodleView.frame, point)) {
            return;
        }
        
        if (_path == NULL) {
            _path = CGPathCreateMutable();
            //加起始点
            CGPathMoveToPoint(_path, NULL, point.x, point.y);
        }
        
        _colorsToolbar.hidden = YES;
        
        if (!_doodleDraw) {
            _doodleDraw = [[JCDoodleAction alloc] init];
        }
        
        _doodleDraw.actionType = _actionMode == TouchActionDraw ? JCDoodleActionDraw : JCDoodleActionErase;
        _doodleDraw.userId = [[JCEngineManager sharedManager] getOwnUserId];
        _doodleDraw.brushColor = _brushColor;
        if (_actionMode == TouchActionDraw) {
            _doodleDraw.brushWidth = _brushWidth / [self getScaleSize].width;
        } else {
            _doodleDraw.brushWidth = _eraseWidth / [self getScaleSize].width;
        }
        _doodleDraw.pageNumber = _currentPage;
        CGPoint cPoint = [self logicFromNormal:point];
        [_doodleDraw addPointWithPositionX:cPoint.x positionY:cPoint.y];
        
        _drawPathDidMoved = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:_doodleView];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:_doodleView];
    
    if (CGPointEqualToPoint(point, prevPoint)) {
        return;
    }
    
    if (_actionMode == TouchActionDraw || _actionMode == TouchActionErase) {
        //当点不在_doodleView上，这一笔结束
        if (!CGRectContainsPoint(_doodleView.frame, point)) {
            if (_path) {
                //path移动过才画到view上并且发送出去
                if (_drawPathDidMoved) {
                    //最后一个点
                    CGPathAddQuadCurveToPoint(_path, NULL, prevPoint.x, prevPoint.y, prevPoint.x, prevPoint.y);
                    
                    if (_actionMode == TouchActionDraw) {
                        //_doodleView更新path
                        [_doodleView drawInCacheWithPath:_path lineWidth:_brushWidth lineColor:_brushColor];
                    } else {
                        [_doodleView eraseInCacheWithPath:_path lineWidth:_eraseWidth];
                    }
                    
                    //发送画的action
                    [JCDoodleManager sendDoodleAction:_doodleDraw];
                    
                    //保存画的action
                    if (_doodlePathCache) {
                        [_doodlePathCache addPath:_doodleDraw];
                    }
                }
                
                _doodleDraw = nil;
                CGPathRelease(_path);
                _path = NULL;
            }
            
            return;
        }
        
        if (_path) {
            //加点
            CGPathAddQuadCurveToPoint(_path, NULL, prevPoint.x, prevPoint.y, (point.x + prevPoint.x) / 2, (point.y + prevPoint.y) / 2);
            
            if (_actionMode == TouchActionDraw) {
                //_doodleView更新path
                [_doodleView drawInTempWithPath:_path lineWidth:_brushWidth lineColor:_brushColor];
            } else {
                [_doodleView eraseInCacheWithPath:_path lineWidth:_eraseWidth];
            }
            
            
            _drawPathDidMoved = YES;
        }
        
        if (_doodleDraw) {
            CGPoint cPoint = [self logicFromNormal:point];
            [_doodleDraw addPointWithPositionX:cPoint.x positionY:cPoint.y];
        }
        
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_actionMode == TouchActionDraw  || _actionMode == TouchActionErase) {
        CGPoint prevPoint = [[touches anyObject] previousLocationInView:_doodleView];
        
        if (_path) {
            //path移动过才画到view上并且发送出去
            if (_drawPathDidMoved) {
                //最后一个点
                CGPathAddQuadCurveToPoint(_path, NULL, prevPoint.x, prevPoint.y, prevPoint.x, prevPoint.y);
                
                if (_actionMode == TouchActionDraw) {
                    //_doodleView更新path
                    [_doodleView drawInCacheWithPath:_path lineWidth:_brushWidth lineColor:_brushColor];
                } else {
                    [_doodleView eraseInCacheWithPath:_path lineWidth:_eraseWidth];
                }
                
                
                //发送画的action
                [JCDoodleManager sendDoodleAction:_doodleDraw];
                
                //保存画的action
                if (_doodlePathCache) {
                    [_doodlePathCache addPath:_doodleDraw];
                }
            }
            
            _doodleDraw = nil;
            CGPathRelease(_path);
            _path = NULL;
        }
    }
}

#pragma mark - public function

- (void)setBackgroundColors:(NSArray<UIColor *> *)colors {
    if (_backgroundColors != colors) {
        _backgroundColors = colors;
        [self loadDoodleViewWithPageNumber:_currentPage];
    }
}

- (void)setBackgroundImages:(NSArray<UIImage *> *)images {
    if (_backgroundImages != images) {
        _backgroundImages = images;
        [self loadDoodleViewWithPageNumber:_currentPage];
    }
}

- (void)cleanAllPath {
    [_doodleView cleanAllPath];
    [_doodlePathCache cleanAllPath];
}

- (void)sendAllPathToAnother:(NSString *)userId {
    for (JCDoodleAction *doodle in [_doodlePathCache getAllPath]) {
        [JCDoodleManager sendDoodleAction:doodle toAnother:userId];
    }
}

#pragma mark - private function

//获取16:9的可画区域大小
- (CGSize)getScaleSize {
    CGSize viewSize = _doodleView.bounds.size;

    if (viewSize.width * 9 > viewSize.height * 16) {
        viewSize.height = viewSize.width * 9 / 16;
    } else {
        viewSize.width = viewSize.height * 16 / 9;
    }

    return viewSize;
}

//屏幕的坐标转换成归一化的逻辑坐标
- (CGPoint)logicFromNormal:(CGPoint)point {
    CGSize size = [self getScaleSize];
    CGFloat x = 2 * point.x / size.width - 1.0;
    CGFloat y = 2 * point.y / size.height - 1.0;
    return CGPointMake(x, y);
}

//归一化的逻辑坐标转换成屏幕的坐标
- (CGPoint)normalFromLogicPositionX:(CGFloat)x positionY:(CGFloat)y {
    CGSize size = [self getScaleSize];
    CGFloat nX = (x + 1.0) * size.width / 2;
    CGFloat nY = (y + 1.0) * size.height / 2;
    return CGPointMake(nX, nY);
}

- (UIImage *)imageWithColor:(UIColor *)tintColor originalImage:(UIImage *)originalImage {
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

//加载DoodleView的背景和历史的涂鸦
- (void)loadDoodleViewWithPageNumber:(NSUInteger)page {
    if (![self isViewLoaded]) {
        return;
    }
    
    UIColor *color = _backgroundColor;
    if (page < _backgroundColors.count) {
        color = _backgroundColors[page];
    }
    _doodleView.backgroundColor = color;
    
    UIImage *image = _backgroundImage;
    if (page < _backgroundImages.count) {
        image = _backgroundImages[page];
    }
    _doodleView.backgroundImage = image;
    
    [self drawCachePathWithPageNumber:page];
}

//画actionType为JCDoodleActionDraw或JCDoodleActionErase的JCDoodleAction
- (void)drawDoodle:(JCDoodleAction *)doodle {
    NSAssert(doodle.actionType == JCDoodleActionDraw || doodle.actionType == JCDoodleActionErase, @"invalid actionType");
    
    CGMutablePathRef path = CGPathCreateMutable();
    __block CGPoint fromPoint, toPoint;
    [doodle.pathPoints enumerateObjectsUsingBlock:^(NSArray<NSNumber *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = [[obj objectAtIndex:1] floatValue];
        CGFloat y = [[obj objectAtIndex:2] floatValue];
        if (idx == 0) {
            fromPoint = [self normalFromLogicPositionX:x positionY:y];
            CGPathMoveToPoint(path, NULL, fromPoint.x, fromPoint.y);
        } else {
            toPoint = [self normalFromLogicPositionX:x positionY:y];
            CGPathAddQuadCurveToPoint(path, NULL, fromPoint.x, fromPoint.y, (toPoint.x + fromPoint.x) / 2, (toPoint.y + fromPoint.y) / 2);
            fromPoint = toPoint;
            
            //最后一个点
            if (idx == doodle.pathPoints.count - 1) {
                CGPathAddQuadCurveToPoint(path, NULL, toPoint.x, toPoint.y, toPoint.x, toPoint.y);
            }
        }
    }];
    
    CGFloat w = doodle.brushWidth * [self getScaleSize].width;
    
    if (doodle.actionType == JCDoodleActionDraw) {
        if (w == 0) {
            w = _brushWidth;
        }
        
        [_doodleView drawInCacheWithPath:path lineWidth:w lineColor:doodle.brushColor];
    } else {
        if (w == 0) {
            w = _eraseWidth;
        }
        
        [_doodleView eraseInCacheWithPath:path lineWidth:w];
    }
    
    CGPathRelease(path);
}

//画缓存的path
- (void)drawCachePathWithPageNumber:(NSUInteger)page {
    if (![self isViewLoaded]) {
        return;
    }
    
    NSArray *drawDoodles = [_doodlePathCache getAllPath];
    
    [_doodleView cleanAllPath];
    
    for (JCDoodleAction *doodle in drawDoodles) {
        if (doodle.pageNumber != page) {
            continue;
        }
        
        [self drawDoodle:doodle];
    }
}

//撤销
- (void)undoDrawPathWithUserId:(NSString *)userId pageNumber:(NSUInteger)page {
    if (_doodlePathCache) {
        
        BOOL remove = [_doodlePathCache removeLastPathWithUserId:userId pageNumber:page];
        if (!remove) {
            return;
        }
        
        if (page != _currentPage) {
            return;
        }
        
        [self drawCachePathWithPageNumber:page];
    }
}



@end
