//
//  CGDetailTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/8/21.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iv;
-(void)updateDetailString:(NSString *)url;
@end
