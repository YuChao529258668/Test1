//
//  ScreenShareViewController.m
//  UltimateShow
//
//  Created by Nathan Zheng on 2017/3/24.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCScreenShareViewController.h"
#import "JCScreenShareReformer.h"

@interface JCScreenShareViewController ()

@property (nonatomic, strong) UIView *renderView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) JCScreenShareReformer *screenShareReformer;

@end

@implementation JCScreenShareViewController

- (UIView *)renderView
{
    if (!_renderView) {
        _renderView = [[UIView alloc] initWithFrame:self.view.bounds];
        _renderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _renderView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 180) / 2, 10, 180, 20)];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _nameLabel.font = [UIFont systemFontOfSize:13.0];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (JCScreenShareReformer *)screenShareReformer
{
    if (!_screenShareReformer) {
        _screenShareReformer = [[JCScreenShareReformer alloc] init];
    }
    return _screenShareReformer;
}

- (void)setDelegate:(id<JCScreenShareDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        self.screenShareReformer.delegate = _delegate;
    }
}

- (void)dealloc
{
    NSLog(@"ScreenShareViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.renderView];
    [self.view addSubview:self.nameLabel];
    
    [self.screenShareReformer bindRenderView:self.renderView];
    [self.screenShareReformer bindNameLabel:self.nameLabel];
}

- (void)reloadScreenShare
{
    if (_screenShareReformer) {
        [_screenShareReformer reload];
    }
}

- (void)stopScreenShare
{
    if (_screenShareReformer) {
        [_screenShareReformer stop];
    }
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
