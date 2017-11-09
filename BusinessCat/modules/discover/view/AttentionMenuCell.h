//
//  AttentionMenuCell.h
//  CGSays
//
//  Created by mochenyang on 2016/10/22.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttentionMenuCellDelegate <NSObject>

-(void)callbackAttentionToH5:(NSString *)path;

@end

@interface AttentionMenuCell : UITableViewCell

@property(nonatomic,assign)id<AttentionMenuCellDelegate> delegate;

@end
