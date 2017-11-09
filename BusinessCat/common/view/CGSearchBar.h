//
//  CGSearchBar.h
//  CGSays
//
//  Created by mochenyang on 2017/3/29.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CGSearchBarBlock)(NSString *content);
typedef void (^CGSearchBarCalncel)(void);

@interface CGSearchBar : UISearchBar<UISearchBarDelegate>

-(instancetype)initWithFrame:(CGRect)frame block:(CGSearchBarBlock)block cancel:(CGSearchBarCalncel)cancel;

@end
