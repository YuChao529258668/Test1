//
//  YCShareProfitsController.m
//  BusinessCat
//
//  Created by 余超 on 2018/2/10.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCShareProfitsController.h"
#import "CGHorrolView.h"
#import "CGUserOrganizaJoinEntity.h"
#import "CGUserHelpCatePageViewController.h"
#import "YCSpaceBiz.h"

@interface YCShareProfitsController ()
@property (retain, nonatomic) CGHorrolView *organizaHeaderView;
@property (nonatomic, strong) NSMutableArray *headViewEntitys;
@property (nonatomic, assign) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet UIView *topView;
//@property (nonatomic, strong) ShareUtil *shareUtil;

@property (weak, nonatomic) IBOutlet UIImageView *choseIV;
@property (weak, nonatomic) IBOutlet UILabel *shareL;
@property (nonatomic, assign) BOOL isAgree;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end

@implementation YCShareProfitsController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"共享收益";
    [self.topView addSubview:self.organizaHeaderView];
    [self.organizaHeaderView setSelectIndex:(int)self.currentIndex];
    
    // 下划线
    NSString *textStr = self.shareL.text;
    if (!textStr) {
        textStr = @"共享会议协议";
    }
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    self.shareL.attributedText = attribtStr;
    
}
//
////初始化大类控件
//-(CGHorrolView *)organizaHeaderView{
//    __weak typeof(self) weakSelf = self;
//    if(!_organizaHeaderView || _organizaHeaderView.array.count <= 0){
//
//        _organizaHeaderView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) array:self.headViewEntitys finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
//            weakSelf.currentIndex = index;
//
//        }];
//    }
//    return _organizaHeaderView;
//}
//
//-(NSMutableArray *)headViewEntitys{
//    if(!_headViewEntitys){
//        _headViewEntitys = [NSMutableArray array];
//        if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
//            for(int i=0;i<[ObjectShareTool sharedInstance].currentUser.companyList.count;i++){
//                CGUserOrganizaJoinEntity *local = [ObjectShareTool sharedInstance].currentUser.companyList[i];
//                if (local.companyType !=4) {
//                    CGHorrolEntity *organiza = [[CGHorrolEntity alloc]initWithRolId:local.companyId rolName:local.companyName sort:i];
//                    if (i == 0) {
//
//                    }
//                    if ([self.companyID isEqualToString:local.companyId]) {
//                        self.currentIndex = i;
//
//                    }
//                    [_headViewEntitys addObject:organiza];
//                }
//            }
//        }
//    }
//    return _headViewEntitys;
//}


#pragma mark -
//
//- (IBAction)clickAgreeBtn:(id)sender {
//    self.isAgree = !self.isAgree;
//    if (self.isAgree) {
//        self.choseIV.image = [UIImage imageNamed:@"personnel_icon_highlight"];
//    } else {
//        self.choseIV.image = [UIImage imageNamed:@"personnel_icon_normal"];
//    }
//}
//
//- (IBAction)clickJoinBtn:(id)sender {
//    if (!self.isAgree) {
//        [CTToast showWithText:@"请同意协议"];
//    } else {
//        __weak typeof(self) weakself = self;
//        // 0:公司 1：用户
//        [YCSpaceBiz joinShareWithType:self.type companyID:self.companyID doShare:1 Success:^{
//            [CTToast showWithText:@"加入成功"];
//            [weakself.navigationController popViewControllerAnimated:YES];
//        } fail:^(NSError *error) {
//
//        }];
//    }
//}
//
//- (IBAction)clickProtocolBtn:(id)sender {
//    CGUserHelpCatePageViewController *vc = [[CGUserHelpCatePageViewController alloc]init];
//    vc.title = @"共享会议协议";
//    vc.pageId = @"f22d19f8-a664-47c9-d47e-11a13d17f120";
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (IBAction)dismiss:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
