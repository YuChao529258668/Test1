//
//  OpponentTableViewCell.h
//  CGSays
//
//  Created by zhu on 2016/12/30.
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
typedef void (^CGOpponentCellBlock)(NSInteger opponentType);

@interface OpponentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
-(void)opponentType:(CGOpponentType)opponentType block:(CGOpponentCellBlock)block;
@end
