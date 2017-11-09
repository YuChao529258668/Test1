//
//  SearchProductTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/9.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"
#import "CGSearchKeyWordEntity.h"

@protocol SearchProductTableViewCellDelegate <NSObject>

-(void)headlineCloseInfoCallBack:(CGInfoHeadEntity *)info cell:(UITableViewCell *)cell closeBtnY:(float)closeBtnY;

@end

@interface SearchProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenter;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIImageView *EXPImageView;
@property(nonatomic,retain)CGInfoHeadEntity *info;
@property (nonatomic, strong) CGSearchKeyWordEntity *keyInfo;

@property(nonatomic,weak)id<SearchProductTableViewCellDelegate> delegate;

-(void)updateItem:(CGInfoHeadEntity *)info action:(NSString *)acion type:(int)type typeID:(NSString *)typeID groupId:(NSString *)groupId isAttention:(BOOL)isAttention subjectId:(NSString *)subjectId;

-(void)updatekeyWordItem:(CGSearchKeyWordEntity *)info action:(NSString *)acion type:(int)type typeID:(NSString *)typeID groupId:(NSString *)groupId isAttention:(BOOL)isAttention subjectId:(NSString *)subjectId;
@end
