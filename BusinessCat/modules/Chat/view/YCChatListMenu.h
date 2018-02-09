//
//  YCChatListMenu.h
//  BusinessCat
//
//  Created by 余超 on 2018/2/3.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCChatListMenu : UIView
@property (nonatomic, strong) UIView *pointToView;
@property (nonatomic, assign) CGFloat menuY;

- (void)addButtonTarget:(id)target selector:(SEL)aSelector buttonIndex:(NSInteger)index;

@end
