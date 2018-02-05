//
//  YCJoinShareController.m
//  BusinessCat
//
//  Created by 余超 on 2018/2/1.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCJoinShareController.h"
#import "CGUserHelpCatePageViewController.h"
#import "YCSpaceBiz.h"

@interface YCJoinShareController ()
@property (weak, nonatomic) IBOutlet UIImageView *choseIV;
@property (weak, nonatomic) IBOutlet UILabel *shareL;
@property (nonatomic, assign) BOOL isAgree;

@end

@implementation YCJoinShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 下划线
    NSString *textStr = self.shareL.text;
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    self.shareL.attributedText = attribtStr;
    
}

- (IBAction)clickAgreeBtn:(id)sender {
    self.isAgree = !self.isAgree;
    if (self.isAgree) {
        self.choseIV.image = [UIImage imageNamed:@"personnel_icon_highlight"];
    } else {
        self.choseIV.image = [UIImage imageNamed:@"personnel_icon_normal"];
    }
}

- (IBAction)clickJoinBtn:(id)sender {
    if (!self.isAgree) {
        [CTToast showWithText:@"请同意协议"];
    } else {
        __weak typeof(self) weakself = self;
        [YCSpaceBiz joinShareWithType:self.type companyID:self.companyID doShare:1 Success:^{
            [CTToast showWithText:@"加入成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
        } fail:^(NSError *error) {
            
        }];
    }
}

- (IBAction)clickProtocolBtn:(id)sender {
    CGUserHelpCatePageViewController *vc = [[CGUserHelpCatePageViewController alloc]init];
    vc.title = @"共享会议协议";
    vc.pageId = @"f22d19f8-a664-47c9-d47e-11a13d17f120";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickQuitBtn:(id)sender {
    __weak typeof(self) weakself = self;
    [YCSpaceBiz joinShareWithType:self.type companyID:self.companyID doShare:0 Success:^{
        [CTToast showWithText:@"退出成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSError *error) {
        
    }];
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
