//
//  CGUserHeaderCollectionViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGUserHeaderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *textlabel;
@property (weak, nonatomic) IBOutlet UIImageView *line;
- (void)updateData:(NSString *)str;
@end
