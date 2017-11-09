//
//  CGUserCompanyAttestationTableViewCell.h
//  CGSays
//
//  Created by zhu on 16/10/24.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtomClickIndexBlock)(NSInteger tag);
@interface CGUserCompanyAttestationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *figureBtn;
@property (weak, nonatomic) IBOutlet UIButton *certificateBtn;
@property (nonatomic,copy) ButtomClickIndexBlock buttonBlock;
- (void)didSelectedButtonIndex:(ButtomClickIndexBlock)block;
@end
