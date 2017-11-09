//
//  CGDiscoverReleaseSourceViewController.m
//  CGSays
//
//  Created by zhu on 16/10/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGDiscoverReleaseSourceViewController.h"
#import "CGReleaseTextViewTableViewCell.h"
#import "CGReleaseImagesTableViewCell.h"
#import "CGSourceImageTextTableViewCell.h"
#import <TZImagePickerController.h>
#import "CGDiscoverPartSeeViewController.h"
#import "CGDiscoverBiz.h"
#import "QiniuBiz.h"
#import "CGUserSearchCompanyEntity.h"
#import "CGPartSeeAddressEntity.h"
#import "CGDiscoverPartSeeAddressViewController.h"
#import "CGUserDao.h"
#import "CGUserOrganizaJoinEntity.h"
#import "CGCompanyDao.h"
#import "CGChoseOrganizationViewController.h"
#import <Photos/Photos.h>

@interface CGDiscoverReleaseSourceViewController ()<TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic,strong) NSMutableArray *imageAssetArray;
@property (nonatomic, assign) NSInteger reomveIndex;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSArray *levelArray;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) CGUserSearchCompanyEntity *visible;
@property (nonatomic, strong) NSMutableArray *remind;
@property (nonatomic, assign) NSInteger visibility;
@property (nonatomic, copy) NSString *remindStr;
@property (nonatomic, copy) NSString *whoSeeStr;
@property(nonatomic,assign)UIStatusBarStyle statusBarStyle;
@property(nonatomic,assign)BOOL statusBarHidden;
@property (nonatomic, strong) CGDiscoverBiz *biz;
@property (nonatomic, copy) CGDiscoverReleaseSuccessBlock block;
@property (nonatomic, strong) CGUserSearchCompanyEntity *reslut;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@end

@implementation CGDiscoverReleaseSourceViewController

-(instancetype)initWithBlock:(CGDiscoverReleaseSuccessBlock)success{
    self = [super init];
    if(self){
        self.block = success;
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.biz.component stopBlockAnimation];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.biz = [[CGDiscoverBiz alloc]init];
    self.tableView.separatorStyle = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.imageArray = [NSMutableArray array];
    self.imageAssetArray = [NSMutableArray array];
    self.level = 1;
    self.remind = [NSMutableArray array];
    if (self.releaseType == DiscoverReleaseTypeNoCompany || self.releaseType == DiscoverReleaseTypeCompany) {
        self.levelArray = [NSMutableArray arrayWithObjects:@"日常动态",@"重要爆料",@"紧急爆料", nil];
    }else{
        self.levelArray = [NSMutableArray arrayWithObjects:@"日常分享",@"重要爆料",@"紧急爆料", nil];
    }
    self.visibility = 0;
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"发表" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[CTCommonUtil convert16BinaryColor:@"#C7C7CC"] forState:UIControlStateSelected];
    [self.navi addSubview:rightBtn];
    self.remindStr = @"";
    self.whoSeeStr = self.currentEntity.rolName;
}

//发表按钮点击事件
- (void)rightBtnAction:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (self.textView.text.length<=0&&self.imageArray.count<=0&&self.link.linkId.length<=0) {
        [[CTToast makeText:@"内容不能为空"]show:window];
        return;
    }
    sender.selected = YES;
    [sender setUserInteractionEnabled:NO];
    [self.biz.component startBlockAnimation];
    int date = [[NSDate date]timeIntervalSince1970];
    NSMutableArray *imageKey = [NSMutableArray arrayWithCapacity:self.imageArray.count];
    for(int i=0;i<self.imageArray.count;i++){
        NSString *key = [NSString stringWithFormat:@"discover/scoop/pic/%d/%@",date,[CTDataUtil uuidString]];
        [imageKey addObject:key];
    }
    NSMutableArray *mediaKeys = [NSMutableArray arrayWithCapacity:self.imageArray.count];
    for(int i=0;i<imageKey.count;i++){
        [mediaKeys addObject:[NSDictionary dictionaryWithObject:imageKey[i] forKey:@"mediaId"]];
    }
    QiniuBiz *qinuibiz = [[QiniuBiz alloc]init];
    [qinuibiz uploadFileWithImages:self.imageArray phAssets:self.imageAssetArray keys:imageKey original:self.isSelectOriginalPhoto progress:^(NSString *key, float percent) {
        
    } success:^{
        NSInteger type = 1;
        NSInteger linkType = 0;
        if (weakSelf.link != nil) {
            type = 3;
            linkType = weakSelf.link.linkType;
        }else if (imageKey.count>0) {
            type = 2;
        }
        NSMutableArray *visibleArray = [NSMutableArray array];
        NSInteger visibility = 1;
//        BOOL isWaibu = YES;
//        NSInteger selectIndex = 0;
//        if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
//            for (int i = 0; i<[ObjectShareTool sharedInstance].currentUser.companyList.count; i++) {
//                CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[i];
//              if (companyEntity.companyType == 2) {
//                if ([CompanyId isEqualToString:companyEntity.classId]) {
//                  isWaibu = NO;
//                  selectIndex = i;
//                  break;
//                }
//              }else{
//                if ([CompanyId isEqualToString:companyEntity.companyId]) {
//                  isWaibu = NO;
//                  selectIndex = i;
//                  break;
//                }
//              }
//              
//            }
//        }
      
        if (self.visibility == 1) {
            visibility = 3;
        }else if (visibleArray.count>0){
            visibility = 2;
        }else{
            visibility = 1;
        }
      
        if (self.level == 1) {
            for (CGPartSeeAddressEntity *entity in self.remind) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:entity.userId forKey:@"id"];
                [visibleArray addObject:dict];
            }
        }
        
        [self.biz discoverScoopAddWithCompanyId:self.currentEntity.rolId companyType:self.currentEntity.rolType.integerValue content:self.textView.text type:type level:self.level visibility:visibility linkIcon:self.link.linkIcon linkId:self.link.linkId linkTitle:self.link.linkTitle linkType:linkType imgList:mediaKeys mediaId:nil visible:visibleArray remind:nil success:^{
            if (visibility == 3) {
                weakSelf.block(NO,-1,YES);
            }else{
                if (visibility == 1) {
                    weakSelf.block(NO,weakSelf.selectIndex,NO);
                }else{
                    weakSelf.block(YES,-1,NO);
                }
            }
            [[CTToast makeText:@"发表成功"]show:window];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf.biz.component stopBlockAnimation];
        } fail:^(NSError *error) {
            [weakSelf.biz.component stopBlockAnimation];
            [sender setUserInteractionEnabled:YES];
            sender.selected = NO;
        }];
    } fail:^(NSError *error) {
        
    }];
}

-(void)baseBackAction{
    if (self.textView.text.length>0 || self.imageArray.count>0) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退出此次编辑？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出",nil];
        [alert show];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate方法实现
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textView resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    }else if (indexPath.row == 1){
        if (self.link) {
            return 90;
        }
        static NSString*identifier1 = @"CGReleaseImagesTableViewCell";
        CGReleaseImagesTableViewCell *cell = (CGReleaseImagesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGReleaseImagesTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell updateImagesUIWithArray:self.imageArray];
        return cell.heigth;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.releaseType == DiscoverReleaseTypeCompany||self.releaseType == HeadlineReleaseTypeCompany){
        if (self.level > 1) {
            return 3;
        }
        return 4;
    }else{
        return 2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 2) {
//        [self callActionLevel];
//    }else
    if (indexPath.row == 2) {
//        if (self.level>1) {
            [self toCGDiscoverPartSeeViewController];
//        }
    }else if (indexPath.row == 3){
        [self toCGDiscoverPartSeeAddressViewController];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString*identifier = @"CGReleaseTextViewTableViewCell";
        CGReleaseTextViewTableViewCell *cell = (CGReleaseTextViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGReleaseTextViewTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.text = self.textView.text;
        if (self.textView.text.length>0) {
            cell.placeholder.hidden = YES;
        }
        self.textView = cell.textView;
        return cell;
    }else if (indexPath.row == 1){
        static NSString*identifier1 = @"CGReleaseImagesTableViewCell";
        CGReleaseImagesTableViewCell *cell = (CGReleaseImagesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGReleaseImagesTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for(UIView *mylabelview in [cell.contentView subviews])
        {
            if ([mylabelview isKindOfClass:[UILabel class]]) {
                [mylabelview removeFromSuperview];
            }
        }
        if (self.link) {
            [cell updateLinkWithLinkInfo:self.link];
        }else{
            [cell updateImagesUIWithArray:self.imageArray];
        }
        __weak typeof(self) weakSelf = self;
        [cell didSelectedButtonIndex:^(NSInteger index, BOOL isAddButton) {
            __strong typeof(weakSelf) swself = weakSelf;
            if (isAddButton) {
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
                imagePickerVc.navigationBar.barTintColor = CTThemeMainColor;//导航栏背景颜色
                imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];//返回箭头和文字的颜色
                imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
                // 1.设置目前已经选中的图片数组
                imagePickerVc.selectedAssets = weakSelf.imageAssetArray; // 目前已经选中的图片数组
                imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
                imagePickerVc.sortAscendingByModificationDate = YES;//图片显示按时间排序的升序
                imagePickerVc.allowPickingVideo = NO;//不允许选择视频
                imagePickerVc.allowPickingImage = YES;//允许选择图片
                imagePickerVc.allowPickingGif = NO;//不允许选择GIF
                
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
                    weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
                    weakSelf.imageArray = [NSMutableArray arrayWithArray:photos];
                    weakSelf.imageAssetArray = [NSMutableArray arrayWithArray:assets];
                    [weakSelf.tableView reloadData];
                }];
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }else{
                swself.reomveIndex = index;
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否删除图片" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",nil];
                actionSheet.tag = 1000;
                [actionSheet showInView:swself.view];
                [weakSelf.textView resignFirstResponder];
            }
        }];
        return cell;
    }else{
        static NSString*identifier1 = @"CGSourceImageTextTableViewCell";
        CGSourceImageTextTableViewCell *cell = (CGSourceImageTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGSourceImageTextTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (indexPath.row == 2) {
//            cell.icon.image = [UIImage imageNamed:@"diqiu"];
//            cell.titleLabel.text = @"重要程度";
//          cell.icon.image = [UIImage imageNamed:@"importantdegree"];
//            cell.detailLabel.text = self.levelArray[self.level-1];
//            if (self.level == 1) {
//                cell.detailLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#919191"];
//            }else{
//                cell.detailLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#FB3A3F"];
//            }
//        }else
      if (indexPath.row == 2){
            cell.icon.image = [UIImage imageNamed:@"diqiu"];
//            cell.rightArrow.hidden = self.level == 1?YES:NO;
            cell.titleLabel.text = @"发表到";
          cell.icon.image = [UIImage imageNamed:@"publishto"];
            cell.detailLabel.text = self.whoSeeStr;
        }else if (indexPath.row == 3){
            cell.icon.image = [UIImage imageNamed:@"diqiu"];
            cell.titleLabel.text = @"部分可看";
            cell.detailLabel.text = self.remindStr;
          cell.icon.image =[UIImage imageNamed:@"open"];
        }
        return cell;
    }
    return nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 0) {
            [self.imageArray removeObjectAtIndex:self.reomveIndex];
            [self.imageAssetArray removeObjectAtIndex:self.reomveIndex];
            [self.tableView reloadData];
        }
    }else if (actionSheet.tag == 1001){
        
        if (buttonIndex != 2) {
            if (buttonIndex == 0) {
                self.level = 1;
            }else{
                self.level = 3;
            }
            if (self.level == 1) {
                self.visibility = 0;
                self.whoSeeStr = self.currentEntity.rolName;
            }
            [self.tableView reloadData];
        }
    }else if (actionSheet.tag == 1002){
        switch (buttonIndex) {
            case 0:
            {
                //来源:相机
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:imagePickerController animated:YES completion:^{
                    
                }];
            }
                break;
            case 1:
                //来源:相册
            {
                __weak typeof(self) weakSelf = self;
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(9-self.imageArray.count) delegate:self];
                imagePickerVc.allowTakePicture= NO;
                imagePickerVc.allowPickingVideo = NO;
                // You can get the photos by block, the same as by delegate.
                // 你可以通过block或者代理，来得到用户选择的照片.
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
                    weakSelf.isSelectOriginalPhoto = YES;
                    [weakSelf.imageArray addObjectsFromArray:photos];
                    [weakSelf.imageAssetArray addObjectsFromArray:assets];
                    [weakSelf.tableView reloadData];
                }];
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }
                break;
            case 2:
                return;
        }
    }
}

- (void)callActionLevel{
    [self.textView resignFirstResponder];
    if (self.releaseType  == DiscoverReleaseTypeNoCompany|| self.releaseType == DiscoverReleaseTypeCompany) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"爆料级别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"日常动态",@"紧急爆料",nil];
        actionSheet.tag = 1001;
        [actionSheet showInView:self.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"爆料级别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"日常分享",@"紧急爆料",nil];
        actionSheet.tag = 1001;
        [actionSheet showInView:self.view];
    }
}

//- (void)callActionSheetFunc{
//    [self.textView resignFirstResponder];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择",nil];
//    actionSheet.tag = 1002;
//    [actionSheet showInView:self.view];
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.imageArray addObject:image];
    
    NSURL *imageAssetUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    PHFetchResult*result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetUrl] options:nil];
    [self.imageAssetArray addObject:[result firstObject]];
    
    [self.tableView reloadData];
}

- (void)toCGDiscoverPartSeeViewController{
    __weak typeof(self) weakSelf = self;
  CGChoseOrganizationViewController *vc = [[CGChoseOrganizationViewController alloc]initWithBlock:^(CGUserOrganizaJoinEntity *entity,NSInteger selectIndex) {
    weakSelf.selectIndex = selectIndex;
    weakSelf.whoSeeStr = entity.companyName;
    CGHorrolEntity *select = [[CGHorrolEntity alloc]init];
    if (entity.companyType == 2) {
      select.rolId = entity.classId;
    }else{
      select.rolId = entity.companyId;
    }
    select.rolType = [NSString stringWithFormat:@"%d",entity.companyType];
    weakSelf.currentEntity = select;
    [weakSelf.tableView reloadData];
  }];
  vc.type = self.type;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)toCGDiscoverPartSeeAddressViewController{
    __weak typeof(self) weakSelf = self;
    CGDiscoverPartSeeAddressViewController *vc = [[CGDiscoverPartSeeAddressViewController alloc]initWithBlock:^(NSMutableArray *reslut, BOOL isCancel) {
        __strong typeof(weakSelf) swself = weakSelf;
        swself.remind = reslut;
        [swself.tableView reloadData];
        if (reslut.count>0) {
            for (int i=0; i<reslut.count; i++) {
                CGPartSeeAddressEntity *entity = reslut[i];
                if (i == 0) {
                    swself.remindStr = entity.userName;
                }else{
                    swself.remindStr = [NSString stringWithFormat:@"%@,%@",swself.remindStr,entity.userName];
                }
            }
        }else{
            swself.remindStr = @"";
        }
    }];
    vc.title = @"部分可看";
    vc.selectArray = self.remind;
    
    vc.currentEntity = self.currentEntity;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
