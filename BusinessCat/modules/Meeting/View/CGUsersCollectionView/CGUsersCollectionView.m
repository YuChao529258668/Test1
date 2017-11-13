//
//  CGUsersCollectionView.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUsersCollectionView.h"

@implementation CGUsersCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
    }
    return self;
}

- (UICollectionViewLayout *)createLayout {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    @property (nonatomic) CGFloat minimumLineSpacing;
//    @property (nonatomic) CGFloat minimumInteritemSpacing;
//    @property (nonatomic) CGSize itemSize;
//    @property (nonatomic) CGSize estimatedItemSize NS_AVAILABLE_IOS(8_0); // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
//    @property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
//    @property (nonatomic) CGSize headerReferenceSize;
//    @property (nonatomic) CGSize footerReferenceSize;
//    @property (nonatomic) UIEdgeInsets sectionInset;
    return layout;

    
}



//+ (instancetype)usersCollectionView {
//    CGUsersCollectionView *cv = [[CGUsersCollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
//    return cv;
//}





@end
