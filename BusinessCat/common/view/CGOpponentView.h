//
//  CGOpponentView.h
//  CGSays
//
//  Created by zhu on 2016/12/29.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CGOpponentType) {
  CGOpponentTypeLogin             = 0,
  CGOpponentTypeOrganization      = 1,
  CGOpponentTypeIntelligencer     = 2,
  CGOpponentTypeNullIntelligencer = 3,
  CGOpponentTypeEmpty             = 4
};
typedef void (^CGOpponentViewBlock)(NSInteger opponentType);

@interface CGOpponentView : UIView
@property (nonatomic, assign) CGOpponentType opponentType;
//初始化，使用block回调供外部进行相关的下一步操作
-(instancetype)initWithFrame:(CGRect)frame block:(CGOpponentViewBlock)block;

-(void)opponentType:(CGOpponentType)opponentType;
@end
