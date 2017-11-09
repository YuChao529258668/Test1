//
//  JCBaseViewController.m
//  UltimateShow
//
//  Created by young on 16/12/15.
//  Copyright © 2016年 young. All rights reserved.
//

#import "JCBaseViewController.h"

@interface JCBaseViewController ()

@end

@implementation JCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tapGR.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGR];
}

- (void)tap
{
    [self.view endEditing:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
