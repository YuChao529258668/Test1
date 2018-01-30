//
//  CGEnterpriseArchivesViewController.m
//  CGKnowledge
//
//  Created by zhu on 2017/7/13.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGEnterpriseArchivesViewController.h"
#import "CGUserFireTitleTableViewCell.h"
#import "CGUserFireIconTableViewCell.h"
#import "CGUserFireTextTableViewCell.h"
#import "CGUserFireChoseTableViewCell.h"
#import "CGChooseFocusKnowledgeViewController.h"
#import <TZImagePickerController.h>
#import "QiniuBiz.h"
#import "CGUserTextViewController.h"
#import "CGUserCenterBiz.h"
#import "CGOrganizationEntity.h"
#import <UIButton+WebCache.h>
#import "AddressPickerView.h"

@interface CGEnterpriseArchivesViewController ()<TZImagePickerControllerDelegate,AddressPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray *> *titleArray;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *iconID;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, strong) CGOrganizationEntity *entity;
@property (weak, nonatomic) IBOutlet UIButton *bgButton;
@property (nonatomic ,strong) AddressPickerView * pickerView;
@property (nonatomic, strong) NSMutableArray *Knowledge;
@end

@implementation CGEnterpriseArchivesViewController

- (AddressPickerView *)pickerView{
  if (!_pickerView) {
    _pickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 215)];
    _pickerView.delegate = self;
    // 关闭默认支持打开上次的结果
    //        _pickerView.isAutoOpenLast = NO;
  }
  return _pickerView;
}

-(CGUserCenterBiz *)biz{
  if (!_biz) {
    _biz = [[CGUserCenterBiz alloc]init];
  }
  return _biz;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"企业档案";
  self.tableView.separatorStyle = NO;
  [self.view addSubview:self.pickerView];
  [self getData];
  self.titleArray = @[@[@"基础信息"],@[@"企业LOGO",@"企业简称",@"企业全称",@"固定电话",@"官方网站",@"官方邮箱",@"员工人数",@"所在地区",@"详细地址"],@[@"企业关心的知识"],@[@""]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1&&indexPath.row==0) {
    return 60;
  }
  if (indexPath.section == 3) {
    return [CGUserFireChoseTableViewCell height:self.Knowledge];
  }
  if (indexPath.section == 5) {
    return 10;
  }
  return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *title = self.titleArray[section].firstObject;
    if ([title isEqualToString:@"企业关心的知识"]) {
        return 0;
    } else {
        NSArray *array = self.titleArray[section];
        return array.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 2 || section == 4) {
    return 10;
  }
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  switch (indexPath.section) {
    case 1:
    {
      switch (indexPath.row) {
        case 0:
          [self callActionSheetFunc];
          break;
        case 1:
          [self textWithType:UserTextTypeAbbreviation];
          break;
        case 2:
          
          break;
        case 3:
          [self textWithType:UserTextTypeTelephone];
          break;
        case 4:
          [self textWithType:UserTextTypeOfficialWebsite];
          break;
        case 5:
          [self textWithType:UserTextTypeOfficialMailbox];
          break;
//        case 6:
//          [self textWithType:UserTextTypeAffiliation];
//          break;
        case 6:
          [self textWithType:UserTextTypeNumberEmployees];
          break;
        case 7:
          [self.pickerView show];
          self.bgButton.hidden = NO;
          break;
        case 8:
          [self textWithType:UserTextTypeDetailedAddress];
          break;
          
        default:
          break;
      }
    }
      break;
    case 3:
      
      break;
    default:
      break;
  }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identifier = @"CGUserFireIconTableViewCell";
  static NSString *identifier1 = @"CGUserFireTitleTableViewCell";
  static NSString *identifier2 = @"CGUserFireTextTableViewCell";
  static NSString *identifier4 = @"CGUserFireChoseTableViewCell";
  NSString *title;
//  if (indexPath.section != 2) {
    title = [[self.titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//  }
  switch (indexPath.section) {
    case 0:
    {
      CGUserFireTitleTableViewCell *cell = (CGUserFireTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireTitleTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.titleLabel.text = title;
      cell.addButton.hidden = YES;
      return cell;
    }
      break;
    case 1:
    {
      if (indexPath.row == 0){
        CGUserFireIconTableViewCell *cell = (CGUserFireIconTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireIconTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.icon) {
          [cell.icon setImage:self.icon forState:UIControlStateNormal];
        }else{
          [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/80/interlace/1",self.entity.companyicon]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_icon"]];
        }
        [cell.icon addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
        cell.titleLabel.text = title;
        return cell;
      }else{
        CGUserFireTextTableViewCell *cell = (CGUserFireTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireTextTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = title;
        switch (indexPath.row) {
          case 1:
            cell.detailLabel.text = self.entity.companyname;
            break;
          case 2:
            cell.detailLabel.text = self.entity.companyfullname;
            break;
          case 3:
            cell.detailLabel.text = self.entity.companyphone;
            break;
          case 4:
            cell.detailLabel.text = self.entity.companyhttp;
            break;
          case 5:
            cell.detailLabel.text = self.entity.email;
            break;
//          case 6:
//            
//            break;
          case 6:
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld",self.entity.employeesnum];
            break;
          case 7:
            cell.detailLabel.text = [NSString stringWithFormat:@"%@%@%@",[CTStringUtil stringNotBlank:self.entity.province]?self.entity.province:@"",[CTStringUtil stringNotBlank:self.entity.city]?self.entity.city:@"",[CTStringUtil stringNotBlank:self.entity.area]?self.entity.area:@""];
            break;
          case 8:
            cell.detailLabel.text = self.entity.address;
            break;
            
          default:
            break;
        }
        return cell;
      }
    }
      break;
    case 2:
    {
      CGUserFireTitleTableViewCell *cell = (CGUserFireTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireTitleTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.titleLabel.text = title;
      cell.addButton.hidden = NO;
      [cell.addButton addTarget:self action:@selector(addknowledge) forControlEvents:UIControlEventTouchUpInside];
      return cell;
    }
      break;
    case 3:
    {
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
          [cell getRelatedWithData:self.Knowledge];
        return cell;
      }
      break;
    case 4:
    {
      CGUserFireTitleTableViewCell *cell = (CGUserFireTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserFireTitleTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.titleLabel.text = title;
      cell.addButton.hidden = NO;
      [cell.addButton addTarget:self action:@selector(addbusinessLabel) forControlEvents:UIControlEventTouchUpInside];
      return cell;
    }
      break;
    case 5:
    {
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
        //          [cell getRelatedWithData:self.roles];
      }
      return cell;
    }
      break;
      
  }
  return nil;
}

-(void)addknowledge{
  __weak typeof(self) weakSelf = self;
  CGChooseFocusKnowledgeViewController *vc = [[CGChooseFocusKnowledgeViewController alloc]initWithArray:self.Knowledge block:^(NSMutableArray *array) {
    weakSelf.Knowledge = array;
    [weakSelf update];
    [weakSelf.tableView reloadData];
  }];
  [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)getDeleteKnowledgeArray{
  NSMutableArray *array = [NSMutableArray array];
  for (int i = 0 ; i<self.entity.knowledge.count; i++) {
    CGknowledgeEntity *skill = self.entity.knowledge[i];
    BOOL isHave = NO;
    for (int j=0; j<self.Knowledge.count; j++) {
      CGknowledgeEntity *tag = self.Knowledge[j];
      if ([tag.cateId isEqualToString:skill.cateId]) {
        isHave = YES;
      }
    }
    if (isHave == NO) {
      if (skill.cateId.length>0) {
        [array addObject:skill.cateId];
      }
    }
  }
  return array;
}

- (NSMutableArray *)getAddKnowledgeArray{
  NSMutableArray *array = [NSMutableArray array];
  for (int i = 0 ; i<self.Knowledge.count; i++) {
    CGknowledgeEntity *tag = self.Knowledge[i];
    BOOL isHave = NO;
    for (int j=0; j<self.entity.knowledge.count; j++) {
      CGknowledgeEntity *skill = self.entity.knowledge[j];
      if ([tag.cateId isEqualToString:skill.cateId]) {
        isHave = YES;
      }
    }
    if (isHave == NO) {
      if (tag.cateId.length>0) {
        [array addObject:tag.cateId];
      }
    }
  }
  return array;
}

-(void)addbusinessLabel{
  
}

-(void)iconClick{
  [self callActionSheetFunc];
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"hhmmss"];
    NSString *confromTimespStr = [formatter stringFromDate:[NSDate date]];
    NSString *key = [NSString stringWithFormat:@"library/company/%@/icon/%@",weakSelf.companyID,confromTimespStr];
    [biz uploadFileWithImages:[NSMutableArray arrayWithObjects:self.icon, nil] phAssets:nil keys:[NSMutableArray arrayWithObjects:key, nil] original:NO progress:^(NSString *key, float percent) {
      
    } success:^{
      weakSelf.iconID = key;
      [weakSelf update];
      [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
      
    }];
  }];
  [self presentViewController:imagePickerVc animated:YES completion:nil];
  
}

- (void)textWithType:(UserTextType )type{
  __weak typeof(self) weakSelf = self;
  CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
    switch (type) {
      case UserTextTypeAbbreviation:
        weakSelf.entity.companyname = text;
        break;
      case UserTextTypeTelephone:
        weakSelf.entity.companyphone = text;
        break;
      case UserTextTypeOfficialWebsite:
        weakSelf.entity.companyhttp = text;
        break;
      case UserTextTypeOfficialMailbox:
        weakSelf.entity.email = text;
        break;
      case UserTextTypeAffiliation:
        
        break;
      case UserTextTypeNumberEmployees:
      weakSelf.entity.employeesnum = text.integerValue;
        break;
      case UserTextTypeDetailedAddress:
        weakSelf.entity.address = text;
        break;
        
      default:
        break;
    }
    [weakSelf update];
    [weakSelf.tableView reloadData];
  }];
  vc.textType = type;
  switch (type) {
    case UserTextTypeAbbreviation:
      vc.text = self.entity.companyname;
      break;
    case UserTextTypeTelephone:
      vc.text = self.entity.companyphone;
      break;
    case UserTextTypeOfficialWebsite:
      vc.text = self.entity.companyhttp;
      break;
    case UserTextTypeOfficialMailbox:
      vc.text = self.entity.email;
      break;
    case UserTextTypeAffiliation:
      
      break;
    case UserTextTypeNumberEmployees:
      vc.text = [NSString stringWithFormat:@"%ld",self.entity.employeesnum];
      break;
    case UserTextTypeDetailedAddress:
      vc.text = self.entity.address;
      break;
      
    default:
      break;
  }
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)update{
  [self.biz authUserOrganizaEditWithCompanyid:self.companyID companytype:self.companytype companyicon:self.iconID companyname:self.entity.companyname companyphone:self.entity.companyphone companyhttp:self.entity.companyhttp email:self.entity.email employeesnum:self.entity.employeesnum city:self.entity.city area:self.entity.area province:self.entity.province addKnowledge:[self getAddKnowledgeArray] delKnowledge:[self getDeleteKnowledgeArray] address:self.entity.address success:^{
    NSLog(@"成功");
  } fail:^(NSError *error) {
    NSLog(@"失败");
  }];
}

-(void)getData{
  [self.biz.component startBlockAnimation];
  __weak typeof(self) weakSelf = self;
  [self.biz authUserOrganizaInfoWithCompanyidWith:self.companyID companytype:self.companytype success:^(CGOrganizationEntity *result) {
    weakSelf.entity = result;
    weakSelf.Knowledge = weakSelf.entity.knowledge;
    [weakSelf.tableView reloadData];
    [weakSelf.biz.component stopBlockAnimation];
  } fail:^(NSError *error) {
    [weakSelf.biz.component stopBlockAnimation];
  }];
}

-(void)viewDidDisappear:(BOOL)animated{
  [self.biz.component stopBlockAnimation];
}

#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
  [self.pickerView hide];
  self.bgButton.hidden = YES;
  
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
  self.entity.province = province;
  self.entity.city = city;
  self.entity.area = area;
  [self.tableView reloadData];
  [self update];
  [self.pickerView hide];
  self.bgButton.hidden = YES;
}

- (IBAction)bgButtonClick:(UIButton *)sender {
  [self.pickerView hide];
  self.bgButton.hidden = YES;
}

@end
