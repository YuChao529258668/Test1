//
//  UserNickNameTableViewCell.h
//  CGSays
//
//  Created by zhu on 2017/3/3.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserNickNameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *bindingText;
@property (weak, nonatomic) IBOutlet UIButton *bindingButton;
@end
