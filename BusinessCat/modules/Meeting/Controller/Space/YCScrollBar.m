//
//  YCScrollBar.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/25.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCScrollBar.h"

@interface YCScrollBar()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSString *> *titles;

@end


@implementation YCScrollBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    @property (nonatomic) CGFloat minimumLineSpacing;
//    @property (nonatomic) CGFloat minimumInteritemSpacing;
//    @property (nonatomic) CGSize itemSize;
//    @property (nonatomic) CGSize estimatedItemSize NS_AVAILABLE_IOS(8_0); // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
//    @property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
//    @property (nonatomic) CGSize headerReferenceSize;
//    @property (nonatomic) CGSize footerReferenceSize;
//    @property (nonatomic) UIEdgeInsets sectionInset;

    
    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    cv.dataSource = self;
    cv.delegate = self;
    self.collectionView = cv;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"" forIndexPath:indexPath];
    return cell;
}


@end
