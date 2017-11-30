//
//  SplitScreenView.h
//  SplitScreen
//
//  Created by young on 16/12/9.
//  Copyright © 2016年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCSplitScreenView;
@class JCSplitScreenViewCell;

@protocol SplitScreenViewDataSource <NSObject>

- (NSInteger)numberOfItemsInSplitScreenView:(JCSplitScreenView *)splitScreenView;

- (JCSplitScreenViewCell *)splitScreenView:(JCSplitScreenView *)splitScreenView cellForItemAtIndex:(NSInteger)index;

- (void)didDoubleSelectRowAtIndex:(NSInteger)index;

@end


@interface JCSplitScreenViewCell : UIView

@property (nonatomic, readonly, strong) UIView *contentView;

//渲染视频的view
@property (nonatomic, readonly, strong) UIView *renderView;

//视频关闭
@property (nonatomic, readonly, strong) UIImageView *videoOffView;

@property (nonatomic, readonly, strong) UILabel *titleLabel;

//麦克风
@property (nonatomic, readonly, strong) UIImageView *microphoneView;

//用于标记是否已经渲染
@property (nonatomic, copy) NSString *markStringId;

@end


@interface JCSplitScreenView : UIView

@property (nonatomic, weak) id<SplitScreenViewDataSource> dataSource;

@property (nonatomic, readonly, strong) NSArray<JCSplitScreenViewCell *> *visibleCells;

- (JCSplitScreenViewCell *)dequeueReusableCellForIndex:(NSInteger)index;

- (void)reloadData;

- (void)reloadItemAtIndex:(NSInteger)index;

- (void)insertItemAtIndex:(NSInteger)index;

- (void)deleteItemAtIndex:(NSInteger)index;
@end



