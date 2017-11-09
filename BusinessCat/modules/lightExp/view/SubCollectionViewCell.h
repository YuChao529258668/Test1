//
//  SubCollectionViewCell.h
//  https://github.com/shengpeng3344/PagingCollectionView
//
//  Created by tangmi on 16/6/8.
//  Copyright © 2016年 tangmi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *reusableCell = @"SubCollectionViewCell";

static NSString *editStateChanged = @"editStateChanged";

static NSString *deleteCell = @"deleteCellNotification";


@class SubCollectionViewCell;

@protocol SubCollectionViewCellDelegate <NSObject>

@optional

- (void)modelCellButton:(SubCollectionViewCell *)cell;  //

@end

@interface SubCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak)   id<SubCollectionViewCellDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) id data;
@property (weak, nonatomic) IBOutlet UIImageView *isExpIV;

//- (void)shake;
//
//- (void)stopShake;

@end
