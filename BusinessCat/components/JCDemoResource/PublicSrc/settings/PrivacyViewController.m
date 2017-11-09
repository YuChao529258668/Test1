//
//  PrivacyViewController.m
//  UltimateShow
//
//  Created by young on 16/12/18.
//  Copyright © 2016年 young. All rights reserved.
//

#import "PrivacyViewController.h"
#import "BadgeView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface PrivacyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PrivacyViewController

- (instancetype)init
{
    self = [super initWithNibName:@"PrivacyViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"privacy", nil);
}

- (void)privacySwitch:(UISwitch *)sender
{
    NSString *mediaType = nil;
    if (sender.tag == 0) { //麦克风
        mediaType = AVMediaTypeAudio;
    } else if (sender.tag == 1) { //相机
        mediaType = AVMediaTypeVideo;
    } else {
        return;
    }
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (status == AVAuthorizationStatusNotDetermined) {
        if (![sender isOn]) return;
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PrivacyDidRequestAccessNotification" object:nil];
            });
            
        }];
    } else {
        [_tableView reloadData];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    
//    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
//    [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey: bundleId} completionHandler:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *mediaType = nil;
    if (indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"microphone", nil);
        mediaType = AVMediaTypeAudio;
    } else {
        cell.textLabel.text = NSLocalizedString(@"camera", nil);
        mediaType = AVMediaTypeVideo;
    }
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    UISwitch *switchView = [[UISwitch alloc] init];
    switchView.tag = indexPath.section;
    switchView.on = (status == AVAuthorizationStatusAuthorized);
    
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        BadgeView *badge = [BadgeView badgeViewInTableViewCell:cell];
        [cell.contentView addSubview:badge];
    }
    
    [switchView addTarget:self action:@selector(privacySwitch:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchView;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *warnStr = nil;
    if (section == 0) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (status != AVAuthorizationStatusAuthorized) {
           warnStr = NSLocalizedString(@"microphone privacy unauthorized", nil);
        }
        
    } else if (section == 1) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status != AVAuthorizationStatusAuthorized) {
            warnStr = NSLocalizedString(@"camera privacy unauthorized", nil);
        }
    
    }
    return warnStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 35 : 18;
}

@end
