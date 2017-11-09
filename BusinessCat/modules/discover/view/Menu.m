




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/







#import "Menu.h"
#import "Gallop.h"

@interface Menu ()

@property (nonatomic,assign) BOOL show;
@property (nonatomic,assign) BOOL isShowing;
@property (nonatomic, assign) NSInteger type;
@end

@implementation Menu


#pragma mark - LifeCycle
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.clipsToBounds = YES;
    self.show = NO;
    self.isShowing = NO;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.likeButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.awardButton];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self setNeedsDisplay];
  if (self.type) {
    self.awardButton.hidden = NO;
    self.awardButton.frame = CGRectMake(0, 0, 70, self.bounds.size.height);
    self.likeButton.frame = CGRectMake(70, 0, 70, self.bounds.size.height);
    self.commentButton.frame = CGRectMake(140, 0, 70, self.bounds.size.height);
  }else{
    self.awardButton.hidden = YES;
    self.likeButton.frame = CGRectMake(0, 0, 70, self.bounds.size.height);
    self.commentButton.frame = CGRectMake(70, 0, 70, self.bounds.size.height);
  }
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  UIBezierPath* beizerPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
  [RGBA(76, 81, 84, 0.95) setFill];
  [beizerPath fill];
  CGContextRef context = UIGraphicsGetCurrentContext();
  if (self.type) {
    CGContextMoveToPoint(context, rect.size.width/3, 5.0f);
    CGContextAddLineToPoint(context, rect.size.width/3, rect.size.height - 5.0f);
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, rect.size.width/3*2, 5.0f);
    CGContextAddLineToPoint(context, rect.size.width/3*2, rect.size.height - 5.0f);
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
  }else{
    CGContextMoveToPoint(context, rect.size.width/2, 5.0f);
    CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height - 5.0f);
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
  }
  CGContextStrokePath(context);
}


#pragma mark - Actions
- (void)clickedMenu {
  if (!self.isShowing) {
    self.isShowing = YES;
    if (self.show) {
      [self menuHide];
    }
    else {
      [self menuShow:self.type];
    }
  }
}


- (void)menuShow:(NSInteger)type {
  self.type = type;
  CGFloat width = self.type==1?210:140;
    __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.2f
                        delay:0.0f
       usingSpringWithDamping:0.7
        initialSpringVelocity:0.0f
                      options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        weakSelf.frame = CGRectMake(weakSelf.frame.origin.x - width,
                                                weakSelf.frame.origin.y,
                                                width,
                                                34.0f);
                      } completion:^(BOOL finished) {
                        weakSelf.show = YES;
                        weakSelf.isShowing = NO;
                      }];
  
}

- (void)menuHide {
    __weak typeof(self) weakSelf = self;
  CGFloat width = self.type==1?210:140;
  [UIView animateWithDuration:0.3f
                        delay:0.0f
       usingSpringWithDamping:0.7f
        initialSpringVelocity:0.0f
                      options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        weakSelf.frame = CGRectMake(weakSelf.frame.origin.x + width,
                                                weakSelf.frame.origin.y,
                                                0.0f,
                                                34.0f);
                      } completion:^(BOOL finished) {
                        weakSelf.frame = CGRectMake(weakSelf.frame.origin.x,
                                                weakSelf.frame.origin.y,
                                                0.0f,
                                                34.0f);
                        weakSelf.show = NO;
                        weakSelf.isShowing = NO;
                      }];
}

#pragma mark - Getter & Setter
-(void)setEntity:(CGSourceCircleEntity *)entity{
  if (_entity != entity) {
    _entity = entity;
  }
  if (self.entity.isPraise) {
    [_likeButton setTitle:@" 取消" forState:UIControlStateNormal];
  }else {
    [_likeButton setTitle:@"  赞" forState:UIControlStateNormal];
  }
  if (self.entity.isPay) {
    [_awardButton setTitle:@" 已赏" forState:UIControlStateNormal];
    [_awardButton setUserInteractionEnabled:NO];
    _awardButton.alpha = 0.7;
  }else{
    [_awardButton setTitle:@" 赏" forState:UIControlStateNormal];
    _awardButton.alpha = 1;
    [_awardButton setUserInteractionEnabled:YES];
  }
}

- (LikeButton *)likeButton {
  if (_likeButton) {
    return _likeButton;
  }
  _likeButton = [LikeButton buttonWithType:UIButtonTypeCustom];
  [_likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_likeButton setImage:[UIImage imageNamed:@"likewhite"] forState:UIControlStateNormal];
  [_likeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
  return _likeButton;
}

- (LikeButton *)awardButton {
  if (_awardButton) {
    return _awardButton;
  }
  _awardButton = [LikeButton buttonWithType:UIButtonTypeCustom];
  [_awardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_awardButton setTitle:@"  赏" forState:UIControlStateNormal];
  [_awardButton setImage:[UIImage imageNamed:@"Team_circle_Reward"] forState:UIControlStateNormal];
  [_awardButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
  return _awardButton;
}

- (UIButton *)commentButton {
  if (_commentButton) {
    return _commentButton;
  }
  _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_commentButton setTitle:@" 评论" forState:UIControlStateNormal];
  [_commentButton setImage:[UIImage imageNamed:@"Team_circle_comment"] forState:UIControlStateNormal];
  [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
  return _commentButton;
}
@end
