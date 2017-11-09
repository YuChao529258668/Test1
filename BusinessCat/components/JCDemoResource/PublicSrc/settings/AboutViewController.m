//
//  AboutViewController.m
//  UltimateShow
//
//  Created by young on 16/12/20.
//  Copyright © 2016年 young. All rights reserved.
//

#import "AboutViewController.h"
#import "VersionViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logo;


@property (weak, nonatomic) IBOutlet UIButton *versionButton;

@end

@implementation AboutViewController

- (instancetype)init
{
    self = [super initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#ifdef WLUS
    self.logo.hidden = YES;
#endif
    
    self.title = NSLocalizedString(@"about", nil);
    NSString *version = [NSString stringWithFormat:@"v %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [_versionButton setTitle:version forState:UIControlStateNormal];
}

- (IBAction)showVersion:(id)sender {
    VersionViewController *versionVc = [[VersionViewController alloc] init];
    [self.navigationController pushViewController:versionVc animated:YES];
}

@end
