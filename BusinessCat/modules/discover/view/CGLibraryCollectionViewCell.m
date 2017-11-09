//
//  CGLibraryCollectionViewCell.m
//  CGSays
//
//  Created by zhu on 2017/1/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGLibraryCollectionViewCell.h"
#import "LWProgeressHUD.h"

@interface CGLibraryCollectionViewCell ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (nonatomic, copy) ClickAtIndexBlock block;
@end

@implementation CGLibraryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.sv.delegate = self;
  self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    // Initialization code
  UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
  self.sv.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  self.imageView.frame = self.sv.bounds;
  [self.imageView addGestureRecognizer:tapGesture];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
  
  return self.imageView;
  
}

-(void)didSelectBlock:(ClickAtIndexBlock)block{
  self.block = block;
}

-(void)Actiondo{
  self.block();
}

-(void)updateString:(NSString *)url{
  self.sv.zoomScale =1;
  LWProgeressHUD *progressHUD = [LWProgeressHUD showHUDAddedTo:self.contentView];
  __weak typeof(self) weakSelf = self;
  [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    dispatch_async(dispatch_get_main_queue(), ^{
      progressHUD.progress = receivedSize/(float)expectedSize;
    });
  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    [LWProgeressHUD hideAllHUDForView:weakSelf.contentView];
    CGSize imageSize = image.size;
    CGFloat imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
    if (imageSize.height>image.size.width&&imageViewH>SCREEN_HEIGHT) {
      weakSelf.imageView.frame =CGRectMake(0, 0, SCREEN_WIDTH, imageViewH);
      weakSelf.imageView.center = CGPointMake(SCREEN_WIDTH * 0.5, imageViewH * 0.5);
      weakSelf.sv.contentSize = CGSizeMake(0, imageViewH);
    }else{
//      CGFloat imageViewW = self.bounds.size.height * (imageSize.width / imageSize.height);
//      weakSelf.imageView.frame =CGRectMake(0, 0, imageViewW, SCREEN_HEIGHT);
//      weakSelf.imageView.center = CGPointMake(imageViewW * 0.5, SCREEN_HEIGHT * 0.5);
      weakSelf.imageView.frame = weakSelf.sv.bounds;
      weakSelf.sv.contentSize = CGSizeMake(0, 0);
    }
  }];
}

-(void)updateDetailString:(NSString *)url{
  LWProgeressHUD *progressHUD = [LWProgeressHUD showHUDAddedTo:self.contentView];
  __weak typeof(self) weakSelf = self;
  [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    dispatch_async(dispatch_get_main_queue(), ^{
      progressHUD.progress = receivedSize/(float)expectedSize;
    });
  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    [LWProgeressHUD hideAllHUDForView:weakSelf.contentView];
  }];
}
@end
