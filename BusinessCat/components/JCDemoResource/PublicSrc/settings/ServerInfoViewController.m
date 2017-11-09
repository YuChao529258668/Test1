//
//  ServerInfoViewController.m
//  UltimateShow
//
//  Created by young on 16/12/18.
//  Copyright © 2016年 young. All rights reserved.
//

#import "ServerInfoViewController.h"
#import "Toast.h"

@interface ServerInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *serverTextField;
@property (nonatomic, strong) UISwitch *defaultSwitch;

@end

@implementation ServerInfoViewController

- (UITextField *)serverTextField
{
    if (!_serverTextField) {
        _serverTextField = [[UITextField alloc] init];
        _serverTextField.placeholder = NSLocalizedString(@"please click this input server address", nil);
        _serverTextField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _serverTextField;
}

- (UISwitch *)defaultSwitch
{
    if (!_defaultSwitch) {
        _defaultSwitch = [[UISwitch alloc] init];
    }
    return _defaultSwitch;
}

- (instancetype)init
{
    self = [super initWithNibName:@"ServerInfoViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveServer)];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_serverTextField becomeFirstResponder];
}

- (void)saveServer
{
    NSString *server = _serverTextField.text;
    if (server.length == 0) {
        [Toast showWithText:NSLocalizedString(@"please enter the server address", nil) topOffset:230 duration:1];
        return;
    }
    
    if (_type == 0) {
        if (_addServer) {
            _addServer(server, _defaultSwitch.isOn);
        }
    } else if (_type == 1) {
        if (_updateServer) {
            BOOL value = _defaultSwitch.isOn;
            if (_type == 1 && _model.isDefaultServer) {
                value = YES;
            }
            
            _updateServer(server, value);
        }
    }
    
    [Toast showWithText:NSLocalizedString(@"save successful", nil) topOffset:230 duration:1];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    
}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 2;
    //编辑默认地址时，隐藏设置默认选项
    if (_type == 1 && _model.isDefaultServer) {
        count = 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.serverTextField];
        
        NSArray *hCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_serverTextField]-20-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_serverTextField)];
        [cell.contentView addConstraints:hCons];
        
        NSArray *vCons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_serverTextField]-0-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_serverTextField)];
        [cell.contentView addConstraints:vCons];
        
        if (_type == 1) {
            _serverTextField.text = _model.serverAddress;
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = NSLocalizedString(@"set default", nil);
        cell.accessoryView = self.defaultSwitch;
    }
    return cell;
}

@end
