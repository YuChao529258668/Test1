//
//  CGTagsView.m
//  CGSays
//
//  Created by zhu on 2016/11/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGTagsView.h"
#import "CGTagCollectionViewCell.h"
#import "CGTagAttribute.h"
#import "CGTagsEntity.h"

@interface CGTagsView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation CGTagsView

static NSString * const reuseIdentifier = @"CGTagCollectionViewCellId";

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self setup];
  }
  
  return self;
}

- (void)setup
{
  //初始化样式
  _tagAttribute = [CGTagAttribute new];
  
  _layout = [[CGTagCollectionViewFlowLayout alloc] init];
  [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return _tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  CGTagCollectionViewFlowLayout *layout = (CGTagCollectionViewFlowLayout *)collectionView.collectionViewLayout;
  CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
  
  CGTags *tag = self.tags[indexPath.item];
  CGRect frame = [tag.tagName boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_tagAttribute.titleSize]} context:nil];
  
  return CGSizeMake(frame.size.width + _tagAttribute.tagSpace, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  CGTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  cell.backgroundColor = _tagAttribute.normalBackgroundColor;
  cell.layer.borderColor = _tagAttribute.borderColor.CGColor;
  cell.layer.cornerRadius = _tagAttribute.cornerRadius;
  cell.layer.borderWidth = _tagAttribute.borderWidth;
  cell.titleLabel.textColor = _tagAttribute.textColor;
  cell.titleLabel.font = [UIFont systemFontOfSize:_tagAttribute.titleSize];
  
  CGTags *tag = self.tags[indexPath.item];
  NSString *title = tag.tagName;
  if (_key.length > 0) {
    cell.titleLabel.attributedText = [self searchTitle:title key:_key keyColor:_tagAttribute.keyColor];
  } else {
    cell.titleLabel.text = title;
  }
  
  for (CGTags *selectTag in self.selectedTags) {
    if ([selectTag.tagID isEqualToString:tag.tagID]) {
      cell.layer.borderColor = _tagAttribute.selectBorderColor.CGColor;
      cell.titleLabel.textColor = _tagAttribute.selectTextColor;
    }
  }
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  CGTagCollectionViewCell *cell = (CGTagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
  if ([self isSelectTagWithItem:indexPath.item]) {
    cell.backgroundColor = _tagAttribute.normalBackgroundColor;
    cell.layer.borderColor = _tagAttribute.borderColor.CGColor;
    cell.titleLabel.textColor = _tagAttribute.textColor;
    [self.selectedTags removeObjectAtIndex:[self deleteWithIndex:indexPath.item]];
    if (_completion) {
      _completion(self.selectedTags,indexPath.item);
    }
    return;
  }
  
  if (self.selectedTags.count < self.maxCount) {
    if(![self isSelectTagWithItem:indexPath.item]) {
        cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
        cell.layer.borderColor = _tagAttribute.selectBorderColor.CGColor;
        cell.titleLabel.textColor = _tagAttribute.selectTextColor;
        [self.selectedTags addObject:self.tags[indexPath.item]];
    }
    if (_completion) {
      _completion(self.selectedTags,indexPath.item);
    }
  }
}

- (BOOL)isSelectTagWithItem:(NSInteger)item{
  CGTags *selectTag = self.tags[item];
  BOOL isSelect = NO;
  for (CGTags *tag in self.selectedTags) {
    if ([selectTag.tagID isEqualToString:tag.tagID]) {
      isSelect = YES;
    }
  }
  return isSelect;
}

- (NSInteger)deleteWithIndex:(NSInteger)item{
  CGTags *selectTag = self.tags[item];
  NSInteger index = 0;
  for (int i=0; i<self.selectedTags.count; i++) {
    CGTags *tag = self.selectedTags[i];
    if ([selectTag.tagID isEqualToString:tag.tagID]) {
      index = i;
    }
  }
  return index;
}

// 设置文字中关键字高亮
- (NSMutableAttributedString *)searchTitle:(NSString *)title key:(NSString *)key keyColor:(UIColor *)keyColor {
  
  NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
  NSString *copyStr = title;
  
  NSMutableString *xxstr = [NSMutableString new];
  for (int i = 0; i < key.length; i++) {
    [xxstr appendString:@"*"];
  }
  
  while ([copyStr rangeOfString:key options:NSCaseInsensitiveSearch].location != NSNotFound) {
    
    NSRange range = [copyStr rangeOfString:key options:NSCaseInsensitiveSearch];
    
    [titleStr addAttribute:NSForegroundColorAttributeName value:keyColor range:range];
    copyStr = [copyStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:xxstr];
  }
  return titleStr;
}

- (void)reloadData {
  [self.collectionView reloadData];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _collectionView.frame = self.bounds;
}

#pragma mark - 懒加载

- (NSMutableArray *)selectedTags
{
  if (!_selectedTags) {
    _selectedTags = [NSMutableArray array];
  }
  return _selectedTags;
}

- (UICollectionView *)collectionView {
  if (!_collectionView) {
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[CGTagCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
  }
  
  _collectionView.collectionViewLayout = _layout;
  
  if (_layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
    //垂直
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
  } else {
    _collectionView.showsHorizontalScrollIndicator = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
  }
  
  _collectionView.frame = self.bounds;
  
  return _collectionView;
}

+ (CGFloat)getHeightWithTags:(NSArray *)tags layout:(CGTagCollectionViewFlowLayout *)layout tagAttribute:(CGTagAttribute *)tagAttribute width:(CGFloat)width
{
  CGFloat contentHeight;
  
  if (!layout) {
    layout = [[CGTagCollectionViewFlowLayout alloc] init];
  }
  
  if (tagAttribute.titleSize <= 0) {
    tagAttribute = [[CGTagAttribute alloc] init];
  }
  
  //cell的高度 = 顶部 + 高度
  contentHeight = layout.sectionInset.top + layout.itemSize.height;
  
  CGFloat originX = layout.sectionInset.left;
  CGFloat originY = layout.sectionInset.top;
  
  NSInteger itemCount = tags.count;
  
  for (NSInteger i = 0; i < itemCount; i++) {
    CGSize maxSize = CGSizeMake(width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [tags[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:tagAttribute.titleSize]} context:nil];
    
    CGSize itemSize = CGSizeMake(frame.size.width + tagAttribute.tagSpace, layout.itemSize.height);
    
    if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
      //垂直滚动
      if ((originX + itemSize.width + layout.sectionInset.right/2) > width) {
        originX = layout.sectionInset.left;
        originY += itemSize.height + layout.minimumLineSpacing;
        
        contentHeight += itemSize.height + layout.minimumLineSpacing;
      }
    }
    
    originX += itemSize.width + layout.minimumInteritemSpacing;
  }
  
  contentHeight += layout.sectionInset.bottom;
  return contentHeight;
}

@end
