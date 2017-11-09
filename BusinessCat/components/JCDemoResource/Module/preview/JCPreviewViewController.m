//
//  PreviewViewController.m
//  UltimateShow
//
//  Created by young on 17/3/27.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCPreviewViewController.h"
#import "JCVideoDisplayView.h"
#import "JCPreviewReformer.h"

@interface JCPreviewViewController ()

@property (nonatomic, strong) JCVideoDisplayView *preview;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) JCPreviewReformer *reformer;

@end

@implementation JCPreviewViewController

- (JCVideoDisplayView *)preview
{
    if (!_preview) {
        _preview = [[JCVideoDisplayView alloc] initWithFrame:self.view.bounds];
        _preview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _preview;
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

- (JCPreviewReformer *)reformer
{
    if (!_reformer) {
        _reformer = [[JCPreviewReformer alloc] init];
    }
    return _reformer;
}

- (void)dealloc
{
    NSLog(@"PreviewViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.preview];
    [self.view addSubview:self.nameLabel];
    
    [self.reformer bindPreview:self.preview];
    [self.reformer bindNameLabel:self.nameLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadPreviewWithUserId:(NSString *)userId
{
    if (_reformer) {
        [_reformer reloadWithUserId:userId];
    }
}

- (void)stopShowPreview
{
    if (_reformer) {
        [_reformer stop];
    }
}

@end
