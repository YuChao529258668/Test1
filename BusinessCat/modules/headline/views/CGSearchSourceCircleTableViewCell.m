//
//  CGSearchSourceCircleTableViewCell.m
//  CGSays
//
//  Created by zhu on 2016/11/24.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGSearchSourceCircleTableViewCell.h"
#import "GallopUtils.h"
#import "LWImageStorage.h"
#import "LWAlertView.h"

@interface CGSearchSourceCircleTableViewCell()<LWAsyncDisplayViewDelegate>
@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;
@property (nonatomic,strong) UIView* line;

@end

@implementation CGSearchSourceCircleTableViewCell

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.asyncDisplayView];
    [self.contentView addSubview:self.line];
  }
  return self;
}

#pragma mark - LWAsyncDisplayViewDelegate

//额外的绘制
- (void)extraAsyncDisplayIncontext:(CGContextRef)context size:(CGSize)size isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled {
  if (!isCancelled()) {
    CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextSetLineWidth(context, 0.2f);
    CGContextSetStrokeColorWithColor(context,RGBA(220.0f, 220.0f, 220.0f, 1).CGColor);
    CGContextStrokePath(context);
    if (self.cellLayout.entity.linkType>0) {
      CGContextAddRect(context, self.cellLayout.websitePosition);
      CGContextSetFillColorWithColor(context, CTCommonViewControllerBg.CGColor);
      CGContextFillPath(context);
    }
  }
}
//点击LWImageStorage
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
   didCilickedImageStorage:(LWImageStorage *)imageStorage
                     touch:(UITouch *)touch{
  NSInteger tag = imageStorage.tag;
  if ([imageStorage.identifier isEqualToString:@"image"]) {
    if (self.clickedImageCallback) {
      if (self.clickedImageCallback) {
        self.clickedImageCallback(self,tag);
      }
    }
  }
  if ([imageStorage.identifier isEqualToString:@"avatar"]) {
    if (self.clickedAvatarCallback) {
      self.clickedAvatarCallback(self);
    }
  }
}

//点击LWTextStorage
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
    didCilickedTextStorage:(LWTextStorage *)textStorage
                  linkdata:(id)data {
  if ([data isKindOfClass:[CGDiscoverLink class]]){
    self.linkCallback(self,data);
  }else if ([data isKindOfClass:[NSString class]]) {
    //折叠Cell
    if ([data isEqualToString:@"close"]) {
      if (self.clickedCloseCellCallback) {
        self.clickedCloseCellCallback(self);
      }
    }
    //展开Cell
    else if ([data isEqualToString:@"open"]) {
      if (self.clickedOpenCellCallback) {
        self.clickedOpenCellCallback(self);
      }
    }
  }
}

#pragma mark -


- (void)layoutSubviews {
  [super layoutSubviews];
  self.asyncDisplayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.cellLayout.cellHeight);
  self.line.frame = self.cellLayout.lineRect;
}

- (void)setCellLayout:(SearchCellLayout *)cellLayout {
  if (_cellLayout != cellLayout) {
    _cellLayout = cellLayout;
    self.asyncDisplayView.layout = self.cellLayout;
  }
}

- (LWAsyncDisplayView *)asyncDisplayView {
  if (!_asyncDisplayView) {
    _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero];
    _asyncDisplayView.delegate = self;
  }
  return _asyncDisplayView;
}


- (UIView *)line {
  if (_line) {
    return _line;
  }
  _line = [[UIView alloc] initWithFrame:CGRectZero];
  _line.backgroundColor = RGBA(220.0f, 220.0f, 220.0f, 1.0f);
  return _line;
}

@end
