//
//  CapacityViewController.m
//  UltimateShow
//
//  Created by young on 16/12/19.
//  Copyright © 2016年 young. All rights reserved.
//

#import "CapacityViewController.h"

@interface CapacityViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@end

@implementation CapacityViewController

- (instancetype)init
{
    self = [super initWithNibName:@"CapacityViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"capacity", nil);
    
    _numberTextField.text = [NSString stringWithFormat:@"%ld", (long)_number];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(done)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_numberTextField becomeFirstResponder];
}

- (void)done
{
    NSInteger num = [_numberTextField.text integerValue];
    if (num < 4 || num > 16) {
        return;
    }
    
    if (_capacity) {
        _capacity(num);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
