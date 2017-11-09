//
//  MenuViewController.m
//  UltimateShow
//
//  Created by 沈世达 on 17/4/10.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCMenuViewController.h"

@interface JCMenuViewController () <MenuViewDelegate>

@end

@implementation JCMenuViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (JCMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[JCMenuView alloc] init];
        _menuView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _menuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.menuView];
    self.menuView.frame = self.view.bounds;
    self.menuView.delegte = self;
    
//    self.menuView.buttons[0].layer.borderWidth = 3;
//    self.menuView.buttons[0].layer.cornerRadius = 2;
//    self.menuView.buttons[0].layer.borderColor = [self colorWithHexString:@"#03a9f4"].CGColor;
}

- (void)menuView:(JCMenuView *)menuView clickButton:(UIButton *)button buttonType:(MenuButtonType)buttonType
{    
    if (!_delegate) {
        return;
    }
    
    for (int i = 0 ; i < menuView.buttons.count; i++) {
        UIButton *selectButton = menuView.buttons[i];
        if (button == selectButton) {
            selectButton.layer.borderWidth = 3;
            selectButton.layer.cornerRadius = 2;
            selectButton.layer.borderColor = [self colorWithHexString:@"#03a9f4"].CGColor;
        } else {
            selectButton.layer.borderWidth = 0;
            selectButton.layer.cornerRadius = 0;
        }
    }
    
    if (buttonType == MenuButtonTypeVideo) {
        [_delegate showVideo:menuView];
    } else if (buttonType == MenuButtonTypeDoodle) {
        [_delegate showDoodle:menuView];
    } else if (buttonType == MenuButtonTypeShare) {
        [_delegate showShareScreen];
    }
    [self closeMenu];
}

- (void)closeMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
