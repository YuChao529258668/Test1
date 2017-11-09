//
//  CGEnterpriseMemberTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CGEnterpriseMemberTableViewCellBlock)(NSString *gradeId,NSString *gradeName);

typedef void(^CGEnterpriseMemberTableViewCellClaimBlock)(void);

@interface CGEnterpriseMemberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
-(void)updateTitleArray:(NSMutableArray *)titleArray listArray:(NSMutableArray *)listArray block:(CGEnterpriseMemberTableViewCellBlock)block claimBlock:(CGEnterpriseMemberTableViewCellClaimBlock)claimBlock;
@end
