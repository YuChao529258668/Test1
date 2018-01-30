//
//  CGUserSettingViewController.m
//  CGSays
//
//  Created by zhu on 16/10/18.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserSettingViewController.h"
#import "CGUserSettingArrowTableViewCell.h"
#import "CGUserSettingSwitchTableViewCell.h"
#import "CGLoginOutTableViewCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CGUserCenterBiz.h"
#import "CGUserDao.h"
#import "ObjectShareTool.h"
#import "WKWebViewController.h"
#import "HeadLineDao.h"
#import "LightExpDao.h"
#import "CGCompanyDao.h"
#import "CommonWebViewController.h"
#import <StoreKit/StoreKit.h>
#import "CGUserHelpCatePageViewController.h"
#import "UMessage.h"
#import "CGSettingEntity.h"
#import "CGUserCenterBiz.h"
#import "TeamCircleLastStateEntity.h"

@interface CGUserSettingViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,SKStoreProductViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, assign) CGLogoutCancelBlock cancel;
@property (nonatomic, copy) CGLogoutSuccessBlock logoutSuccess;
@property (nonatomic, strong) CGSettingEntity *settEntity;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@end

@implementation CGUserSettingViewController

-(instancetype)initWithBlock:(CGLogoutSuccessBlock)success fail:(CGLogoutCancelBlock)fail{
    self = [super init];
    if(self){
        self.logoutSuccess = success;
        self.cancel = fail;
    }
    return self;
}

-(CGUserCenterBiz *)biz{
  if (!_biz) {
    _biz = [[CGUserCenterBiz alloc]init];
  }
  return _biz;
}

- (void)viewDidLoad {
    self.title = @"设置";
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
  self.settEntity = [ObjectShareTool sharedInstance].settingEntity;
//  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//  NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//  NSString *versionStr = [NSString stringWithFormat:@"检查新版本(V%@)",app_Version];
//    self.titleArray = @[@[@"字体大小",@"夜间模式",@"省流量无图模式",@"清理缓存"],@[@"接收新消息",@"夜间免打扰",@"声音",@"震动"],@[@"去App Store评分",versionStr],@[@"退出登录"]];
//  NSString *versionStr = [NSString stringWithFormat:@"当前版本号(V%@)",app_Version];
  self.titleArray = @[@[@"字体大小",@"清理缓存"],@[@"接收新消息"],@[@"去App Store评分"],@[@"退出登录"]];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 30)];
    [footView addSubview:button];
    [button setTitle:@"用户协议" forState:UIControlStateNormal];
//    [button setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    [button setTitleColor:[YCTool colorOfHex:0xf68731] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(protocolClick) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *phoneButton = [[UIButton alloc]initWithFrame:CGRectMake(0, button.frame.origin.y+button.frame.size.height, SCREEN_WIDTH, 30)];
  [footView addSubview:phoneButton];
  [phoneButton setTitle:[NSString stringWithFormat:@"联系我们 %@",[ObjectShareTool sharedInstance].settingEntity.officialTel] forState:UIControlStateNormal];
  [phoneButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  phoneButton.titleLabel.font = [UIFont systemFontOfSize:15];
  [phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
  
  
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, footView.frame.size.height-30, SCREEN_WIDTH, 20)];
    [footView addSubview:label];
    label.textColor = [CTCommonUtil convert16BinaryColor:@"#969799"];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"广州创将信息科技有限公司";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = footView;
    
}

-(void)updateSetting{
  __weak typeof(self) weakSelf = self;
  [self.biz userSettingUpdateWithDisturb:self.settEntity.disturb fontSize:self.settEntity.fontSize nightMode:self.settEntity.nightMode noPic:self.settEntity.noPic vibration:self.settEntity.vibration voice:self.settEntity.voice message:self.settEntity.message knowledgeMsg:self.settEntity.knowledgeMsg everydayMsg:self.settEntity.everydayMsg rewardMsg:self.settEntity.rewardMsg auditMsg:self.settEntity.auditMsg exitMsg:self.settEntity.exitMsg success:^{
    [CGCompanyDao saveSettingStatistics:weakSelf.settEntity];
  } fail:^(NSError *error) {
    
  }];
}

-(void)phoneClick{
  NSString *allString = [NSString stringWithFormat:@"tel:%@",[ObjectShareTool sharedInstance].settingEntity.officialTel];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}

- (void)protocolClick{
  CGUserHelpCatePageViewController *vc = [[CGUserHelpCatePageViewController alloc]init];
  vc.title = @"用户协议";
  vc.pageId = @"7c28fd89-2b55-50a5-163e-7474c0e996ad";
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)vibrate   {
  
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([ObjectShareTool sharedInstance].currentUser.isLogin == 1) {
        return 4;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSArray *array = self.titleArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 40;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //  if (section == 3&&self.isLogin==1) {
    //    return 74;
    //  }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==1) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"缓存清除" message:@"确定清除缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.tag = 0;
        [alertView show];
    }else if (indexPath.section==0&&indexPath.row==0){
        [self callActionSheetFunc];
    }else if (indexPath.section == 3){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.tag = 1;
        [alertView show];
    }else if (indexPath.section ==2 &&indexPath.row == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ((indexPath.section==0&&indexPath.row==0)||(indexPath.section==1&&indexPath.row==0)||(indexPath.section == 2&&indexPath.row==0)||(indexPath.section == 0&&indexPath.row==1)||(indexPath.section==0&&indexPath.row==3)) {
        static NSString*identifier = @"CGUserSettingArrowTableViewCell";
        CGUserSettingArrowTableViewCell *cell = (CGUserSettingArrowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserSettingArrowTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textlabel.text = str;
        if (indexPath.section==0&&indexPath.row==0) {
            cell.sizeLabel.hidden = NO;
            if (self.settEntity.fontSize == 1) {
                cell.sizeLabel.text = @"小";
            }else if (self.settEntity.fontSize == 2){
                cell.sizeLabel.text = @"中";
            }else if (self.settEntity.fontSize == 3){
                cell.sizeLabel.text = @"大";
            }else if(self.settEntity.fontSize == 4){
                cell.sizeLabel.text = @"特大";
            }
        }else if (indexPath.section==0&&indexPath.row==1){
            cell.detailLabel.hidden = NO;
            cell.detailLabel.text = [self getCacheSize];
            cell.arrow.hidden = YES;
        }else if (indexPath.section == 1&&indexPath.row==0){
          cell.detailLabel.hidden = NO;
//          cell.detailTrailing.constant = 30;
          cell.arrow.hidden = YES;
          cell.detailLabel.text = self.settEntity.message?@"开启":@"未开启";
          cell.detailLabel.textColor = self.settEntity.message?[UIColor blackColor]:[UIColor redColor];
        }
        return cell;
    }else if (indexPath.section == 3){
        static NSString*identifier = @"CGLoginOutTableViewCell";
        CGLoginOutTableViewCell *cell = (CGLoginOutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGLoginOutTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString*identifier = @"CGUserSettingSwitchTableViewCell";
        CGUserSettingSwitchTableViewCell *cell = (CGUserSettingSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserSettingSwitchTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      if (indexPath.section == 1&&indexPath.row == 1) {
        cell.timeLabel.hidden = NO;
      }else if (indexPath.section == 0&&indexPath.row == 1){
        cell.swtich.on = self.settEntity.nightMode?YES:NO;
        cell.swtich.tag = 0;
      }else if (indexPath.section == 0&&indexPath.row == 2){
        cell.swtich.on = self.settEntity.noPic?YES:NO;
        cell.swtich.tag = 1;
      }else if (indexPath.section == 1&&indexPath.row == 1){
        cell.swtich.on = self.settEntity.disturb?YES:NO;
        cell.swtich.tag = 2;
      }else if (indexPath.section == 1&&indexPath.row == 2){
        cell.swtich.on = self.settEntity.voice?YES:NO;
        cell.swtich.tag = 3;
      }else if (indexPath.section == 1&&indexPath.row == 3){
        cell.swtich.on = self.settEntity.vibration?YES:NO;
        cell.swtich.tag = 4;
      }
       [cell.swtich addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.textlabel.text = str;
        return cell;
    }
}

-(void)switchAction:(UISwitch *)sender
{
  BOOL isButtonOn = [sender isOn];
  switch (sender.tag) {
    case 0:
      self.settEntity.nightMode = isButtonOn?1:-1;
      break;
    case 1:
      self.settEntity.noPic = isButtonOn?1:-1;
      break;
    case 2:
      self.settEntity.disturb = isButtonOn?1:-1;
      break;
    case 3:
      self.settEntity.voice = isButtonOn?1:-1;
      break;
    case 4:
      self.settEntity.vibration = isButtonOn?1:-1;
      break;
    default:
      break;
  }
  [self updateSetting];
}

#pragma mark - 计算缓存大小
- (NSString *)getCacheSize
{
    //定义变量存储总的缓存大小
    long long sumSize = 0;
    
    //01.获取当前图片缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    //02.创建文件管理对象
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    //获取当前缓存路径下的所有子路径
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    
    //遍历所有子文件
    for (NSString *subPath in subPaths) {
        //1）.拼接完整路径
        NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
        //2）.计算文件的大小
        long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
        //3）.加载到文件的大小
        sumSize += fileSize;
    }
    float size_m = sumSize/(1024.0f*1024.0f);
    return [NSString stringWithFormat:@"%.2fM",size_m];
    
}

#pragma mark - UIAlertViewDelegate方法实现
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        //判断点击的是确认键
        if (buttonIndex == 1) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
            [fileManager removeItemAtPath:cacheFilePath error:nil];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView reloadData];//刷新表视图
            //      NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
            //      NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            //      [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            ////        NSLog(@"清除缓存完成");
            //      }];
            [HeadLineDao deleteQuery];
//            [CGCompanyDao cleanMonitoringGroupList];
        }
    }else{
        if (buttonIndex == 1) {
            __weak typeof(self) weakSelf=self;
            CGUserCenterBiz *biz = [[CGUserCenterBiz alloc]init];
            [biz userLogoutSuccess:^{
                [LightExpDao deleteAllLightExp];
              [[ObjectShareTool sharedInstance].knowledgeDict removeAllObjects];
                [weakSelf getNewToken];
            } fail:^(NSError *error) {
                weakSelf.cancel(error);
            }];
        }
    }
}


- (void)logoutClick:(UIButton *)sender{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)getNewToken{
    __weak typeof(self) weakSelf = self;
    CGUserCenterBiz *biz = [[CGUserCenterBiz alloc]init];
    [biz getToken:^(NSString *uuid, NSString *token) {
        weakSelf.logoutSuccess();
      [HeadLineDao deleteQuery];
      [CGCompanyDao cleanMonitoringGroupList];
      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGOUT object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
      [UMessage removeAllTags:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
        
      }];
        [[CTToast makeText:@"退出登录成功"]show:[UIApplication sharedApplication].keyWindow];
      TeamCircleLastStateEntity *entity = [[TeamCircleLastStateEntity alloc]init];
      entity.badge.userName = nil;
      entity.badge.portrait = nil;
      [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDiscoverHasLastData object:entity];
    } fail:^(NSError *error) {
        
    }];
}

- (void)callActionSheetFunc{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"字体大小" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"小", @"中",@"大",@"特大",nil];
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        switch (buttonIndex) {
            case 0:{
              self.settEntity.fontSize = 1;
              [self updateSetting];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FONTSIZE object:nil];
            }
                break;
            case 1:
            {
                self.settEntity.fontSize = 2;
              [self updateSetting];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FONTSIZE object:nil];
            }
                break;
            case 2:
            {
                self.settEntity.fontSize = 3;
              [self updateSetting];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FONTSIZE object:nil];
            }
                break;
            case 3:
            {
                self.settEntity.fontSize = 4;
              [self updateSetting];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FONTSIZE object:nil];
            }
                break;
            case 4:
                
                break;
        }
    }
    [self.tableView reloadData];
}
@end
