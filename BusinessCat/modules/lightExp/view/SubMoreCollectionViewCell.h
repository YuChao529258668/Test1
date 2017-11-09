//
//  SubMoreCollectionViewCell.h
//  CGSays
//
//  Created by zhu on 2016/11/30.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubMoreCollectionViewCell;

@protocol SubMoreCollectionViewCellDelegate <NSObject>

@optional

- (void)modelCellButton:(SubMoreCollectionViewCell *)cell;  //

@end

static NSString *reusMoreableCell = @"SubMoreCollectionViewCell";

@interface SubMoreCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *icons;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak)   id<SubMoreCollectionViewCellDelegate>  delegate;
@end
