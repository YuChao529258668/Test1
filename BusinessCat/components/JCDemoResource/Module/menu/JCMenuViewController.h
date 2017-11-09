//
//  MenuViewController.h
//  UltimateShow
//
//  Created by 沈世达 on 17/4/10.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCMenuView.h"

@protocol MenuDelegate <NSObject>

- (void)showVideo:(JCMenuView *)menuView;

- (void)showDoodle:(JCMenuView *)menuView;

- (void)showShareScreen;

@end

@interface JCMenuViewController : UIViewController

@property (nonatomic, weak) id<MenuDelegate> delegate;

@property (nonatomic, strong) JCMenuView *menuView;

- (void)closeMenu;

- (UIColor *)colorWithHexString:(NSString *)color;

@end
