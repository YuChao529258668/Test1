//
//  ServerAddressCell.h
//  UltimateShow
//
//  Created by young on 16/12/17.
//  Copyright © 2016年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

//设置默认
@property (nonatomic, copy) void (^buttonAction) (NSUInteger tag);

@end
