//
//  CGLibraryCollectionViewCell.h
//  CGSays
//
//  Created by zhu on 2017/1/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickAtIndexBlock)();
@interface CGLibraryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
-(void)didSelectBlock:(ClickAtIndexBlock)block;
-(void)updateString:(NSString *)url;
-(void)updateDetailString:(NSString *)url;
@end
