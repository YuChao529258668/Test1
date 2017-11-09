//
//  HeadlineCatalogTableViewCell.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/26.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGInfoHeadEntity.h"

@protocol HeadlineCatalogTableViewCellDelegate <NSObject>

-(void)headlineCloseInfoCallBack:(CGInfoHeadEntity *)info cell:(UITableViewCell *)cell closeBtnY:(float)closeBtnY;

@end
@interface HeadlineCatalogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *line;

@property(nonatomic,retain)CGInfoHeadEntity *info;

@property(nonatomic,weak)id<HeadlineCatalogTableViewCellDelegate> delegate;

-(void)updateItem:(CGInfoHeadEntity *)info;

@end
