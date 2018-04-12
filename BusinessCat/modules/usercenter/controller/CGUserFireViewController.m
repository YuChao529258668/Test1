//
//  CGUserFireViewController.m
//  CGSays
//
//  Created by zhu on 16/10/19.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserFireViewController.h"
#import "CGUserFireIconTableViewCell.h"
#import "CGUserFireTextTableViewCell.h"
#import "CGUserFireTitleTableViewCell.h"
#import "CGUserFireChoseTableViewCell.h"
#import "CGUserCenterBiz.h"
#import <UIButton+WebCache.h>
#import "QiniuBiz.h"
#import "CGUserTextViewController.h"
#import "CGSkillTagsViewController.h"
#import "CGIndustryViewController.h"
#import "CGTagsEntity.h"
#import "CGUserChoseDepartmentViewController.h"
#import "CGUserEntity.h"
#import "CGUserDao.h"
#import "CGUserChangeOrganizationViewController.h"
#import "UserNickNameTableViewCell.h"
#import <WXApi.h>
#import "CGUserFireOrganizationTableViewCell.h"
#import "CGCompanyDao.h"
#import "CGUserSearchViewController.h"
#import "CGUserChangeDepartmentViewController.h"
#import <TZImagePickerController.h>
#import "CGLoginController.h"

@interface CGUserFireViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,CGUserChoseDepartmentDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *relatedArray;
@property (nonatomic, strong) NSArray *relatedArray1;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIActionSheet *genderActionSheet;
@property (nonatomic, copy) NSString *iconID;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSMutableArray *roles;
@property (nonatomic, strong) NSMutableArray *industrys;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, copy) NSString *departmentID;
@property (nonatomic, strong) NSMutableArray *companyList;
@end

@implementation CGUserFireViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"档案";
  self.biz = [[CGUserCenterBiz alloc]init];
  self.roles = [self changeSkill];
  self.industrys = [self changeIndustry];
  self.tableview.delegate = self;
  self.tableview.dataSource = self;
  self.tableview.separatorStyle = NO;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAccess_token:) name:NOTIFICATION_GETWEIXINCODE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:NOTIFICATION_TOUPDATEUSERINFO object:nil];
  [self getCompanyListData];
    self.titleArray = @[@[@"个人信息",@"头像",@"昵称(对外显示)",@"姓名(团队显示)",@"手机号",@"性别",@"邮箱",@"技能级别"],@[@"所属组织"],@[@""],@[@"我的关注",@""]];
}

-(void)reloadTable{
  [self getCompanyListData];
}

-(NSMutableArray *)companyList{
  if (!_companyList) {
    _companyList = [NSMutableArray array];
  }
  return _companyList;
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getCompanyListData{
  for (int i=0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
    CGUserOrganizaJoinEntity *entity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
    if (entity.companyType !=4) {
      [self.companyList addObject:entity];
    }
  }
  [self.tableview reloadData];
}

- (void)rightBtnAction{
  [self.biz.component startBlockAnimation];
  __weak typeof(self) weakSelf = self;
  [self.biz updateUserInfoWithUsername:[ObjectShareTool sharedInstance].currentUser.username nickname:[ObjectShareTool sharedInstance].currentUser.nickname gender:[ObjectShareTool sharedInstance].currentUser.gender portrait:self.iconID email:[ObjectShareTool sharedInstance].currentUser.email addSkillIds:[self getAddSkillArray] delSkillIds:[self getDeleteSkillArray] skillLevel:[ObjectShareTool sharedInstance].currentUser.skillLevel success:^{
    [weakSelf.biz.component stopBlockAnimation];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATESKILLLEVEL object:nil];
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
  }];
}

- (void)didSelectedButtonIndex:(CGFireSuccessBlock)block{
  self.block = block;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0:
    {
        if(indexPath.row == 0){
            return 40;
        }else if (indexPath.row==1) {
        return 60;
      }else if (indexPath.row==2){
        if ([WXApi isWXAppInstalled]) {
         return 81;
        }
        return 50;
      }else{
        return 50;
      }
    }
      break;
    case 1:
      return 50;
      break;
    case 2:
      return 50;
      break;
    case 3:
      if (indexPath.row==1) {
        return [CGUserFireChoseTableViewCell height:self.roles];
      }
      return 50;
      break;
  }
  return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 4;
    return 3;// 隐藏我的关注
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  switch (section) {
    case 0:
      return 7;
      break;
    case 1:
      return 1;
      break;
      case 2:
      return self.companyList.count;
      break;
      case 3:
      return 2;
      break;
    default:
      break;
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0 || section == 2) {
    return 0.01;
  }
  return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  switch (indexPath.section) {
    case 0:
    {
      switch (indexPath.row) {
        case 0:

          break;
        case 1:
        [self callActionSheetFunc];
          break;
        case 2:
          [self textWithType:UserTextTypeNickName];
          break;
        case 3:
          if ([ObjectShareTool sharedInstance].currentUser.updateName) {
           [self textWithType:UserTextTypeUserName];
          }
          break;
        case 4:
        {
          __weak typeof(self) weakSelf = self;
          CGLoginController *vc = [[CGLoginController alloc]initWithBlock:^(CGUserEntity *user) {
            [weakSelf.tableview reloadData];
          } fail:^(NSError *error) {
            
          }];
          vc.isChangePhone = YES;
          [self.navigationController pushViewController:vc animated:YES];
        }
          break;
        case 5:
          [self callGenderActionSheetFunc];
          break;
        case 6:
        {
          [self textWithType:UserTextTypeEmail];
        }
          break;
        case 7:
        [self callLevelActionSheetFunc];
          break;
        case 8:{
          CGUserChoseDepartmentViewController *vc = [[CGUserChoseDepartmentViewController alloc]init];
          vc.delegate = self;
          vc.isEditing = YES;
          [self.navigationController pushViewController:vc animated:YES];
        }
          break;
          
        default:
          break;
      }
    }
      break;
    case 1:
      break;
    case 2:
    {
      __weak typeof(self) weakSelf = self;
      CGUserOrganizaJoinEntity *entity = self.companyList[indexPath.row];
      CGUserChangeDepartmentViewController *vc = [[CGUserChangeDepartmentViewController alloc]initWithBlock:^(NSString *psition, NSString *departmentName, NSString *departmentID) {
        entity.department = departmentName;
        entity.departmentId = departmentID;
        entity.position = psition;
        [weakSelf.tableview reloadData];
        
      }];
      vc.departmentName = entity.department;
      vc.departmentID = entity.departmentId;
      vc.position = entity.position;
      vc.title = entity.companyName;
      vc.companyType = entity.companyType;
      vc.companyID = entity.companyId;
      [self.navigationController pushViewController:vc animated:YES];
    }
      break;
    default:
      break;
  }
}

- (void)textWithType:(UserTextType )type{
    __weak typeof(self) weakSelf = self;
  CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
    switch (type) {
      case UserTextTypeNickName:
        [ObjectShareTool sharedInstance].currentUser.nickname = text;
        break;
      case UserTextTypeUserName:
        [ObjectShareTool sharedInstance].currentUser.username = text;
        break;
      case UserTextTypeUserIntro:
        [ObjectShareTool sharedInstance].currentUser.userIntro = text;
        break;
      case UserTextTypeEmail:
        [ObjectShareTool sharedInstance].currentUser.email = text;
        break;
        
      default:
        break;
    }
    [weakSelf rightBtnAction];
    [weakSelf.tableview reloadData];
  }];
  vc.textType = type;
  switch (type) {
    case UserTextTypeNickName:
     vc.text = [ObjectShareTool sharedInstance].currentUser.nickname;
      break;
    case UserTextTypeUserName:
     vc.text = [ObjectShareTool sharedInstance].currentUser.username;
      break;
    case UserTextTypeUserIntro:
    vc.text = [ObjectShareTool sharedInstance].currentUser.userIntro;
      break;
    case UserTextTypeEmail:
      vc.text = [ObjectShareTool sharedInstance].currentUser.email;
      break;
      
    default:
      break;
  }
  [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identifier = @"CGUserFireIconTableViewCell";
  static NSString *identifier1 = @"CGUserFireTitleTableViewCell";
  static NSString *identifier2 = @"CGUserFireTextTableViewCell";
  static NSString *identifier4 = @"CGUserFireChoseTableViewCell";
  static NSString *identifier5 = @"UserNickNameTableViewCell";
  NSString *title;
  if (indexPath.section != 2) {
    title = [[self.titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
  }
  switch (indexPath.section) {
    case 0:
    {
      if (indexPath.row == 0) {
        CGUserFireTitleTableViewCell *cell = (CGUserFireTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireTitleTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = title;
        return cell;
      }else if (indexPath.row == 1){
        CGUserFireIconTableViewCell *cell = (CGUserFireIconTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireIconTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = title;
        if (self.icon) {
          [cell.icon setImage:self.icon forState:UIControlStateNormal];
        }else{
          [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/80/interlace/1",[ObjectShareTool sharedInstance].currentUser.portrait]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_icon"]];
        }
        [cell.icon addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
      }else if (indexPath.row == 2){
        UserNickNameTableViewCell *cell = (UserNickNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier5];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserNickNameTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = title;
        cell.desc.text = [ObjectShareTool sharedInstance].currentUser.nickname;
        if ([CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.unionid]) {
//          cell.bindingButton.hidden = YES;unionid
          [cell.bindingButton setTitle:@"重新绑定" forState:UIControlStateNormal];
          [cell.bindingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
          cell.bindingText.text = @"已绑定微信";
//            cell.bindingText.textColor = CTThemeMainColor;
            cell.bindingText.textColor = [YCTool colorOfHex:0xf68731];
        }else{
          cell.bindingText.text = @"绑定微信可以直接获取头像、昵称";
          cell.bindingText.textColor = [UIColor darkGrayColor];
          [cell.bindingButton setTitle:@"绑定微信" forState:UIControlStateNormal];
//            [cell.bindingButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
            [cell.bindingButton setTitleColor:[YCTool colorOfHex:0xf68731] forState:UIControlStateNormal];
//          cell.bindingButton.hidden = NO;
            
        }
        [cell.bindingButton addTarget:self action:@selector(bindingClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
      }else{
        CGUserFireTextTableViewCell *cell = (CGUserFireTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireTextTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = title;
        if (indexPath.row==8) {
          cell.phoneLabel.hidden = NO;
          cell.detailLabel.hidden = YES;
          cell.arrow.hidden = YES;
          cell.phoneLabel.text = [ObjectShareTool sharedInstance].currentUser.phone;
        }else{
          cell.phoneLabel.hidden = YES;
          cell.detailLabel.hidden = NO;
          cell.arrow.hidden = NO;
          switch (indexPath.row) {
            case 3:
              if ([ObjectShareTool sharedInstance].currentUser.updateName) {
                cell.detailLabel.text = [ObjectShareTool sharedInstance].currentUser.username;
              }else{
                cell.phoneLabel.hidden = NO;
                cell.detailLabel.hidden = YES;
                cell.arrow.hidden = YES;
                cell.phoneLabel.text = [ObjectShareTool sharedInstance].currentUser.username;
              }
              break;
            case 4:
              cell.detailLabel.text = [ObjectShareTool sharedInstance].currentUser.phone;
              break;
            case 5:
              cell.detailLabel.text = [ObjectShareTool sharedInstance].currentUser.gender;
              break;
            case 6:
              cell.detailLabel.text = [ObjectShareTool sharedInstance].currentUser.email;
              break;
            case 7:
              if ([ObjectShareTool sharedInstance].currentUser.skillLevel == 1) {
                cell.detailLabel.text = @"初级";
              }else if ([ObjectShareTool sharedInstance].currentUser.skillLevel == 2) {
                cell.detailLabel.text = @"中级";
              }else if ([ObjectShareTool sharedInstance].currentUser.skillLevel == 3) {
                cell.detailLabel.text = @"高级";
              }else{
                cell.detailLabel.text = @"未设置";
              }
              break;
          
            default:
              break;
          }
        }
        return cell;
      }
    }
      break;
      case 1:
    {
      CGUserFireTitleTableViewCell *cell = (CGUserFireTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireTitleTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.titleLabel.text = title;
      cell.addButton.hidden = [ObjectShareTool sharedInstance].currentUser.vipTime>0?NO:YES;
      [cell.addButton addTarget:self action:@selector(addOrganization) forControlEvents:UIControlEventTouchUpInside];
      return cell;
    }
      break;
      case 2:
    {
      CGUserFireOrganizationTableViewCell *cell = (CGUserFireOrganizationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireOrganizationTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      CGUserOrganizaJoinEntity *entity = self.companyList[indexPath.row];
      [cell update:entity];
      return cell;
    }
      break;
    case 3:
    {
      if (indexPath.row==0) {
        CGUserFireTitleTableViewCell *cell = (CGUserFireTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireTitleTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = title;
        cell.addButton.hidden = NO;
        //TODO
        if (indexPath.row == 0) {
          cell.addButton.tag = 0;
        }
        [cell.addButton addTarget:self action:@selector(addSkillAndIndustry:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
      }else{
        CGUserFireChoseTableViewCell *cell = (CGUserFireChoseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier4];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireChoseTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        while ([cell.contentView.subviews lastObject] != nil)
        {
          [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        if (indexPath.row == 1) {
          [cell getRelatedWithData:self.roles];
        }
        return cell;
      }
    }
      break;
      
  }
  return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 @ 调用ActionSheet
 */
- (void)callActionSheetFunc{
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.navigationBar.barTintColor = CTThemeMainColor;//导航栏背景颜色
    imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];//返回箭头和文字的颜色
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingOriginalPhoto = NO;//不支持原图
    imagePickerVc.allowCrop = YES;
    imagePickerVc.sortAscendingByModificationDate = YES;//图片显示按时间排序的升序
    imagePickerVc.allowPickingVideo = NO;//不允许选择视频
    imagePickerVc.allowPickingImage = YES;//允许选择图片
    imagePickerVc.allowPickingGif = NO;//不允许选择GIF
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        weakSelf.icon = photos[0];
        QiniuBiz *biz = [[QiniuBiz alloc]init];
        int date = [[NSDate date]timeIntervalSince1970];
        NSString *key = [NSString stringWithFormat:@"user/info/icon/%@/%d",[ObjectShareTool sharedInstance].currentUser.uuid,date];
        [biz uploadFileWithImages:[NSMutableArray arrayWithObjects:self.icon, nil] phAssets:nil keys:[NSMutableArray arrayWithObjects:key, nil] original:NO progress:^(NSString *key, float percent) {
            
        } success:^{
            weakSelf.iconID = key;
            [weakSelf rightBtnAction];
            [weakSelf.tableview reloadData];
        } fail:^(NSError *error) {
            
        }];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}

- (void)callGenderActionSheetFunc{
  self.genderActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
  self.genderActionSheet.tag = 1001;
  [self.genderActionSheet showInView:self.view];
}

- (void)callLevelActionSheetFunc{
  self.genderActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择等级" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"初级",@"中级",@"高级", nil];
  self.genderActionSheet.tag = 1002;
  [self.genderActionSheet showInView:self.view];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1001){
    switch (buttonIndex) {
      case 0:
        //男
        [ObjectShareTool sharedInstance].currentUser.gender = @"男";
        break;
      case 1:
        //女
        [ObjectShareTool sharedInstance].currentUser.gender = @"女";
        break;
      case 2:
        return;
    }
    [self rightBtnAction];
    [self.tableview reloadData];
    }else if (actionSheet.tag == 1002){
      if (buttonIndex<=2) {
        [ObjectShareTool sharedInstance].currentUser.skillLevel = buttonIndex+1;
//        [self rightBtnAction];
        [self.biz userInfoUpdateSkillLevel:[ObjectShareTool sharedInstance].currentUser.skillLevel success:^{
          [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
          [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATESKILLLEVEL object:nil];
        } fail:^(NSError *error) {
          
        }];
        [self.tableview reloadData];
      }
    }
}

- (void)iconClick{
  [self callActionSheetFunc];
}

- (void)addSkillAndIndustry:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    CGSkillTagsViewController *vc = [[CGSkillTagsViewController alloc]initWithBlock:^(NSMutableArray *tagArray) {
      weakSelf.roles = tagArray;
      [weakSelf rightBtnAction];
      [weakSelf.tableview reloadData];
    }];
    vc.selectArray = self.roles;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addOrganization{
  CGUserSearchViewController *vc = [[CGUserSearchViewController alloc]init];
  [self.navigationController pushViewController:vc animated:YES];
}

//技能对象转标签对象
- (NSMutableArray *)changeSkill{
  NSMutableArray *array = [NSMutableArray array];
  for (int i=0; i<[ObjectShareTool sharedInstance].currentUser.skills.count; i++) {
    CGUserRoles *skill = [ObjectShareTool sharedInstance].currentUser.skills[i];
    CGTags *tag = [[CGTags alloc]init];
    tag.tagID = skill.skillId;
    tag.tagName = skill.skillName;
    [array addObject:tag];
  }
  return array;
}

//行业对象转标签对象
- (NSMutableArray *)changeIndustry{
  NSMutableArray *array = [NSMutableArray array];
  for (int i=0; i<[ObjectShareTool sharedInstance].currentUser.industry.count; i++) {
    CGUserIndustry *skill = [ObjectShareTool sharedInstance].currentUser.industry[i];
    CGTags *tag = [[CGTags alloc]init];
    tag.tagID = skill.industryId;
    tag.tagName = skill.industryName;
    [array addObject:tag];
  }
  return array;
}

//
- (NSMutableArray *)getAddSkillArray{
  NSMutableArray *array = [NSMutableArray array];
  for (int i = 0 ; i<self.roles.count; i++) {
    CGTags *tag = self.roles[i];
    BOOL isHave = NO;
    for (int j=0; j<[ObjectShareTool sharedInstance].currentUser.skills.count; j++) {
      CGUserRoles *skill = [ObjectShareTool sharedInstance].currentUser.skills[j];
      if ([tag.tagID isEqualToString:skill.skillId]) {
        isHave = YES;
      }
    }
    if (isHave == NO) {
      if (tag.tagID.length>0) {
       [array addObject:tag.tagID];
      }
    }
  }
  return array;
}

//
- (NSMutableArray *)getDeleteSkillArray{
  NSMutableArray *array = [NSMutableArray array];
  for (int i = 0 ; i<[ObjectShareTool sharedInstance].currentUser.skills.count; i++) {
    CGUserRoles *skill = [ObjectShareTool sharedInstance].currentUser.skills[i];
    BOOL isHave = NO;
    for (int j=0; j<self.roles.count; j++) {
      CGTags *tag = self.roles[j];
      if ([tag.tagID isEqualToString:skill.skillId]) {
        isHave = YES;
      }
    }
    if (isHave == NO) {
      if (skill.skillId.length>0) {
       [array addObject:skill.skillId];
      }
    }
  }
  return array;
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.biz.component stopBlockAnimation];
}

-(void)didSelectDepaID:(NSString *)depaID depaName:(NSString *)depaName{
  self.departmentID = depaID;
//  [ObjectShareTool sharedInstance].currentUser.department = depaName;
  [self.tableview reloadData];
}

// 点击微信绑定
-(void)bindingClick{
  if ([WXApi isWXAppInstalled]) {
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    [WXApi sendReq:req];
  }else {
    [self setupAlertController];
  }
}

#pragma mark - 设置弹出提示语
- (void)setupAlertController {
  
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
  [alert addAction:actionConfirm];
  [self presentViewController:alert animated:YES completion:nil];
}

-(void)getAccess_token:(NSNotification*)info
{
    
  NSString *code = [info object];
//  __weak typeof(self) weakSelf = self;
  [self.biz queryUserDetailInfoWithCode:code success:^(CGUserEntity *user) {
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
  } fail:^(NSError *error) {
    
  }];
    
    
//
//  NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,code];
//
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    NSURL *zoneUrl = [NSURL URLWithString:url];
//    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//    dispatch_async(dispatch_get_main_queue(), ^{
//      if (data) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        [self getWeiXinUserInfoWithAccess_token:[dic objectForKey:@"access_token"] openid:[dic objectForKey:@"openid"]];
//      }
//    });
//  });
}

//-(void)getWeiXinUserInfoWithAccess_token:(NSString *)access_token openid:(NSString *)openid
//{
//  __weak typeof(self) weakSelf = self;
//  NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
//
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    NSURL *zoneUrl = [NSURL URLWithString:url];
//    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//    dispatch_async(dispatch_get_main_queue(), ^{
//      if (data) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        [weakSelf.biz wechatInfoUpdateWithNickname:dic[@"nickname"] gender:[dic[@"sex"] intValue] openid:dic[@"openid"] portrait:dic[@"headimgurl"] unionid:dic[@"unionid"] op:YES success:^{
//          [ObjectShareTool sharedInstance].currentUser.nickname = dic[@"nickname"];
//          if ([CTStringUtil stringNotBlank:dic[@"headimgurl"]]) {
//            [ObjectShareTool sharedInstance].currentUser.portrait = dic[@"headimgurl"];
//          }
//          [ObjectShareTool sharedInstance].currentUser.openid = dic[@"openid"];
//          [ObjectShareTool sharedInstance].currentUser.gender = [dic[@"sex"] intValue]==1?@"男":@"女";
//          [weakSelf.tableview reloadData];
//            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TOQUERYUSERINFO object:nil];
//        } fail:^(NSError *error) {
//
//        }];
//      }
//    });
//
//  });
//}
@end
