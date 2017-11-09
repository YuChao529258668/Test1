//
//  ServerListViewController.m
//  UltimateShow
//
//  Created by young on 16/12/16.
//  Copyright © 2016年 young. All rights reserved.
//

#import "ServerListViewController.h"
#import "SettingManager.h"
#import "ServerAddressCell.h"
#import "ServerInfoViewController.h"

@interface ServerListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_server;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ServerListViewController

- (instancetype)init
{
    self = [super initWithNibName:@"ServerListViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _server = [SettingManager getAllServerAddress];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"server address", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"add", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addServer)];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ServerAddressCell" bundle:nil] forCellReuseIdentifier:@"ServerAddressCellId"];
}

- (void)addServer
{
    ServerInfoViewController *vc = [[ServerInfoViewController alloc] init];
    vc.type = 0;
    [vc setAddServer:^(NSString *server, BOOL isDefault) {
        [SettingManager addServerAddress:server isDefault:isDefault];
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteServer:(NSUInteger)index
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"sure to delete", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SettingManager removeServerAddressAtIndex:index];
        [_tableView reloadData];
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pushToeditServer:(NSUInteger)index
{
    ServerInfoViewController *vc = [[ServerInfoViewController alloc] init];
    vc.type = 1;
    vc.model = _server[index];
    [vc setUpdateServer:^(NSString *server, BOOL isDefault) {
        [SettingManager updateServerAddressAtIndex:index server:server isDefault:isDefault];
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _server.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServerAddressModel *model = _server[indexPath.section];
    ServerAddressCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ServerAddressCellId" forIndexPath:indexPath];
    
    cell.tag = indexPath.section;
    cell.serverLabel.text = model.serverAddress;
    cell.defaultButton.selected = model.isDefaultServer;
    
    [cell setButtonAction:^(NSUInteger tag) {
        ServerAddressModel *tModel = _server[tag];
        if (tModel.isDefaultServer) {
            return;
        }
        [SettingManager updateServerAddressAtIndex:tag server:tModel.serverAddress isDefault:YES];
        [_tableView reloadData];
        
    }];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"delete", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteServer:indexPath.section];
    }];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"edit", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self pushToeditServer:indexPath.section];
        [tableView setEditing:NO animated:NO];
    }];
    
    return @[deleteAction, editAction];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 35 : 18;
}

@end
