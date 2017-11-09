//
//  SplitScreenViewController.m
//  UltimateShow
//
//  Created by young on 17/1/12.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCSplitScreenViewController.h"
#import "JCSplitScreenView.h"
#import "JCSplitScreenReformer.h"

@interface SplitScreenViewController ()

@property (nonatomic, strong) JCSplitScreenView *splitScreenView;
@property (nonatomic, strong) JCSplitScreenReformer *screenReformer;

@end

@implementation SplitScreenViewController

#pragma mark - Setter and Getter

- (JCSplitScreenView *)splitScreenView
{
    if (!_splitScreenView) {
        _splitScreenView = [[JCSplitScreenView alloc] initWithFrame:self.view.bounds];
        _splitScreenView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _splitScreenView;
}

- (JCSplitScreenReformer *)screenReformer
{
    if (!_screenReformer) {
        _screenReformer = [[JCSplitScreenReformer alloc] init];
    }
    return _screenReformer;
}

#pragma mark - Life cycle

- (void)dealloc
{
    NSLog(@"SplitScreenViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.splitScreenView];
    
    [self.screenReformer bindSplitScreenView:self.splitScreenView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public function

- (void)reloadSplitSreenView
{
    if (_screenReformer) {
        [_screenReformer reload];
    }
}

- (void)stopShowSplitSreenView
{
    if (_screenReformer) {
        [_screenReformer stop];
    }
}


#pragma mark - private function

@end
