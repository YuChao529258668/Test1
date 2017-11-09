//
//  UINavigationController+Autorotate.m
//  CGSays
//
//  Created by zhu on 2017/1/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "UINavigationController+Autorotate.h"

@implementation UINavigationController (Autorotate)

- (BOOL)shouldAutorotate
{
  return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
  return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
