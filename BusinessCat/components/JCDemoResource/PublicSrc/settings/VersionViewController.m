//
//  VersionViewController.m
//  UltimateShow
//
//  Created by young on 16/12/20.
//  Copyright © 2016年 young. All rights reserved.
//

#import "VersionViewController.h"


NSString * const kLibName = @"kLibName";
NSString * const kVersion = @"kVersion";

@interface VersionViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_versionData;
}
@end

@implementation VersionViewController

- (instancetype)init
{
    self = [super initWithNibName:@"VersionViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"version", nil);
    
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [dict objectForKey:@"CFBundleDisplayName"];
    NSString *version = [dict objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [dict objectForKey:@"CFBundleVersion"];
    if (build.length > 3) {
        build = [build substringFromIndex:3];
    }
    NSString *string = [[NSString alloc] initWithFormat:@"%@(%@)", version, build];
    
    _versionData = @[
                     @{kLibName : appName,
                       kVersion : string},
                     
                     @{kLibName : @"Avatar",
                       kVersion : [self stringFromConstChar:Mtc_GetAvatarVersion()]},
                     
                     @{kLibName : @"Girffe",
                       kVersion : [self stringFromConstChar:Mtc_GetGiraffeVersion()]},
                     
                     @{kLibName : @"Grape",
                       kVersion : [self stringFromConstChar:Zmf_GetVersion()]},
                     
                     @{kLibName : @"Lemon",
                       kVersion : [self stringFromConstChar:Mtc_GetLemonVersion()]},
                     
                     @{kLibName : @"JSM",
                       kVersion : [self stringFromConstChar:Mtc_GetJsmVersion()]},
                     
                     @{kLibName : @"Melon",
                       kVersion : [self stringFromConstChar:Mtc_GetMelonVersion()]}
                     
                     ];

                     
}

- (NSString *)stringFromConstChar:(const char *)value
{
    if (!value) {
        return @"";
    }
    return [NSString stringWithUTF8String:value];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _versionData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _versionData[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = dict[kLibName];
    cell.detailTextLabel.text = dict[kVersion];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *title = nil;
    
    if (section == 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *year = [dateFormatter stringFromDate:[NSDate date]];
        title = [[NSString  alloc] initWithFormat:@"© %@ Juphoon. All rights reserved.", year];
    }
    return title;
}
@end
