//
//  SettingsViewController.m
//  UltimateShow
//
//  Created by young on 16/12/16.
//  Copyright © 2016年 young. All rights reserved.
//

#import "SettingsViewController.h"
#import "ResolutionViewController.h"
#import "CapacityViewController.h"
#import "JoinModeViewController.h"
#import "ServerListViewController.h"
#import "PrivacyViewController.h"
#import "AboutViewController.h"
#import "ContactUsViewController.h"
#import "SettingManager.h"
#import "BadgeView.h"


enum {
//    SettingResolution,
//    SettingCapacity,
    SettingJoinMode,
//    SettingCdn,
    SettingServer,
    SettingPrivacy,
    SettingAbout,
    SettingContact
};

NSString * const kTitle = @"kTitle";
NSString * const kContent = @"kContent";
NSString * const kType = @"kType"; //0

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_settingData;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SettingsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"setting", nil);
    
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(privacyDidRequest) name:@"PrivacyDidRequestAccessNotification" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
//    NSString *resolution = [self resolutionFromSettings];
//    
//    NSString *capacity = [[NSString alloc] initWithFormat:@"%ld", (long)[SettingManager getCapacity]];
    
    NSString *joinMode = [self joinModeFromSettings];
    
    _settingData = @[
//                      @[@{kTitle : NSLocalizedString(@"resolution", nil), kContent : resolution, kType : @0}],
//                      @[@{kTitle : NSLocalizedString(@"capacity", nil), kContent : capacity, kType : @0}],
                      @[@{kTitle : NSLocalizedString(@"join mode", nil), kContent : joinMode, kType : @0}],
//                      @[@{kTitle : NSLocalizedString(@"cdn push", nil), kContent : @"", kType : @1}],
                      @[@{kTitle : NSLocalizedString(@"server address", nil), kContent : @"", kType : @0}],
                      @[@{kTitle : NSLocalizedString(@"privacy", nil), kContent : @"", kType : @0}],
                      @[@{kTitle : NSLocalizedString(@"about", nil), kContent : @"", kType : @0}],
                      @[@{kTitle : NSLocalizedString(@"contact us", nil), kContent : @"", kType : @0}]
                      ];
}

- (NSString *)resolutionFromSettings
{
    NSString *resolution = @"640x360";
    if ([SettingManager getResolution] == Resolution720) {
        resolution = @"1280x720";
    }
    return resolution;
}

- (NSString *)joinModeFromSettings
{
    NSString *joinMode = NSLocalizedString(@"video", nil);
    if ([SettingManager getJoinMode] == JoinModeValueAudio) {
        joinMode = NSLocalizedString(@"audio", nil);
    } else if ([SettingManager getJoinMode] == JoinModeValueRelay) {
        joinMode = @"relay";
    }
    return joinMode;
}

- (void)privacyDidRequest
{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)cdnSwitch:(UISwitch *)sender
{
    [SettingManager setCdnEnable:sender.isOn];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _settingData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *item = _settingData[section];
    return item.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *item = _settingData[indexPath.section];
    NSDictionary *dict = item[indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellid"];
    cell.textLabel.text = dict[kTitle];
    cell.detailTextLabel.text = dict[kContent];
    
    if ([dict[kType] intValue] == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        UISwitch *cdnSwitch = [[UISwitch alloc] init];
        cdnSwitch.on = [SettingManager getCdnEnable];
        [cdnSwitch addTarget:self action:@selector(cdnSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = cdnSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 5 && [SettingManager privacyNeedToShowBadge]) {
        BadgeView *badgeView = [BadgeView badgeViewInTableViewCell:cell];
        [cell.contentView addSubview:badgeView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (section == SettingResolution) { //分辨率
//        ResolutionViewController *resolutionVc = [[ResolutionViewController alloc] init];
//        [resolutionVc setResolution:^{
//            UITableViewCell *rCell = [tableView cellForRowAtIndexPath:indexPath];
//            if (rCell) {
//                rCell.detailTextLabel.text = [self resolutionFromSettings];
//            }
//        }];
//        [self.navigationController pushViewController:resolutionVc animated:YES];
//    } else if (section == SettingCapacity) { //参会人数
//        CapacityViewController *capacityVc = [[CapacityViewController alloc] init];
//        capacityVc.number = [SettingManager getCapacity];
//        [capacityVc setCapacity:^(NSUInteger number) {
//            [SettingManager setCapacity:number];
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)number];
//        }];
//        [self.navigationController pushViewController:capacityVc animated:YES];
//    } else
    if (section == SettingJoinMode) { //参会方式
        JoinModeViewController *joinModeVc = [[JoinModeViewController alloc] init];
        [joinModeVc setJoinMode:^{
            UITableViewCell *jCell = [tableView cellForRowAtIndexPath:indexPath];
            if (jCell) {
                jCell.detailTextLabel.text = [self joinModeFromSettings];
            }

        }];
        [self.navigationController pushViewController:joinModeVc animated:YES];
    }
//    else if (section == SettingCdn) { //CDN推流
//        
//    }
    else if (section == SettingServer) { //服务器地址
        ServerListViewController *serverListVc = [[ServerListViewController alloc] init];
        [self.navigationController pushViewController:serverListVc animated:YES];
    } else if (section == SettingPrivacy) { //隐私
        PrivacyViewController *privacyVc = [[PrivacyViewController alloc] init];
        [self.navigationController pushViewController:privacyVc animated:YES];
    } else if (section == SettingAbout) { //关于
        AboutViewController *aboutVc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVc animated:YES];
    } else if (section == SettingContact) { //联系我们
        ContactUsViewController *contactUsVc = [[ContactUsViewController alloc] init];
        [self.navigationController pushViewController:contactUsVc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 35 : 0.01;
}

@end
