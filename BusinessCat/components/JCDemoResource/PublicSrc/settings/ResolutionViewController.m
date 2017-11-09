//
//  ResolutionViewController.m
//  UltimateShow
//
//  Created by young on 16/12/19.
//  Copyright © 2016年 young. All rights reserved.
//

#import "ResolutionViewController.h"
#import "SettingManager.h"


@interface ResolutionViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ResolutionViewController

- (instancetype)init
{
    self = [super initWithNibName:@"ResolutionViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"resolution", nil);
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_resolution) {
        _resolution();
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *str = nil;
    if (indexPath.row == 0) {
        str = @"640x360";
    } else if (indexPath.row == 1) {
        str = @"1280x720";
    }
    
    cell.textLabel.text = str;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose"]];
    imageView.frame = CGRectMake(0, 0, 24, 24);
    cell.accessoryView = imageView;
    
    if (indexPath.row == 0) {
        imageView.hidden = ([SettingManager getResolution] != Resolution360);
    } else {
        imageView.hidden = ([SettingManager getResolution] != Resolution720);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Resolution value = Resolution360;
    if (indexPath.row == 1) {
        value = Resolution720;
    }
    [SettingManager setResolution:value];
    [tableView reloadData];

}
@end
