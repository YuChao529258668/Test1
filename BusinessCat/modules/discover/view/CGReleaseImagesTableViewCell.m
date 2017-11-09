//
//  CGReleaseImagesTableViewCell.m
//  CGSays
//
//  Created by zhu on 16/10/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGReleaseImagesTableViewCell.h"
#import "Gallop.h"
#import <UIImageView+WebCache.h>

@interface CGReleaseImagesTableViewCell()<LWAsyncDisplayViewDelegate>
@property (nonatomic, assign) NSInteger arrayCount;

@end

@implementation CGReleaseImagesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateLinkWithLinkInfo:(CGDiscoverLink *)link{
  UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 70)];
  [self.contentView addSubview:bgView];
  bgView.backgroundColor = CTCommonViewControllerBg;
  if ([CTStringUtil stringNotBlank:link.linkIcon]) {
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    [icon sd_setImageWithURL:[NSURL URLWithString:link.linkIcon]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:icon];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, bgView.frame.size.width-80, 50)];
    [bgView addSubview:label];
    label.numberOfLines = 0;
    label.textColor = [CTCommonUtil convert16BinaryColor:@"#333333"];
    label.font = [UIFont systemFontOfSize:15];
    label.text = link.linkTitle;
  }else{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, bgView.frame.size.width-20, 50)];
    [bgView addSubview:label];
    label.numberOfLines = 0;
    label.textColor = [CTCommonUtil convert16BinaryColor:@"#333333"];
    label.font = [UIFont systemFontOfSize:15];
    label.text = link.linkTitle;
  }
}

- (void)updateImagesUIWithArray:(NSMutableArray *)array{
  LWAsyncDisplayView *asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero];
  asyncDisplayView.delegate = self;
  LWLayout *layout = [[LWLayout alloc]init];
  self.arrayCount = array.count;
  NSInteger count = array.count == 9?array.count:(array.count+1);
  for (int i = 0; i<count; i++) {
    float buttonWidth = (SCREEN_WIDTH-45)/4;
    CGRect imageRect = CGRectMake(15+(i%4)*(buttonWidth+5), 10+(i/4)*(buttonWidth+10), buttonWidth, buttonWidth);

    LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
    imageStorage.frame = imageRect;
    imageStorage.localImageType = YES;
    imageStorage.clipsToBounds = YES;
    imageStorage.tag = i;
    if (i == count-1) {
      LWImageStorage* lineStorage = [[LWImageStorage alloc] init];
      lineStorage.frame = CGRectMake(0, imageStorage.frame.origin.y+imageStorage.frame.size.height+10, SCREEN_WIDTH, 0.5);
      lineStorage.backgroundColor = CTCommonLineBg;
      self.heigth = lineStorage.frame.origin.y+lineStorage.frame.size.height;
      [layout addStorage:lineStorage];
    }
    if (array.count>=9) {
      imageStorage.contents = array[i];
    }else{
      if (i<array.count) {
        imageStorage.contents = array[i];
      }else{
      imageStorage.contents = [UIImage imageNamed:@"achievements"];
      }
    }
    [layout addStorage:imageStorage];
  }
  asyncDisplayView.layout = layout;
  asyncDisplayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.heigth);
  [self.contentView addSubview:asyncDisplayView];
}

- (void)click:(UIButton *)sender{
  if (self.arrayCount>=9) {
    self.block(sender.tag,NO);
  }else{
    if (self.arrayCount==sender.tag) {
     self.block(sender.tag,YES);
    }else{
     self.block(sender.tag,NO);
    }
  }
}

- (void)didSelectedButtonIndex:(ClickAtIndexBlock)block{
  self.block = block;
}
//点击LWImageStorage
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
   didCilickedImageStorage:(LWImageStorage *)imageStorage
                     touch:(UITouch *)touch{
  NSInteger tag = imageStorage.tag;
  if (self.arrayCount>=9) {
    self.block(tag,NO);
  }else{
    if (self.arrayCount==tag) {
      self.block(tag,YES);
    }else{
      self.block(tag,NO);
    }
  }
}

@end
