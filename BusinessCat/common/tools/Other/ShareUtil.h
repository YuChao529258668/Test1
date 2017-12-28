//
//  ShareUtil.h
//  CGSays
//
//  Created by mochenyang on 2016/10/10.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CGSystemShare)(NSMutableArray *array);
@interface ShareUtil : NSObject

-(void)showShareMenuWithTitle:(NSString *)title desc:(NSString *)desc image:(id)image url:(NSString *)url view:(UIView *)view;

-(void)showShareMenuWithTitle:(NSString *)title desc:(NSString *)desc isqrcode:(BOOL)isqrcode image:(id)image url:(NSString *)url block:(CGSystemShare)success;
@property (nonatomic, assign) NSInteger isDownFire;
@end
