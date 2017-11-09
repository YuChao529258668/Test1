//
//  PreviewViewController.h
//  UltimateShow
//
//  Created by young on 17/3/27.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCPreviewViewController : UIViewController

- (void)reloadPreviewWithUserId:(NSString *)userId;

- (void)stopShowPreview;

@end
