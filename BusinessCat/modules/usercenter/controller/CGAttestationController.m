//
//  CGAttestationController.m
//  CGSays
//
//  Created by mochenyang on 2017/3/21.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGAttestationController.h"
#import "CGHorrolView.h"
#import "CGCompanyDao.h"
#import "CGUserOrganizaJoinEntity.h"
#import "CGUserCompanyAttestationEntity.h"
#import "QiniuBiz.h"
#import "CGUserCenterBiz.h"
#import "CGUserHelpCatePageViewController.h"
#import <TZImagePickerController.h>

@interface CGAttestationController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate>

@property (retain, nonatomic) CGHorrolView *organizaHeaderView;

@property(nonatomic,retain)NSMutableArray *organzias;
@property(nonatomic,retain)NSMutableArray *headViewEntitys;

@property(nonatomic,retain)UIImage *selectImg;
@property(nonatomic,retain)UIImageView *picture;//附加照片
@property(nonatomic,retain)UITextField *organizaName;//组织简称
@property(nonatomic,retain)UITextField *username;//用户名
@property(nonatomic,retain)UITextField *legalname;//法人名
@property(nonatomic,retain)UITextField *verifyCode;//法人名

@property(nonatomic,retain)UIButton *verifyCodeBtn;
@property(nonatomic,retain)UIButton *protocolBtn;

@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,assign)int timeCount;

@property(nonatomic,assign)int currentIndex;

@property(nonatomic,retain)UIButton *uploadBtn;//提交按钮

@property(nonatomic,retain)UILabel *authInfoTitle;
@property(nonatomic,retain)UILabel *authInfoDesc;

@property(nonatomic,retain)CGUserCenterBiz *biz;

@property(nonatomic,assign)BOOL isClickToDial;//是否已点击拨打电话

@property(nonatomic,assign)BOOL hideOrganizaNaviView;//是否隐藏顶部的组织导航栏

@end

#define TimerExpireCount 60

@implementation CGAttestationController

-(CGUserCenterBiz *)biz{
    if(!_biz){
        _biz = [[CGUserCenterBiz alloc]init];
    }
    return _biz;
}

-(NSMutableArray *)organzias{
    if(!_organzias){
        _organzias = [NSMutableArray array];
        if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
            for(CGUserOrganizaJoinEntity *local in [ObjectShareTool sharedInstance].currentUser.companyList){
                if(local.companyState == 0){//0-未认证，1-已认证 2-认证中 3-认证不通过
                    [_organzias addObject:local];
                }else if (local.companyState == 1 || local.companyState == 2){
                    if([CTStringUtil stringNotBlank:local.authInfo.additional]){//自己认证的组织才有值，才显示出来
                        [_organzias addObject:local];
                    }
                }else if (local.companyState == 3){
                    [_organzias addObject:local];
                }
            }
        }
        if(_organzias.count > 0){
            for(CGUserOrganizaJoinEntity *local in _organzias){
                if(!local.authInfo.organizaName){
                    local.authInfo.organizaName = local.companyName;
                }
                if(!local.authInfo.name){
                    local.authInfo.name = [ObjectShareTool sharedInstance].currentUser.username;
                }
            }
        }
    }
    return _organzias;
}

-(NSMutableArray *)headViewEntitys{
    if(!_headViewEntitys){
        _headViewEntitys = [NSMutableArray array];
        if(self.organzias && self.organzias.count > 0){
            for(int i=0;i<self.organzias.count;i++){
                CGUserOrganizaJoinEntity *local = self.organzias[i];
                CGHorrolEntity *organiza = [[CGHorrolEntity alloc]initWithRolId:local.companyId rolName:local.companyFullName sort:i];
                [_headViewEntitys addObject:organiza];
            }
        }
    }
    return _headViewEntitys;
}


-(void)reset{
    [self.organizaHeaderView removeFromSuperview];
    self.organizaHeaderView = nil;
    self.organzias = nil;
    self.headViewEntitys = nil;
    self.selectImg = nil;
    [self.timer invalidate];
    self.timer = nil;
    self.timeCount = 0;
    self.verifyCodeBtn.enabled = YES;
    [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:self.organizaHeaderView];
    self.tableview.frame = CGRectMake(0, CGRectGetMaxY(self.organizaHeaderView.frame), self.tableview.frame.size.width, SCREEN_HEIGHT - CGRectGetMaxY(self.organizaHeaderView.frame));
    [self.organizaHeaderView setSelectIndex:self.currentIndex];
    [self.tableview reloadData];
}

-(void)refresh:(CGUserOrganizaJoinEntity *)organiza{

}

-(instancetype)initWithOrganiza:(CGUserOrganizaJoinEntity *)organiza block:(CGUserAttestationBlock)block{
    self  = [super init];
    if(self){
        if(organiza){
            self.hideOrganizaNaviView = YES;
            if(self.organzias && self.organzias.count > 0){
                for(int i=0;i<self.organzias.count;i++){
                    CGUserOrganizaJoinEntity *local = self.organzias[i];
                    if(organiza.companyType == 2){//传进来的是学校
                        if([organiza.classId isEqualToString:local.classId]){
                            self.currentIndex = i;
                            break;
                        }
                    }else{//非学校
                        if([organiza.companyId isEqualToString:local.companyId]){
                            self.currentIndex = i;
                            break;
                        }
                    }
                }
            }
        }
        self.block = block;
    }
    return self;
}

-(UITextField *)organizaName{
    if(!_organizaName){
        _organizaName = [self createText:@"请输入组织简称" keyboardType:UIKeyboardTypeDefault];
    }
    return _organizaName;
}

-(UITextField *)username{
    if(!_username){
        _username = [self createText:@"请输入你的名字" keyboardType:UIKeyboardTypeDefault];
    }
    return _username;
}

-(UITextField *)legalname{
    if(!_legalname){
        _legalname = [self createText:@"请输入法人名字" keyboardType:UIKeyboardTypeDefault];
    }
    return _legalname;
}

-(UITextField *)verifyCode{
    if(!_verifyCode){
        _verifyCode = [self createText:@"请输入验证码" keyboardType:UIKeyboardTypeNumberPad];
    }
    return _verifyCode;
}

-(UITextField *)createText:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType{
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-100, 50)];
    [text addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    text.delegate = self;
    text.keyboardType = keyboardType;
    text.font = [UIFont systemFontOfSize:16];
    text.placeholder = placeholder;
    return text;
}

-(UIButton *)verifyCodeBtn{
    if(!_verifyCodeBtn){
        _verifyCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -95, 7.5, 80, 35)];
        _verifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _verifyCodeBtn.layer.cornerRadius = 3;
        _verifyCodeBtn.layer.masksToBounds = YES;
        [_verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyCodeBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_verifyCodeBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
        [_verifyCodeBtn addTarget:self action:@selector(sendVerifyCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyCodeBtn;
}

-(UIImageView *)picture{
    if(!_picture){
        _picture = [[UIImageView alloc]initWithFrame:CGRectMake(90, 10, 80, 80)];
        _picture.layer.borderColor = CTCommonLineBg.CGColor;
        _picture.layer.borderWidth = 0.5f;
        _picture.clipsToBounds = YES;
        _picture.contentMode = UIViewContentModeCenter;
        _picture.image = [UIImage imageNamed:@"takephotos"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToGetPhoto:)];
        _picture.userInteractionEnabled = YES;
        [_picture addGestureRecognizer:tap];
    }
    return _picture;
}


//初始化大类控件
-(CGHorrolView *)organizaHeaderView{
    __weak typeof(self) weakSelf = self;
    if(!_organizaHeaderView || _organizaHeaderView.array.count <= 0){
        [_organizaHeaderView removeFromSuperview];
        _organizaHeaderView = [[CGHorrolView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navi.frame), SCREEN_WIDTH, self.hideOrganizaNaviView ? 0 : 40) array:self.headViewEntitys finish:^(int index, CGHorrolEntity *data, BOOL clickOnShow) {
            [weakSelf.organizaName resignFirstResponder];
            weakSelf.currentIndex = index;
            [weakSelf.tableview reloadData];
        }];
    }
    return _organizaHeaderView;
}


- (void)viewDidLoad {
    self.title = @"认领组织";
    [super viewDidLoad];
    [self.view addSubview:self.organizaHeaderView];
    self.tableview.frame = CGRectMake(0, CGRectGetMaxY(self.organizaHeaderView.frame), self.tableview.frame.size.width, SCREEN_HEIGHT - CGRectGetMaxY(self.organizaHeaderView.frame));
    [self.organizaHeaderView setSelectIndex:self.currentIndex];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = CTCommonViewControllerBg;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:NOTIFICATION_TOUPDATEUSERINFO object:nil];
}

-(void)reloadData{
    self.uploadBtn.enabled = YES;
    [self.biz.component stopBlockAnimation];
    [self reset];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.organzias.count > 0){
        CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
        if(indexPath.row == 0){
            if(entity.companyType == 2){
                return 0;
            }
        }else if(indexPath.row == 2){
            if(entity.companyType == 2){
                return 0;
            }
        }else if(indexPath.row == 3){
            return 100;
        }else if(indexPath.row == 4){
            return 0;
//            if(entity.companyState == 1 || entity.companyState == 2){//companyState;//0-未认证，1-已认证 2-认证中 3-认证不通过
//                return 0;
//            }
        }else if(indexPath.row == 5){
            if(entity.companyState == 1 || entity.companyState == 2){
                return 0;
            }
        }else if(indexPath.row == 6){
            if(entity.companyState == 1){
                return 0;
            }
        }else if(indexPath.row == 8){
            return 70;
        }
        
        return 50;
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *view = [[UILabel alloc]init];
    view.backgroundColor = CTCommonViewControllerBg;
    view.font = [UIFont systemFontOfSize:13];
    view.textColor = [UIColor grayColor];
    view.text = @"   完善组织认领，为你及团队提供精准服务";
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.organzias.count > 0){
        return 9;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        if(indexPath.row == 5){
            self.protocolBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
            self.protocolBtn.selected = YES;
            [self.protocolBtn setImage:[UIImage imageNamed:@"tongyihuise"] forState:UIControlStateNormal];
            [self.protocolBtn setImage:[UIImage imageNamed:@"tongyi"] forState:UIControlStateSelected];
            [cell.contentView addSubview:self.protocolBtn];
            [self.protocolBtn addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *string = @"我已阅读并同意《认领服务协议》";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttribute:NSForegroundColorAttributeName value:CTThemeMainColor range:NSMakeRange(7,8)]; //设置字体颜色
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.protocolBtn.frame), 5, SCREEN_WIDTH-CGRectGetMaxX(self.protocolBtn.frame), 40)];
            label.text = string;
            label.font = [UIFont systemFontOfSize:13];
            label.attributedText = str;
          UIButton *btn = [[UIButton alloc]initWithFrame:label.frame];
          [cell.contentView addSubview:btn];
          [btn addTarget:self action:@selector(serviceAgreementClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:label];
        }else if(indexPath.row == 6){
            NSString *string = [NSString stringWithFormat:@"认领结果将在2个工作日内回复。如有疑问，请拨打%@咨询。",[ObjectShareTool sharedInstance].settingEntity.officialTel];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttribute:NSForegroundColorAttributeName value:CTThemeMainColor range:NSMakeRange(23,12)]; //设置字体颜色
            UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 40)];
            desc.textColor = [UIColor grayColor];
            desc.text = string;
            desc.attributedText = str;
            desc.numberOfLines = 2;
            desc.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:desc];
        }else if(indexPath.row == 7){
            self.uploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 2.5, SCREEN_WIDTH - 40, 45)];
            self.uploadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            self.uploadBtn.layer.cornerRadius = 3;
            self.uploadBtn.layer.masksToBounds = YES;
            [self.uploadBtn setTitle:@"提交审核" forState:UIControlStateNormal];
            [self.uploadBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [self.uploadBtn addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.uploadBtn];
        }else if(indexPath.row == 8){
            self.authInfoTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH, 20)];
            self.authInfoTitle.textColor = [UIColor redColor];
            self.authInfoTitle.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:self.authInfoTitle];
            self.authInfoTitle.text = @"审核失败原因：";
            
            self.authInfoDesc = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.authInfoTitle.frame), SCREEN_WIDTH-20, 20)];
            self.authInfoDesc.font = [UIFont systemFontOfSize:14];
            self.authInfoDesc.textColor = [UIColor redColor];
            [cell.contentView addSubview:self.authInfoDesc];
        }
        
        if(indexPath.row <= 2){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5f, SCREEN_WIDTH, 0.5f)];
            line.backgroundColor = CTCommonLineBg;
            [cell.contentView addSubview:line];
        }else if(indexPath.row == 3){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, SCREEN_WIDTH, 0.5f)];
            line.backgroundColor = CTCommonLineBg;
            [cell.contentView addSubview:line];
        }else if(indexPath.row > 4){
            cell.contentView.backgroundColor = CTCommonViewControllerBg;
        }
    }
    
    if(self.organzias.count > 0){
        CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
        if(indexPath.row == 0){
            cell.textLabel.text = @"组织简称";
            [cell.contentView addSubview:self.organizaName];
            self.organizaName.text = entity.authInfo.organizaName;
            self.organizaName.enabled = entity.companyState == 1 || entity.companyState == 2 ? NO : YES;
        }if(indexPath.row == 1){
            cell.textLabel.text = @"我的姓名";
            [cell.contentView addSubview:self.username];
            self.username.text = entity.authInfo.name;
            self.username.enabled = entity.companyState == 1 || entity.companyState == 2 ? NO : YES;
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"企业法人";
            [cell.contentView addSubview:self.legalname];
            self.legalname.text = entity.authInfo.legalPerson;
            self.legalname.enabled = entity.companyState == 1 || entity.companyState == 2 ? NO : YES;
        }else if(indexPath.row == 3){
            cell.textLabel.text = entity.companyType == 2?@"学生证":@"营业执照";
            [cell.contentView addSubview:self.picture];
            
            if(entity.companyState==0){//0-未认证，1-已认证 2-认证中 3-认证不通过
                if(self.selectImg){
                    self.picture.image = self.selectImg;
                    self.picture.contentMode = UIViewContentModeScaleAspectFit;
                }else{
                    self.picture.contentMode = UIViewContentModeCenter;
                    self.picture.image = [UIImage imageNamed:@"takephotos"];
                }
            }else if(entity.companyState == 1 || entity.companyState == 2){
                if(entity.authInfo.additional){
                    [self.picture sd_setImageWithURL:[NSURL URLWithString:entity.authInfo.additional]];
                    self.picture.contentMode = UIViewContentModeScaleAspectFit;
                }else{
                    self.picture.contentMode = UIViewContentModeCenter;
                    self.picture.image = [UIImage imageNamed:@"takephotos"];
                }
            }else if(entity.companyState == 3){
                if(self.selectImg){
                    self.picture.image = self.selectImg;
                    self.picture.contentMode = UIViewContentModeScaleAspectFit;
                }else if(entity.authInfo.additional){
                    [self.picture sd_setImageWithURL:[NSURL URLWithString:entity.authInfo.additional]];
                    self.picture.contentMode = UIViewContentModeScaleAspectFit;
                }else{
                    self.picture.contentMode = UIViewContentModeCenter;
                    self.picture.image = [UIImage imageNamed:@"takephotos"];
                }
            }
        }else if(indexPath.row == 4){
            cell.textLabel.text = @"验证码";
            [cell.contentView addSubview:self.verifyCode];
            [cell.contentView addSubview:self.verifyCodeBtn];
            self.verifyCode.text = entity.authInfo.verifyCode;
        }else if(indexPath.row == 5){
            
        }else if(indexPath.row == 6){
            
        }else if(indexPath.row == 7){
            if(entity.companyState == 0){//0-未认证，1-已认证 2-认证中 3-认证不通过
                self.uploadBtn.userInteractionEnabled = YES;
                [self.uploadBtn setTitle:@"提交审核" forState:UIControlStateNormal];
                [self.uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.uploadBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            }else if(entity.companyState == 1){
                self.uploadBtn.userInteractionEnabled = NO;
                [self.uploadBtn setTitle:@"认领审核通过" forState:UIControlStateNormal];
                [self.uploadBtn setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
                [self.uploadBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            }else if(entity.companyState == 2){
                self.uploadBtn.userInteractionEnabled = NO;
                [self.uploadBtn setTitle:@"认领审核中" forState:UIControlStateNormal];
                [self.uploadBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [self.uploadBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            }else if(entity.companyState == 3){
                self.uploadBtn.userInteractionEnabled = YES;
                [self.uploadBtn setTitle:@"重新提交" forState:UIControlStateNormal];
                [self.uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.uploadBtn setBackgroundImage:[CTCommonUtil generateImageWithColor:CTThemeMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            }
        }else if (indexPath.row == 8){
            if(entity.companyState == 3){
                self.authInfoTitle.hidden = NO;
                self.authInfoDesc.hidden = NO;
                self.authInfoDesc.text = entity.authInfo.authExplain;
                
            }else{
                self.authInfoTitle.hidden = YES;
                self.authInfoDesc.hidden = YES;
            }
        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 6){
        if(!self.isClickToDial){
            self.isClickToDial = YES;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:02082513714"]];
            [self performSelector:@selector(changeDialState) withObject:nil afterDelay:3];
        }
    }
}
-(void)changeDialState{
    self.isClickToDial = NO;
}

-(void)valueChanged:(UITextField *)textField{
    if(textField == self.organizaName){
        CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
        entity.authInfo.organizaName = textField.text;
    }else{
        for(CGUserOrganizaJoinEntity *entity in self.organzias){
            if(entity.companyState != 1 && entity.companyState != 2){
                if(textField == self.username){
                    entity.authInfo.name = textField.text;
                }else if (textField == self.legalname){
                    entity.authInfo.legalPerson = textField.text;
                }else if (textField == self.verifyCode){
                    if(textField.text.length == 4){
                        [textField resignFirstResponder];
                    }
                    if(textField.text.length > 4){
                        textField.text = [textField.text substringToIndex:4];
                    }
                    entity.authInfo.verifyCode = textField.text;
                }
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.organizaName resignFirstResponder];
    [self.username resignFirstResponder];
    [self.legalname resignFirstResponder];
    [self.verifyCode resignFirstResponder];
}

#pragma Action

-(void)upload:(UIButton *)button{
    CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
    if(entity.companyType != 2 && ![CTStringUtil stringNotBlank:entity.authInfo.organizaName]){
        [[CTToast makeText:@"请输入组织简称"]show:self.view];
        return;
    }
    if(![CTStringUtil stringNotBlank:entity.authInfo.name]){
        [[CTToast makeText:@"请输入姓名"]show:self.view];
        return;
    }
    if(entity.companyType != 2 && ![CTStringUtil stringNotBlank:entity.authInfo.legalPerson]){
        [[CTToast makeText:@"请输入法人姓名"]show:self.view];
        return;
    }
    if(!self.selectImg){
        [[CTToast makeText:@"请选择相关证件照片"]show:self.view];
        return;
    }
//    if(![CTStringUtil stringNotBlank:entity.authInfo.verifyCode]){
//        [[CTToast makeText:@"请获取验证码"]show:self.view];
//        return;
//    }else if(entity.authInfo.verifyCode.length != 4){
//        [[CTToast makeText:@"验证码错误"]show:self.view];
//        return;
//    }
    if(!self.protocolBtn.selected){
        [[CTToast makeText:@"如果你拒绝接受《会议猫认领协议》，将无法认领"]show:self.view];
        return;
    }
    button.enabled = NO;
    
    QiniuBiz *biz = [[QiniuBiz alloc]init];
    [biz.component startBlockAnimation];
    int date = [[NSDate date]timeIntervalSince1970];
    NSString *key = [NSString stringWithFormat:@"company/auth/%@/%d/%@",entity.companyId,date,[CTDataUtil uuidString]];
    [biz uploadFileWithImages:[NSMutableArray arrayWithObjects:self.selectImg, nil] phAssets:nil keys:[NSMutableArray arrayWithObjects:key, nil] original:NO progress:^(NSString *key, float percent) {
        
    } success:^{
        entity.authInfo.additional = key;
        [[[CGUserCenterBiz alloc]init]userCompanyAttestation:entity success:^{
            [[CTToast makeText:@"提交成功"]show:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
        } fail:^(NSError *error) {
            [biz.component stopBlockAnimation];
            button.enabled = YES;
        }];
    } fail:^(NSError *error) {
        [biz.component stopBlockAnimation];
        button.enabled = YES;
    }];
}


-(void)sendVerifyCodeAction:(UIButton *)button{
    if(button.enabled){
        button.enabled = NO;
        [[[CGUserCenterBiz alloc]init]organizaAuthSendSMS:^{
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [self.verifyCodeBtn setTitle:@"已发送" forState:UIControlStateNormal];
            [self.verifyCode becomeFirstResponder];
        } fail:^(NSError *error) {
            button.enabled = YES;
        }];
    }
}

-(void)timerAction{
    if(++self.timeCount > TimerExpireCount){
        self.timeCount = 0;
        [self.timer invalidate];
        self.timer = nil;
        self.verifyCodeBtn.enabled = YES;
        [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        [self.verifyCodeBtn setTitle:[NSString stringWithFormat:@"%dS",TimerExpireCount-self.timeCount] forState:UIControlStateNormal];
    }
}

-(void)acceptAction:(UIButton *)button{
    button.selected = !button.selected;
}

-(void)clickToGetPhoto:(UITapGestureRecognizer *)recognizer{
    CGUserOrganizaJoinEntity *entity = self.organzias[self.currentIndex];
    if(entity.companyState == 1 || entity.companyState == 2){
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.picture = (UIImageView *)recognizer.view;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.navigationBar.barTintColor = CTThemeMainColor;//导航栏背景颜色
    imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];//返回箭头和文字的颜色
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingOriginalPhoto = NO;//不支持原图
    imagePickerVc.sortAscendingByModificationDate = YES;//图片显示按时间排序的升序
    imagePickerVc.allowPickingVideo = NO;//不允许选择视频
    imagePickerVc.allowPickingImage = YES;//允许选择图片
    imagePickerVc.allowPickingGif = NO;//不允许选择GIF
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        weakSelf.selectImg = photos[0];
        weakSelf.picture.image = weakSelf.selectImg;
        weakSelf.picture.layer.borderWidth = 0;
        weakSelf.picture.contentMode = UIViewContentModeScaleAspectFit;
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)serviceAgreementClick{
  CGUserHelpCatePageViewController *vc = [[CGUserHelpCatePageViewController alloc]init];
  vc.title = @"认领服务协议";
  vc.pageId = @"9bb9f809-c29f-b656-9c90-7104b0caccc1";
  [self.navigationController pushViewController:vc animated:YES];
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
