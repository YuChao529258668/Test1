//
//  AppDelegate.h
//  CGSays
//
//  Created by mochenyang on 16/8/9.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMMobClick/MobClick.h"
#import "CTBaseNaviController.h"
#import "CTRootViewController.h"

//@interface AppDelegate : UIResponder <UIApplicationDelegate>
@interface AppDelegate : IMAAppDelegate

//@property (strong, nonatomic) UIWindow *window; // IMAAppDelegate定义有了

@property(nonatomic,retain)CTBaseNaviController *navi;
@property(nonatomic,retain)CTRootViewController *rootController;

// 腾讯云
- (void)pushToChatViewControllerWith:(IMAUser *)user;

@end

