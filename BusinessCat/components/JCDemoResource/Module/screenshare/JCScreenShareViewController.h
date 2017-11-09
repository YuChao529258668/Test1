//
//  ScreenShareViewController.h
//  UltimateShow
//
//  Created by Nathan Zheng on 2017/3/24.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCScreenShareProtocol.h"

@interface JCScreenShareViewController : UIViewController

@property (nonatomic, weak) id<JCScreenShareDelegate> delegate;

- (void)reloadScreenShare;

- (void)stopScreenShare;

@end
