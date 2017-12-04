//
//  SplitScreenView.m
//  SplitScreen
//
//  Created by young on 16/12/9.
//  Copyright © 2016年 young. All rights reserved.
//

#import "JCSplitScreenView.h"

@implementation JCSplitScreenViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        _contentView = [[UIView alloc] init];
        _contentView.layer.borderWidth = 0.5f;
        _contentView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self addSubview:_contentView];
        
        _renderView = [[UIView alloc] init];
        [_contentView addSubview:_renderView];
        
        _videoOffView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"split_status_camera_off_50"]];
        _videoOffView.contentMode = UIViewContentModeCenter;
        _videoOffView.backgroundColor = [UIColor colorWithRed:68.0f/255.0f green:68.0f/255.0f blue:68.0f/255.0f alpha:1.0f];
        _videoOffView.hidden = YES;
        [_contentView addSubview:_videoOffView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        [_contentView addSubview:_titleLabel];
        
        _microphoneView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"split_status_microphone"]];
        _microphoneView.contentMode = UIViewContentModeScaleToFill;
        _microphoneView.hidden = YES;
        [_contentView addSubview:_microphoneView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_contentView) {
        
        //        CGFloat w = self.bounds.size.width;
        //        CGFloat h = self.bounds.size.height;
        
        //        CGFloat scale = 16.0 / 9.0;
        //
        //        if ((w / h) < scale) {
        //            _contentView.frame = CGRectMake(0, (h - w / scale) / 2, w, w / scale);
        //        } else {
        //            _contentView.frame = CGRectMake((w - h * scale) / 2, 0, h * scale, h);
        //        }
        
        _contentView.frame = self.bounds;
    }
    
    if (_renderView) {
        _renderView.frame = _contentView.bounds;
    }
    
    if (_titleLabel) {
        _titleLabel.frame = CGRectMake(0, 0, _contentView.bounds.size.width, 20);
    }
    
    if (_microphoneView) {
        _microphoneView.frame = CGRectMake(5, 5, 24, 24);
    }
    
    if (_videoOffView) {
        _videoOffView.frame = _contentView.bounds;
    }
}

@end


@interface JCSplitScreenView ()<UIScrollViewDelegate>
{
    BOOL _reload;
}

@property (nonatomic, strong) NSMutableArray<JCSplitScreenViewCell *> *visibleItems;

@property (nonatomic, strong) NSMutableArray<JCSplitScreenViewCell *> *reloadItems;

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic,strong) NSMutableArray<UIImageView *> *imageViews;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;


@end


@implementation JCSplitScreenView

- (NSArray<JCSplitScreenViewCell *> *)visibleCells
{
    return _visibleItems;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initData];
    [self setupScrollView];
    [self setupImageViews];
    [self setupPageControl];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupScrollView];
        [self setupImageViews];
        [self setupPageControl];
    }
    return self;
}


- (JCSplitScreenViewCell *)dequeueReusableCellForIndex:(NSInteger)index
{
    JCSplitScreenViewCell *cell = nil;
    
    if (_reload && index < _visibleItems.count) {
        cell = _visibleItems[index];
    }
    
    if (!cell) {
        cell = [[JCSplitScreenViewCell alloc] init];
    }
    
    return cell;
}

- (void)reloadData
{
    _reload = YES;
    
    if (_dataSource) {
        _itemCount = [_dataSource numberOfItemsInSplitScreenView:self];
    }
    
    //    if (_itemCount > 4) {
    //        _itemCount = 4;
    //    }
    
    [_reloadItems removeAllObjects];
    
    for (NSInteger i = 0; i < _itemCount; i++) {
        if (_dataSource) {
            JCSplitScreenViewCell *cell = [_dataSource splitScreenView:self cellForItemAtIndex:i];
            
            if (cell) {
                [_reloadItems addObject:cell];
                //                [self addSubview:cell];
                [self.scrollView addSubview:cell];
            }
        }
    }
    
    //回收不显示的cell
    [self recycleCell];
    
    [self updateItemsFrame];
    [self updateScrollViewContentSize];
    self.scrollView.contentOffset = CGPointZero;
    [self updatePageControl];
    [self updateImageViews];
}

- (void)reloadItemAtIndex:(NSInteger)index
{
    _reload = YES;
    
    if (_dataSource) {
        [_dataSource splitScreenView:self cellForItemAtIndex:index];
    }
}

- (void)insertItemAtIndex:(NSInteger)index
{
    //    if (_itemCount > 3) {
    //        return;
    //    }
    
    _reload = NO;
    
    if (_dataSource) {
        _itemCount = [_dataSource numberOfItemsInSplitScreenView:self];
    }
    
    JCSplitScreenViewCell *cell = [_dataSource splitScreenView:self cellForItemAtIndex:index];
    
    if (cell) {
        [_reloadItems insertObject:cell atIndex:index];
        //        [self addSubview:cell];
        [self.scrollView addSubview:cell];
    }
    
    [self updateItemsFrame];
    [self updateScrollViewContentSize];
    [self updatePageControl];
    [self updateImageViews];
}

- (void)deleteItemAtIndex:(NSInteger)index
{
    if (_dataSource) {
        _itemCount = [_dataSource numberOfItemsInSplitScreenView:self];
    }
    
    if (index < _reloadItems.count) {
        JCSplitScreenViewCell *cell = _reloadItems[index];
        [cell removeFromSuperview];
        [_reloadItems removeObjectAtIndex:index];
    }
    
    [self updateItemsFrame];
    [self updateScrollViewContentSize];
    [self updatePageControl];
    [self updateImageViews];
}

- (void)updateItemsFrame
{
    [_visibleItems removeAllObjects];
    [_visibleItems addObjectsFromArray:_reloadItems];
    
    //    CGFloat w = self.bounds.size.width;
    //    CGFloat h = self.bounds.size.height;
    CGFloat w = self.bounds.size.width/2;
    CGFloat h = self.bounds.size.height/2;
    
    if (_itemCount == 1) {
        if (_visibleItems.count > 0) {
            UITapGestureRecognizer *doubleTapGesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
            doubleTapGesure.numberOfTapsRequired = 2;
            
            UIView *view = [_visibleItems firstObject];
            //            view.frame = self.bounds;
            view.frame = CGRectMake(0, 0, w, h);
            
            [view addGestureRecognizer:doubleTapGesure];
        }
    } else if (_itemCount == 2) {
        for (NSInteger i = 0; i < _itemCount; i++) {
            if (i < _visibleItems.count) {
                UITapGestureRecognizer *doubleTapGesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
                doubleTapGesure.numberOfTapsRequired = 2;
                
                UIView *view = [_visibleItems objectAtIndex:i];
                //                view.frame = CGRectMake(i * w / 2, 0, w / 2, h);
                view.frame = CGRectMake(i * w, 0, w, h);
                
                [view addGestureRecognizer:doubleTapGesure];
            }
        }
    } else if (_itemCount == 3) {
        for (int i = 0; i < _itemCount; i++) {
            if (i < _visibleItems.count) {
                UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
                doubleTapGesture.numberOfTapsRequired = 2;
                
                UIView *view = [_visibleItems objectAtIndex:i];
                if (i == 0) {
                    //                    view.frame = CGRectMake(0, 0, w, h / 2);
                    view.frame = CGRectMake(0, 0, w, h);
                } else if (i == 1) {
                    //                    view.frame = CGRectMake(0, h / 2, w / 2, h / 2);
                    view.frame = CGRectMake(w, 0, w, h);
                } else {
                    //                    view.frame = CGRectMake(w / 2, h / 2, w / 2, h / 2);
                    view.frame = CGRectMake(0, h, w, h);
                }
                [view addGestureRecognizer:doubleTapGesture];
            }
        }
    } else if (_itemCount == 4) {
        for (int i = 0; i < _itemCount; i++) {
            if (i < _visibleItems.count) {
                UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
                doubleTapGesture.numberOfTapsRequired = 2;
                
                UIView *view = [_visibleItems objectAtIndex:i];
                int row = i / 2; //行
                int line = i % 2; //列
                
                //                view.frame = CGRectMake(line * w / 2, row * h / 2, w / 2, h / 2);
                view.frame = CGRectMake(line * w, row * h, w, h);
                //                view.frame = CGRectMake(line * w, row * h, w*0.8, h*0.8);
                
                
                [view addGestureRecognizer:doubleTapGesture];
            }
        }
    } else {
        for (int i = 0; i < _itemCount; i++) {
            if (i < _visibleItems.count) {
                UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
                doubleTapGesture.numberOfTapsRequired = 2;
                
                UIView *view = [_visibleItems objectAtIndex:i];
                int page = i / 4; //页，每页4个
                int row = i % 4 / 2; //行
                int line = (i % 2) + (page * 2); //列
                // 0 1， 4 5， 8  9，
                // 2 3， 6 7，10 11，
                //                6,page = 1,row = 1,line = 0+2 = 2;
                //                11,page = 2,row = 1,line = 1+4 = 5;
                view.frame = CGRectMake(line * w, row * h, w, h);
                //                view.frame = CGRectMake(line * w, row * h, w*0.8, h*0.8);
                [view addGestureRecognizer:doubleTapGesture];
            }
        }
    }
}

- (void)initData
{
    _visibleItems = [NSMutableArray array];
    _reloadItems = [NSMutableArray array];
    _itemCount = 0;
}

- (void)recycleCell
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[JCSplitScreenViewCell class]]) {
            JCSplitScreenViewCell *cell = (JCSplitScreenViewCell *)view;
            if (![_reloadItems containsObject:cell]) {
                [cell removeFromSuperview];
            }
        }
    }
}

- (void)doubleTapGesture:(UITapGestureRecognizer *)recongizer
{
    JCSplitScreenViewCell *view = (JCSplitScreenViewCell *)recongizer.view;
    
    if (_dataSource) {
        [_dataSource didDoubleSelectRowAtIndex:[_reloadItems indexOfObject:view]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutImageViews];
    [self updateItemsFrame];
    [self layoutScrollView];
    [self updateScrollViewContentSize];
    [self layoutPageControl];
    
}

#pragma mark -

- (void)layoutImageViews {
    //    _itemCount = [_dataSource numberOfItemsInSplitScreenView:self];
    NSUInteger count = self.imageViews.count;
    
    CGFloat w = self.bounds.size.width/2;
    CGFloat h = self.bounds.size.height/2;
    
    //    for (int i = 0; i < _itemCount; i ++) {
    //        int row = i / 2; //行
    //        int line = i % 2; //列
    //        self.imageViews[i].frame = CGRectMake(line * w, row * h, w, h);
    //    }
    
    for (int i = 0; i < count; i ++) {
        int page = i / 4; //页，每页4个
        int row = i % 4 / 2; //行
        int line = (i % 2) + (page * 2); //列
        // 0 1， 4 5， 8  9，
        // 2 3， 6 7，10 11，
        // 6,page = 1,row = 1,line = 0+2 = 2;
        // 11,page = 2,row = 1,line = 1+4 = 5;
        self.imageViews[i].frame = CGRectMake(line * w, row * h, w, h);
    }
}

- (void)layoutScrollView {
    CGRect frame = self.scrollView.frame;
    frame  = self.frame;
    frame.origin = CGPointZero;
    self.scrollView.frame = frame;
}

- (void)layoutPageControl {
    float x = self.frame.size.width / 2;
    float y = self.frame.size.height - 10;
    self.pageControl.center = CGPointMake(x, y);
}

- (void)updateScrollViewContentSize {
    _itemCount = [_dataSource numberOfItemsInSplitScreenView:self];
    float w = self.frame.size.width;
    float h = self.frame.size.height;
//    self.scrollView.contentSize = CGSizeMake([self pageCount] * w, h);
    self.scrollView.contentSize = CGSizeMake([_dataSource numberOfItemsInSplitScreenView:self] * w, h);
//        self.scrollView.contentSize = CGSizeMake(w * 6, h);
    NSLog(@"%@, pageCount  = %@", NSStringFromSelector(_cmd), @([self pageCount]));
    NSLog(@"%@, contentSize  = %@", NSStringFromSelector(_cmd), NSStringFromCGSize(self.scrollView.contentSize));
}

- (void)updatePageControl {
    //    self.pageControl.numberOfPages = [self pageCount];
    self.pageControl.numberOfPages = [_dataSource numberOfItemsInSplitScreenView:self];
    self.pageControl.currentPage = self.scrollView.contentOffset.x / self.frame.size.width;
}

- (void)updateImageViews {
    _itemCount = [_dataSource numberOfItemsInSplitScreenView:self];
    
    int pageNeed = [self pageCount];
    int pageNow = self.imageViews.count/4;
    int pageDif = pageNow - pageNeed;
    
    if (pageDif == 0) {
        return;
    }
    else if (pageDif > 0) {
        // 多了。要减少
        NSUInteger count = pageDif * 4;
        for (NSUInteger i = 0; i < count; i ++) {
            [self.imageViews.lastObject removeFromSuperview];
            [self.imageViews removeObject:self.imageViews.lastObject];
        }
    }
    else {
        // 少了。要增加
        NSUInteger count = -pageDif * 4;
        for (NSUInteger i = 0; i < count; i ++) {
            UIImageView *iv = [self createImageView];
            [self.imageViews addObject:iv];
            [self.scrollView addSubview:iv];
            [self.scrollView sendSubviewToBack:iv];
        }
    }
    
    [self layoutImageViews];
}

- (UIImageView *)createImageView {
    UIImage *image = [UIImage imageNamed:@"meeting_pic"];
    UIImageView *iv = [[UIImageView alloc]initWithImage:image];
    iv.backgroundColor = [UIColor greenColor];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    return iv;
}

- (void)setupImageViews {
    self.imageViews = [NSMutableArray arrayWithCapacity:4];
    
    for (int i = 0; i < 4; i ++) {
        UIImageView *iv = [self createImageView];
        [self.imageViews addObject:iv];
        //        [self addSubview:iv];
        [self.scrollView addSubview:iv];
        [self.scrollView sendSubviewToBack:iv];
    }
}

- (void)setupScrollView {
    UIScrollView *sv = [UIScrollView new];
    [self addSubview:sv];
    self.scrollView = sv;
    
    sv.pagingEnabled = YES;
    sv.delegate = self;
    //    sv.backgroundColor = [UIColor blueColor];
    
}

- (void)setupPageControl {
    UIPageControl *pc = [UIPageControl new];
    [self addSubview:pc];
    self.pageControl = pc;
    
    pc.numberOfPages = 0;
    pc.hidesForSinglePage = YES;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView  == self.scrollView) {
        [self updatePageControl];
    }
}

#pragma mark -

- (NSUInteger)pageCount {
    NSUInteger pageNeed = _itemCount/4 + 1;
    if (_itemCount % 4 == 0) {
        pageNeed = _itemCount / 4;
    }
    return pageNeed;
}


@end


