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

#import "YCMeetingBiz.h"
#import "YCMeetingFile.h"
#import "YCMeetingFileManager.h"
#import "YCSelectMeetingFileController.h"
#import "CGInfoHeadEntity.h"
#import "CGHorrolEntity.h"

#define kDoodletoolbarHeight 44
//#define kDoodletoolbarWidth  [UIScreen mainScreen].bounds.size.width //原来179

// 课件名称
NSString * const kkCoursewareJuphoon = @"COURSEWARE_JUPHOON";
NSString * const kkCoursewareMath = @"COURSEWARE_MATH";
NSString * const kkCoursewarePhysics = @"COURSEWARE_PHYSICS";

//// 修改课件的命令
//NSString * const kYCChangeCoursewareCommand = @"YC_CHANGE_COURSEWARE";

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


@interface JCWhiteBoardViewController () <JCEngineDelegate, JCDoodleDelegate, DoodleToolbarDelegate, ColourToolbarDelegate, YCMeetingFileManagerDelegate>
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

// PPT 相关
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,strong) UIButton *prevBtn;
@property (nonatomic,strong) UILabel *pageLabel;
@property (nonatomic,strong) UIButton *closeDocBtn;
@property (nonatomic,strong) UIButton *openFileBtn;
@property (nonatomic,strong) YCMeetingFile *meetingFile; // 课件信息
//@property (nonatomic,strong) NSString *currentFileName; // 当前显示的课件名字
//@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) YCMeetingFileManager *fileManager;
//@property (nonatomic,assign) CGRect oldFrame;
//@property (nonatomic,assign) BOOL isFullScreen;
//@property (nonatomic,assign) CGSize viewWillTransitionToSize;

@property (nonatomic,assign) BOOL isSyncSwitchPage; // 是否同步翻页给其他人
@property (nonatomic,assign) BOOL interactState; // 是否允许互动

@property (nonatomic, strong) UIButton *hideBtn;


@end



@implementation JCWhiteBoardViewController

- (void)configBtns:(BOOL)isReview {
//    BOOL isReview = self.isReview;
    if (isReview) {
        self.closeDocBtn.hidden = YES;
        self.openFileBtn.hidden = YES;
    }
    self.isSyncSwitchPage = !isReview;
    if (!isReview) {
        _actionMode = TouchActionDraw;
    } else {
        _actionMode = TouchActionNone;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.doodletoolbar enableInteraction:!isReview];
    });

}

#pragma mark - Setter and Getter

- (void)setIsReview:(BOOL)isReview {
    _isReview = isReview;
    
    [self configBtns:isReview];
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    if (currentPage >= _pageCount) {
        return;
    }
    
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        [self loadDoodleViewWithPageNumber:currentPage];
    }
    
    if (self.isSyncSwitchPage && !self.isReview) {
        [JCDoodleManager selectPage:_currentPage];
        [[YCMeetingBiz new] updateMeetingPageWithMeetingID:self.meetingID currentPage:currentPage success:nil fail:nil];
    }

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
        
        _fileManager = [YCMeetingFileManager shareManager];
        _fileManager.delegate = self;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"WhiteBoardViewController dealloc");
}

- (void)layoutViews {
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
    {// 画板
        float height = self.view.bounds.size.height - kDoodletoolbarHeight;
        self.doodleView.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
    }
    
    {// 画板工具栏
        CGFloat x = 0;
        CGFloat y = self.view.bounds.size.height - kDoodletoolbarHeight;
//        self.doodletoolbar.frame = CGRectMake(x, y, kDoodletoolbarWidth, kDoodletoolbarHeight);
        self.doodletoolbar.frame = CGRectMake(x, y, self.view.bounds.size.width, kDoodletoolbarHeight);
    }
    
    {// 颜色栏
//        CGFloat x = (self.view.bounds.size.width - 308) / 2;
//        CGFloat y = self.view.bounds.size.height - 28 - 87;
//        self.colorsToolbar.frame = CGRectMake(x, y, 308, 28);
        
        CGSize size = self.colorsToolbar.mySize;
//        x = self.doodletoolbar.buttons.firstObject.frame.origin.x;
        CGFloat x = self.doodletoolbar.buttons.firstObject.center.x - self.colorsToolbar.mySize.width / 2;
//        CGFloat y = self.view.frame.size.height - kDoodletoolbarHeight - size.height; // 全屏后，x = 13, y = 320
        CGFloat y = self.view.bounds.size.height - kDoodletoolbarHeight - size.height;
        self.colorsToolbar.frame = CGRectMake(x, y, size.width, size.height);
    }
    
    // 翻页
    [self layoutPPTViews];
    
//
//    NSLog(@"%@", self.view.subviews);
//    self.doodleView.frame = CGRectMake(0, 0, 200, 200);
//    self.doodletoolbar.frame = CGRectMake(0, 200, 200, 40);
//    self.view.frame = CGRectMake(0, 0, 200, 240);
//
//
//    self.doodleView.backgroundColor = [UIColor yellowColor];
//    self.doodletoolbar.backgroundColor = [UIColor greenColor];
//    self.view.backgroundColor = [UIColor redColor];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
//}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//
////    [self layoutViews];
//    self.viewWillTransitionToSize = size;
//}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
//    if (CGSizeEqualToSize(CGSizeZero, self.viewWillTransitionToSize) ) {
//        [self layoutViews];
//    }
//
//    if (CGSizeEqualToSize(self.view.frame.size, self.viewWillTransitionToSize) ) {
//        [self layoutViews];
//    }
    
    [self layoutViews];
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//
//    NSLog(@"viewDidDisappear 白板");
//    [self.timer invalidate];
//    self.timer = nil;
//}

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
//    UIImage *image = [UIImage imageNamed:@"icon_pan_highlight"];
//    UIImage *tintImage = [self imageWithColor:_brushColor originalImage:image];
//    _colourButton = [_doodletoolbar.buttons objectAtIndex:1];
    _colourButton = [_doodletoolbar.buttons objectAtIndex:DoodleToolbarButtonTypeColour];
    [_colourButton setImage:[_colorsToolbar initialColorImage] forState:UIControlStateNormal];
    
    // 画笔开关按钮
//    _brushButton = [_doodletoolbar.buttons objectAtIndex:0];
    _brushButton = nil;
    _brushButton.selected = YES;
    
    [self loadDoodleViewWithPageNumber:_currentPage];
    
    [self setupPPTViews];
//    [self beginCheckCurrentMeetingFile];
//    [self checkCurrentMeetingFile];
    [self configBtns:self.isReview];
    
    [self setupHideBtn];
}

#pragma mark - DoodleToolbar delegate

- (void)doodleToolbar:(JCDoodleToolbar *)doodleToolbarView clickButton:(UIButton *)button buttonType:(DoodleToolbarButtonType)buttonType {
    
    switch (buttonType) {
            // 画笔开关
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
            NSString *ownUserId = [[JCEngineManager sharedManager] getOwnUserId];
            if (!ownUserId) {
                ownUserId = [ObjectShareTool currentUserID];
            }

            if ([_doodlePathCache containsPathWithUserId:ownUserId pageNumber:_currentPage]) {
                if ([JCDoodleManager undoWithPageNumber:_currentPage] == JCOK) {
                    [self undoDrawPathWithUserId:ownUserId pageNumber:_currentPage];
                }
            }
            
//            if ([_doodlePathCache containsPathWithUserId:[[JCEngineManager sharedManager] getOwnUserId] pageNumber:_currentPage]) {
//                if ([JCDoodleManager undoWithPageNumber:_currentPage] == JCOK) {
//                    [self undoDrawPathWithUserId:[[JCEngineManager sharedManager] getOwnUserId] pageNumber:_currentPage];
//                }
//            }
        }
            break;
        case DoodleToolbarButtonTypeFile:
        {
            [self fileBtnClick];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ColourToolbar delegate

- (void)colourToolbar:(JCColourToolbar *)colourToolbar color:(UIColor *)color colorImage:(UIImage *)image{
//    UIImage *image = [UIImage imageNamed:@"icon_pan_highlight"];
//    UIImage *tintImage = [self imageWithColor:color originalImage:image];
//    [_colourButton setImage:tintImage forState:UIControlStateNormal];
    [_colourButton setImage:image forState:UIControlStateNormal];

    _brushColor = color;
}

- (void)onJoinRoomSuccess {
    [JCDoodleManager fetchAllDrawAction];
}

#pragma mark - JCDoodleDelegate 命令

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
            [self updatePageLabel];
        }
    } else if (type == JCDoodleActionFetch) {
        NSString *ownUserId = [[JCEngineManager sharedManager] getOwnUserId];
        if (!ownUserId) {
            ownUserId = [ObjectShareTool currentUserID];
        }

        if ([[JCDoodleManager getUserIdOfDoodleOnwer] isEqualToString:ownUserId]) {
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
        NSString *ownUserId = [[JCEngineManager sharedManager] getOwnUserId];
        if (!ownUserId) {
            ownUserId = [ObjectShareTool currentUserID];
        }
        _doodleDraw.userId = ownUserId;
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
    
    BOOL hidden = images.count == 0? YES: NO;
    self.prevBtn.hidden = hidden;
    self.nextBtn.hidden = hidden;
    self.pageLabel.hidden = hidden;
//    self.closeDocBtn.hidden = hidden;
    self.pageCount = images.count;
    [self updatePageLabel];
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
    
//    if (viewSize.width * 9 > viewSize.height * 16) {
//        viewSize.height = viewSize.width * 9 / 16;
//    } else {
//        viewSize.width = viewSize.height * 16 / 9;
//    }
    
    return viewSize;
}

//屏幕的坐标转换成归一化的逻辑坐标
- (CGPoint)logicFromNormal:(CGPoint)point {
    CGSize size = [self getScaleSize];
    CGFloat x = 2 * point.x / size.width - 1.0;
    CGFloat y = 2 * point.y / size.height - 1.0;
    
    x = point.x / size.width;
    y = point.y / size.height;
    return CGPointMake(x, y);
}

//归一化的逻辑坐标转换成屏幕的坐标
- (CGPoint)normalFromLogicPositionX:(CGFloat)x positionY:(CGFloat)y {
    CGSize size = [self getScaleSize];
    CGFloat nX = (x + 1.0) * size.width / 2;
    CGFloat nY = (y + 1.0) * size.height / 2;
    
    nX = x * size.width;
    nY = y * size.height;
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
//    if (page < _backgroundImages.count) {
//        image = _backgroundImages[page];
//    }
    NSUInteger count = self.meetingFile.imageUrls.count;
    if (count > 0) {
        page = page >= count? count - 1: page;
//        image = [self.fileManager getImageWithURLStr:self.meetingFile.imageUrls[page]];
        
        NSString *urlStr = self.meetingFile.imageUrls[page];
        NSString *imageName = self.meetingFile.imageNames[page];
        image = [self.fileManager getImageWithURLStr:urlStr imageName:imageName fileName:self.meetingFile.fileName];
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


#pragma mark - yc_PPT

// 上一页、下一页、页码、关闭文档按钮
- (void)setupPPTViews {
    UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fileBtn setImage:[UIImage imageNamed:@"new_icon_official_open"] forState:UIControlStateNormal];
    [fileBtn addTarget:self action:@selector(fileBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    fileBtn.hidden = YES;
    [self.view addSubview:fileBtn];
    self.openFileBtn = fileBtn;

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"new_video_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeDocBtnClick) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.hidden = YES;
    [self.view addSubview:closeBtn];
    self.closeDocBtn = closeBtn;
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setImage:[UIImage imageNamed:@"new_icon_right_normal"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextPageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevBtn setImage:[UIImage imageNamed:@"new_icon_left_normal"] forState:UIControlStateNormal];
    [prevBtn addTarget:self action:@selector(previousPageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prevBtn];
    self.prevBtn = prevBtn;

    UILabel *pageLabel = [UILabel new];
    pageLabel.numberOfLines = 1;
    pageLabel.textColor =[CTCommonUtil convert16BinaryColor:@"#777777"];
    pageLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:pageLabel];
    self.pageLabel = pageLabel;
    [self updatePageLabel];
    
    BOOL hidden = YES;
    self.prevBtn.hidden = hidden;
    self.nextBtn.hidden = hidden;
    self.pageLabel.hidden = hidden;
}

#pragma mark - yc_Actions

- (void)nextPageBtnClick {
    if (self.pageCount == 0) {
        return;
    }
    
    if (self.currentPage == self.pageCount - 1) {
        return;
    }
    
    int page = self.currentPage + 1;
    page = page >= self.pageCount? self.pageCount - 1: page;
    self.currentPage = page;
    [self updatePageLabel];
}

- (void)previousPageBtnClick {
    if (self.pageCount == 0) {
        return;
    }

    if (self.currentPage == 0) {
        return;
    }
    
    int page = self.currentPage - 1;
    page = page < 0? 0: page;
    self.currentPage = page;
    [self updatePageLabel];
}

- (void)updatePageLabel {
    self.pageLabel.text = [NSString stringWithFormat:@"%lu/%ld", self.currentPage + 1, (unsigned long)self.pageCount];
//    self.closeDocBtn.hidden = NO;
    if (_backgroundImages.count == 0) {
        self.pageLabel.text = @"0/0";
//        self.closeDocBtn.hidden = YES;
    }
    [self layoutPPTViews];
}

- (void)closeDocBtnClick {
//    [JCDoodleManager sendCoursewareUrl:@""];
    self.meetingFile = nil;
    [self setBackgroundImages:nil];
    self.pageCount = 0;
    self.currentPage = 0;
    [self updatePageLabel];
    self.closeDocBtn.hidden = YES;
    
    __weak typeof(self) weakself = self;
    [self updateMeetingFile:nil fileType:0 withSuccess:^{
        [weakself sendChangeCoursewareCommand];
    }];
}

- (void)layoutPPTViews {
    // 上一页、下一页、页码、关闭文档按钮
    
//    float sw = self.view.frame.size.width; // 父视图宽度
    float sw = self.view.bounds.size.width; // 父视图宽度
    float btnW = 22; // 按钮宽度
    
    float barH = 44; // 底部栏高度
//    float y = self.view.frame.size.height - (barH / 2 + btnW / 2);
    float y = self.view.bounds.size.height - (barH / 2 + btnW / 2);

    float nextX = sw - btnW - 15;
    self.nextBtn.frame = CGRectMake(nextX, y, btnW, btnW);

    CGSize labelSize = [self.pageLabel sizeThatFits:CGSizeMake(100, btnW)];
    float labelX = nextX - 10 - labelSize.width;
    self.pageLabel.frame = CGRectMake(labelX, y, labelSize.width, btnW) ;
    
    float prevX = labelX - 10 - btnW;
    self.prevBtn.frame = CGRectMake(prevX, y, btnW, btnW);
    
//    float closeBtnW = 26;
    float closeBtnW = 50;
    float closeX = sw - closeBtnW - closeBtnW - 15;
    self.closeDocBtn.frame = CGRectMake(closeX, 20, closeBtnW, closeBtnW);
    
    float fileX = sw - closeBtnW - 15;
    self.openFileBtn.frame = CGRectMake(fileX, 20, closeBtnW, closeBtnW);
}


- (void)fileBtnClick0 {
//      kkCoursewareJuphoon
//      kkCoursewareMath
//      kkCoursewarePhysics
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"选择文件" message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *qita = [UIAlertAction actionWithTitle:@"网络" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [JCDoodleManager sendCoursewareUrl:url];

    }];
    
    UIAlertAction *wuli = [UIAlertAction actionWithTitle:@"物理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JCDoodleManager sendCoursewareUrl:kkCoursewarePhysics];

    }];

    UIAlertAction *juphoon = [UIAlertAction actionWithTitle:@"PPT" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JCDoodleManager sendCoursewareUrl:kkCoursewareJuphoon];

    }];

    UIAlertAction *shuxue = [UIAlertAction actionWithTitle:@"数学" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JCDoodleManager sendCoursewareUrl:kkCoursewareMath];

    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [ac addAction:qita];
    [ac addAction:wuli];
    [ac addAction:juphoon];
    [ac addAction:shuxue];
    [ac addAction:cancle];

    [self presentViewController:ac animated:YES completion:nil];
}

// 选择文件
- (void)fileBtnClick {
    __weak typeof(self) weakself = self;
    YCSelectMeetingFileController *vc = [YCSelectMeetingFileController new];
    vc.meetingID = self.meetingID;
    vc.didSelectBlock = ^(CGInfoHeadEntity *entity, int fileType) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"确定使用此文档吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:cancel];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself.navigationController popViewControllerAnimated:YES];
            
            // 更新服务器
            [weakself updateMeetingFile:entity fileType:fileType withSuccess:^{
                [weakself sendChangeCoursewareCommand];
                [weakself checkCurrentMeetingFile];
            }];
            
        }];
        [ac addAction:sure];
        [weakself presentViewController:ac animated:YES completion:nil];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

// 区分是要关闭文件，还是传的文库、素材。
// fileType，0 文件，1 素材
// 素材的图片地址 cover,  名字是 name
// 文库的名字是 title，封面地址是 icon
// 关闭文件传的 nil
- (void)updateMeetingFile:(CGInfoHeadEntity *)entity fileType:(int)fileType withSuccess:(void(^)())success {
    NSString *fileID = nil;
    NSString *picURL = nil;
    
    if (entity) {
//        NSString *fileName;
//        if ([entity isKindOfClass:[CGInfoHeadEntity class]]) {
//            // 文库是 CGInfoHeadEntity
//            CGInfoHeadEntity *info = (CGInfoHeadEntity *)entity;
//            fileID = info.infoId;
//            fileName = info.title;
//        } else if ([entity isKindOfClass:[CGInfoHeadEntity class]]) {
//            // 素材是 CGHorrolEntity
//            CGInfoHeadEntity *info = (CGInfoHeadEntity *)entity;
//            fileID = info.infoId;
//            picURL = info.cover;
//            fileName = info.name;
//        } else {
//            [CTToast showWithText:@"未知文件类型，更新会议文件失败"];
//            return;
//        }
        
        fileID = entity.infoId;
        picURL = entity.cover;
        // 同一个文件不用更新
        if ([entity.infoId isEqualToString:self.meetingFile.toId]) {
            return;
        }

    } else {
        // 关闭课件
        fileID = @"0";
    }
    
    // fileType，0 文件，1 素材
    [[YCMeetingBiz new] updateMeetingFileWithMeetingID:self.meetingID fileType:fileType toId:fileID picUrl:picURL success:^(id data) {
        if (success) {
            success();
        }
    } fail:^(NSError *error) {
        [CTToast showWithText:[NSString stringWithFormat:@"更新会议文件失败 : %@", error]];
    }];
}


#pragma mark - 课件接口

//- (void)beginCheckCurrentMeetingFile {
//    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(checkCurrentMeetingFile) userInfo:nil repeats:YES];
//    timer add
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkCurrentMeetingFile) userInfo:nil repeats:YES];
//    self.timer = timer;
//    [timer fire];
//}

// 获取服务器保存的课件
- (void)checkCurrentMeetingFile {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] getCurrentFileWithMeetingID:self.meetingID success:^(id data) {
        YCMeetingFile *file = [YCMeetingFile mj_objectWithKeyValues:data];
        
        // 同一个课件
        if ([file.toId isEqualToString:weakself.meetingFile.toId]) {
            return ;
        }
        // 没有课件
        if (file.pageCount == 0) {
            if (weakself.closeDocBtn.hidden == NO) {
                [weakself.closeDocBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            return;
        } else {
            // 有课件
            self.closeDocBtn.hidden = !self.interactState;
            if (self.isReview) {
                self.closeDocBtn.hidden = YES;
            }
        }
        
//        if (weakself.meetingFile) {
            [weakself cleanAllPath]; // 清除轨迹
//        }
        
        weakself.meetingFile = file;
        weakself.pageCount = file.pageCount;
        weakself.currentPage = file.pageIn;
        
        NSArray *images = [weakself.fileManager getImagesWithURLStrings:file.imageUrls imageNames:file.imageNames fileName:file.fileName];
        [weakself setBackgroundImages:images];
        
    } fail:^(NSError *error) {
//        [CTToast showWithText:[NSString stringWithFormat:@"获取当前课件失败 : %@", error]];
    }];
}


//
//- (void)getImagesOfURLs:(NSArray<NSString *> *)imageUrls complete:(void (^)(NSArray *images))block {
////    // 假图片，提示正在下载
////    UIImage *image = [UIImage imageNamed:@"meeting_download_ing"];
////    NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageUrls.count];
////    [imageUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        [images addObject:image];
////    }];
////    [self setBackgroundImages:images];
//
//    // 假图片，提示下载错误
//    UIImage *errorImage = [UIImage imageNamed:@"meeting_download_error"];
//
//    // 下载图片
//    [self getImagesOfURLs:imageUrls falseImage:errorImage complete:^(NSArray *images) {
//        if (block) {
//            block(images);
//        }
//    }];
//}
//
//// falseImage 假图片，下载错误时用到
//- (void)getImagesOfURLs:(NSArray<NSString *> *)urls falseImage:(UIImage *)falseImage complete:(void (^)(NSArray *images))block {
//    NSMutableArray *images = [NSMutableArray new];
//    dispatch_group_t group = dispatch_group_create();
//
//    for (NSString *urlStr in urls) {
//        NSURL *url = [NSURL URLWithString:urlStr];
//
//        dispatch_group_enter(group);
//        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//            if (image) {
//                [images addObject:image];
//            } else {
//                [images addObject:falseImage];
//            }
//            dispatch_group_leave(group);
//        }];
//    }
//
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        if (block) {
//            block(images);
//        }
//    });
//}
//
//- (void)saveImages:(NSArray *)images withFileName:(NSString *)name imageNames:(NSArray *)names {
//    //Document目录
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    path = [path stringByAppendingPathComponent:name];
//
//    // 创建目录
//
//    // 查找目录
//
//
//    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
//    //    NSString *imagePath;
//    //    for (int i = 0; i < images.count; i ++) {
//    //        imagePath = [path stringByAppendingPathComponent:names[i]];
//    //        [UIImagePNGRepresentation(images[i]) writeToFile:imagePath atomically:YES];
//    //    }
//}


#pragma mark - YCMeetingFileManagerDelegate

- (void)meetingFileManager:(YCMeetingFileManager *)manager didDownloadImage:(UIImage *)image imageUrlStr:(NSString *)urlStr {
//    [self.fileManager getImageWithURLStr:urlStr];
    [self loadDoodleViewWithPageNumber:self.currentPage];
}


//#pragma mark - 全屏
//
//- (void)handleDoubleTap {
//    if (self.isFullScreen) {
//        self.view.frame = self.oldFrame;
//        self.isFullScreen = NO;
//    } else {
//        self.oldFrame = self.view.frame;
//        self.view.frame = self.view.superview.frame;
//        self.isFullScreen = YES;
//    }
//}

// 是否允许画画
- (void)enableDraw:(BOOL)enable {
    if (self.isReview) {
        enable = NO;
    }
    
    if (enable) {
        _actionMode = TouchActionDraw;
    } else {
        _actionMode = TouchActionNone;
    }
    [self.doodletoolbar enableInteraction:enable];
    
//    self.closeDocBtn.hidden = !enable;
    if (self.meetingFile.pageCount > 0 && enable) {
        self.closeDocBtn.hidden = NO;
    } else {
        self.closeDocBtn.hidden = YES;
    }
    
    self.interactState = enable;
}

// 翻页是否同步给其他人
- (void)enableSwitchPage:(BOOL)enable {
    self.isSyncSwitchPage = enable;
}


// 发送课件改变的命令，收到命令后问服务器给数据
- (void)sendChangeCoursewareCommand {
//    int success = [[JCEngineManager sharedManager] sendData:kYCChangeCoursewareCommand content:@"YC_CHANGE_COURSEWARE" toReceiver:nil];
//    if (success != JCOK) {
//        [CTToast showWithText:@"发送更新会议文件消息失败"];
//    }
    [[JCEngineManager sharedManager] sendData:kYCChangeCoursewareCommand content:@"YC_CHANGE_COURSEWARE" toReceiver:nil];

}

#pragma mark -


- (void)setupHideBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickHideBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(12, 20, 50, 50);
    self.hideBtn = btn;
    [btn setImage:[UIImage imageNamed:@"new_video_left"] forState:UIControlStateNormal];
    [self.view bringSubviewToFront:btn];
}

- (void)clickHideBtn {
    self.view.hidden = YES;
    if (self.didClickBackBtnBlock) {
        self.didClickBackBtnBlock();
    }
}

@end

