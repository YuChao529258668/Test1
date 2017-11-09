//
//  EntryViewController.m
//  UltimateShow
//
//  Created by young on 16/12/15.
//  Copyright © 2016年 young. All rights reserved.
//

#import "EntryViewController.h"
#import "ConferenceViewController.h"
#import "RoomViewController.h"
#import "SettingsViewController.h"
#import "SettingManager.h"
#import "BadgeView.h"
#import "Toast.h"

//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface EntryViewController () <UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@end

@implementation EntryViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#ifdef WLUS
    self.logoImageView.hidden = YES;
#endif
    
    self.title = NSLocalizedString(@"back", nil);
    self.navigationController.delegate = self;
    self.numberTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.nickNameTextField.delegate = self;
        
    [_joinButton setBackgroundImage:[UIImage colorWithRed:1.0f green:143.0f blue:156.0f] forState:UIControlStateHighlighted];
    [_joinButton setBackgroundImage:[UIImage colorWithRed:128.0f green:222.0f blue:234.0f] forState:UIControlStateDisabled];
    
    [self checkPrivacy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(privacyDidRequest) name:@"PrivacyDidRequestAccessNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkPrivacy
{
    if ([SettingManager privacyNeedToShowBadge]) {
        BadgeView *badge = [BadgeView badgeViewInView:_settingButton];
        [_settingButton addSubview:badge];
    }
}

- (void)privacyDidRequest
{
    [self checkPrivacy];
}

#pragma mark - Button action

- (IBAction)setting:(id)sender {
    SettingsViewController *settingsVc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:settingsVc animated:YES];
}

- (IBAction)join:(id)sender {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[_numberTextField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![_numberTextField.text isEqualToString:filtered])
    {
        [Toast showWithText:NSLocalizedString(@"Please enter the letters or conference number", nil) bottomOffset:64];
        return;
    }
    
    if (_numberTextField.text.length >= 15)
    {
        [Toast showWithText:NSLocalizedString(@"Please enter the number 15 meeting", nil) bottomOffset:64];
        return;
    }
    
    NSString *displayName = _nickNameTextField.text;
    if ([displayName isEqualToString:@""]) {
        displayName = [[UIDevice currentDevice] name];
    }
//    ConferenceViewController *confVc = [[ConferenceViewController alloc] initWithNibName:@"ConferenceViewController" bundle:[NSBundle mainBundle]];
//    confVc.roomId = _numberTextField.text;
//    confVc.displayName = displayName;
//    [self presentViewController:confVc animated:YES completion:nil];
    
    RoomViewController *roomVc = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
    roomVc.roomId = _numberTextField.text;
    roomVc.displayName = displayName;
    [self presentViewController:roomVc animated:YES completion:nil];

}

- (IBAction)numberChanged:(id)sender {
    NSString *number = _numberTextField.text;
    _joinButton.enabled = number.length;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:[viewController isKindOfClass:[self class]] animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
