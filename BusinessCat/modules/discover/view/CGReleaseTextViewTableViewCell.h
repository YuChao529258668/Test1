//
//  CGReleaseTextViewTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGReleaseTextViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@end
