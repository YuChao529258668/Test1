//
//  JoinModeViewController.m
//  UltimateShow
//
//  Created by young on 16/12/19.
//  Copyright © 2016年 young. All rights reserved.
//

#import "JoinModeViewController.h"
#import "SettingManager.h"

@interface JoinModeViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation JoinModeViewController

- (instancetype)init
{
    self = [super initWithNibName:@"JoinModeViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"join mode", nil);
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_joinMode) {
        _joinMode();
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *str = nil;
    if (indexPath.row == 0) {
        str = NSLocalizedString(@"video", nil);
    } else if (indexPath.row == 1) {
        str = NSLocalizedString(@"audio", nil);
    } else {
        str = @"relay";
    }
    
    cell.textLabel.text = str;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose"]];
    imageView.frame = CGRectMake(0, 0, 24, 24);
    cell.accessoryView = imageView;
    
    if (indexPath.row == 0) {
        imageView.hidden = ([SettingManager getJoinMode] != JoinModeValueVideo);
    } else if (indexPath.row == 1) {
        imageView.hidden = ([SettingManager getJoinMode] != JoinModeValueAudio);
    } else {
        imageView.hidden = ([SettingManager getJoinMode] != JoinModeValueRelay);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JoinModeValue value = JoinModeValueVideo;
    if (indexPath.row == 1) {
        value = JoinModeValueAudio;
    } else if (indexPath.row == 2) {
        value = JoinModeValueRelay;
    }
    [SettingManager setJoinMode:value];
    
    [tableView reloadData];
    
}
@end
