//
//  CGFeedbackReleaseViewController.m
//  CGSays
//
//  Created by zhu on 2017/4/12.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGFeedbackReleaseViewController.h"
#import "CGReleaseTextViewTableViewCell.h"
#import "CGReleaseImagesTableViewCell.h"
#import "CGSourceImageTextTableViewCell.h"
#import <TZImagePickerController.h>
#import "CGDiscoverPartSeeViewController.h"
#import "CGUserCenterBiz.h"
#import "QiniuBiz.h"
#import "CGUserSearchCompanyEntity.h"
#import "CGPartSeeAddressEntity.h"
#import "CGDiscoverPartSeeAddressViewController.h"
#import "CGUserDao.h"
#import "CGUserOrganizaJoinEntity.h"

@interface CGFeedbackReleaseViewController ()<TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableArray *imageAssetArray;
@property (nonatomic, assign) NSInteger reomveIndex;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) CGUserCenterBiz *biz;
@property (nonatomic, copy) CGFeedbackReleaseSuccessBlock block;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CGFeedbackReleaseViewController

-(instancetype)initWithBlock:(CGFeedbackReleaseSuccessBlock)success{
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
//  self.title = self.level==1 ?@"反馈":@"纠错";
  self.biz = [[CGUserCenterBiz alloc]init];
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [[UIView alloc]init];
  self.imageArray = [NSMutableArray array];
    self.imageAssetArray = [NSMutableArray array];
  UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42.5f, 22, 40, 40)];
  [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setTitle:@"发表" forState:UIControlStateNormal];
  rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
  [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [rightBtn setTitleColor:[CTCommonUtil convert16BinaryColor:@"#C7C7CC"] forState:UIControlStateSelected];
  [self.navi addSubview:rightBtn];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];

}

//发表按钮点击事件
- (void)rightBtnAction:(UIButton *)sender{
  __weak typeof(self) weakSelf = self;
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  if (self.textView.text.length<=0) {
    [[CTToast makeText:@"内容不能为空"]show:window];
    return;
  }
  sender.selected = YES;
  [sender setUserInteractionEnabled:NO];
  [self.biz.component startBlockAnimation];
    
    
    int date = [[NSDate date]timeIntervalSince1970];
    NSMutableArray *imageKey = [NSMutableArray arrayWithCapacity:self.imageArray.count];
    for(int i=0;i<self.imageArray.count;i++){
        NSString *key = [NSString stringWithFormat:@"user/feedback/pic/%d/%@",date,[CTDataUtil uuidString]];
        [imageKey addObject:key];
    }
    NSMutableArray *mediaKeys = [NSMutableArray arrayWithCapacity:self.imageArray.count];
    for(int i=0;i<imageKey.count;i++){
        [mediaKeys addObject:[NSDictionary dictionaryWithObject:imageKey[i] forKey:@"mediaId"]];
    }
    QiniuBiz *qinuibiz = [[QiniuBiz alloc]init];
    [qinuibiz uploadFileWithImages:self.imageArray phAssets:self.imageAssetArray keys:imageKey original:NO progress:^(NSString *key, float percent) {
        
    } success:^{
        NSInteger type = 1;
        if (weakSelf.link != nil) {
            type = 3;
        }else if (mediaKeys.count>0) {
            type = 2;
        }
        
        [self.biz userFeedbackAddWithContent:self.textView.text type:type level:self.level linkIcon:self.link.linkIcon linkId:self.link.linkId linkTitle:self.link.linkTitle linkType:self.link.linkType imgList:mediaKeys success:^{
            weakSelf.block(@"success");
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
  return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
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
        [swself callActionSheetFunc];
      }else{
        swself.reomveIndex = index;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否删除图片" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",nil];
        actionSheet.tag = 1000;
        [actionSheet showInView:swself.view];
        [weakSelf.textView resignFirstResponder];
      }
    }];
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
  }
}

- (void)callActionSheetFunc{
  [self.textView resignFirstResponder];
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.navigationBar.barTintColor = CTThemeMainColor;//导航栏背景颜色
    imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];//返回箭头和文字的颜色
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.selectedAssets = weakSelf.imageAssetArray; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.sortAscendingByModificationDate = YES;//图片显示按时间排序的升序
    imagePickerVc.allowPickingVideo = NO;//不允许选择视频
    imagePickerVc.allowPickingImage = YES;//允许选择图片
    imagePickerVc.allowPickingGif = NO;//不允许选择GIF
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        weakSelf.imageArray = [NSMutableArray arrayWithArray:photos];
        weakSelf.imageAssetArray = [NSMutableArray arrayWithArray:assets];
        [weakSelf.tableView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

@end
