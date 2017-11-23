//
//  CGMeetingListCell.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGMeetingListCell.h"
#import "CGUsersCollectionViewCell.h"

// 日期样式
#define kCGMeetingListCellDateStyle @"yyyy-MM-dd hh:mm"


@interface CGMeetingListCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@end


@implementation CGMeetingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configCollectionView];
    [self.button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCGMeetingListCellBtnClickNotification object:self];
}


#pragma mark - Setter

- (void)setCountLabelTextWithNumber:(NSUInteger)count {
    self.countLabel.text = [NSString stringWithFormat:@"%@人参会", [NSString stringWithFormat:@"%ld", count]];
}

- (void)setTimeLabelTextWithTimeInterval:(NSString *)interval {
    NSTimeInterval stamp = interval.doubleValue / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = kCGMeetingListCellDateStyle;
    self.timeLabel.text = [f stringFromDate:date];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self.collectionView reloadData];
}

- (void)setImageName:(NSString *)name {
    self.imageView.image = [UIImage imageNamed:name];
}

#pragma mark - Config

- (void)configCollectionView {
    _collectionView.dataSource = self;
//    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"CGUsersCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CGUsersCollectionViewCell"];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGMeetingListCellButtonModell *model = self.btnModels[indexPath.item];
    NSString *title = self.titles[indexPath.item];
    CGUsersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGUsersCollectionViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = title;
    return cell;
}


#pragma mark -

+ (float)cellHeight {
    return 150;
}

@end
