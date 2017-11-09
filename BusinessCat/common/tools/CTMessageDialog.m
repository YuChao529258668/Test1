//
//  CTMessageDialog.m
//  CGSays
//
//  Created by mochenyang on 11-11-15.
//  Copyright 2011年 gdcattsoft.com. All rights reserved.
//

#import "CTMessageDialog.h"

@interface AlertViewDelegateObject : NSObject<UIAlertViewDelegate>

@property (nonatomic, assign) NSInteger selectButtonIndex;

@end

@implementation AlertViewDelegateObject

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.selectButtonIndex = buttonIndex;
}

@end

@implementation CTMessageDialog

+ (UIAlertView *)show:(NSString *)msg title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
    return alert;
}

+ (UIAlertView *)show:(NSString *)msg
{
    return [CTMessageDialog show:msg title:@"温馨提示"];
}

+ (UIAlertView *)confirm:(NSString *)msg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    [alert show];
    return alert;
}

+ (BOOL)yesOrNoWithMsg:(NSString *)msg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    AlertViewDelegateObject *delegate = [[AlertViewDelegateObject alloc] init];
    alert.delegate = delegate;
    [alert show];
    
    while (1)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
        // 一秒钟alert没显示时不在等待,因为主线程和web线程已死锁; 跳出循环释放Web线程锁；
        if (!alert.visible)
            break;
    }
    
    return delegate.selectButtonIndex != alert.cancelButtonIndex;
}

+ (void)toast:(NSString *)msg
{
    [self toast:msg duration:3.0f];
}

+ (void)toast:(NSString *)msg duration:(float)duration
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    int alertShowDate = 0;
    // alert显示时一直循环等待响应
    while (1)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
        // 一秒钟alert没显示时不在等待,因为主线程和web线程已死锁; 跳出循环释放Web线程锁；
        if (++alertShowDate > duration*100)
            break;
    }
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
}

@end
