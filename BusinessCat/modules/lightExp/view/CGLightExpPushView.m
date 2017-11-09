//
//  CGLightExpPushView.m
//  CGSays
//
//  Created by zhu on 2016/12/1.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGLightExpPushView.h"
#import "XWDragCellCollectionView.h"
#import "SubCollectionViewCell.h"
#import "CGLightExpEntity.h"
#import <UIButton+WebCache.h>
#import "LightExpBiz.h"
#import "LightExpDao.h"

@interface CGLightExpPushView()<UICollectionViewDelegate,UICollectionViewDataSource,XWDragCellCollectionViewDelegate,XWDragCellCollectionViewDataSource,SubCollectionViewCellDelegate,UITextFieldDelegate>{
  CGLightExpPushViewBlock delBlock;
  CGLightExpPushViewSortBlock rankBlock;
  CGLightExpPushViewReMoreBlock removeBlock;
  CGLightExpPushViewReMoreGroupBlock removeGroupBlock;
  CGLightExpPushViewAppClickBlock appClickBlock;
  CGLightExpPushViewEditingBlock editingBlock;
  CGLightExpPushViewChangeNameBlock changeNameBlock;
  CGLightExpPushViewAddGroupBlock addGroupBlock;
  CGLightExpPushViewCancelpBlock cancelBlock;
}
@property (nonatomic, strong) XWDragCellCollectionView *homeCollectionV;
@property (nonatomic, strong) CGLightExpEntity *entity;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *editingView;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, strong) NSMutableArray *deleteArray;
@end

@implementation CGLightExpPushView

-(instancetype)initWithEntity:(CGLightExpEntity *)entity editing:(BOOL)editing block:(CGLightExpPushViewBlock)block sortBlock:(CGLightExpPushViewSortBlock)sortBlock remove:(CGLightExpPushViewReMoreBlock)remove removeGroup:(CGLightExpPushViewReMoreGroupBlock)removeGroup appClick:(CGLightExpPushViewAppClickBlock)appClick changeEditing:(CGLightExpPushViewEditingBlock)changeEditing changeName:(CGLightExpPushViewChangeNameBlock)changeName addGroup:(CGLightExpPushViewAddGroupBlock)addGroup cancel:(CGLightExpPushViewCancelpBlock)cancel{
  self = [super initWithFrame:[UIScreen mainScreen].bounds];
  if(self){
    self.entity = entity;
    delBlock = block;
    self.editing = editing;
    rankBlock = sortBlock;
    removeBlock = remove;
    removeGroupBlock = removeGroup;
    appClickBlock = appClick;
    editingBlock = changeEditing;
    changeNameBlock = changeName;
    addGroupBlock = addGroup;
    cancelBlock = cancel;
    self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    [self addSubview:self.bgButton];
    self.bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.bgButton.alpha = 0;
    [self.bgButton addTarget:self action:@selector(closeMySelf) forControlEvents:UIControlEventTouchUpInside];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 80, SCREEN_WIDTH-20, SCREEN_HEIGHT-170)];
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.alpha = 0;
    
    self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, self.bgView.frame.size.width-30, 30)];
    [self.bgView addSubview:self.titleTextField];
    self.titleTextField.textColor = TEXT_MAIN_CLR;
    self.titleTextField.font = [UIFont systemFontOfSize:15];
    self.titleTextField.text = entity.gName;
    self.titleTextField.delegate = self;
    self.titleTextField.textAlignment = NSTextAlignmentCenter;
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, self.bgView.frame.size.width, 1)];
    [self.bgView addSubview:line];
    line.backgroundColor = CTCommonLineBg;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(65, 80);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.homeCollectionV = [[XWDragCellCollectionView alloc] initWithFrame:CGRectMake(0, 41, self.bgView.frame.size.width, self.bgView.frame.size.height-41) collectionViewLayout:flowLayout];
    self.homeCollectionV.backgroundColor = [UIColor clearColor];
    self.homeCollectionV.tag = 100;
    self.homeCollectionV.delegate = self;
    self.homeCollectionV.dataSource = self;
    self.homeCollectionV.showsVerticalScrollIndicator = NO;
    self.homeCollectionV.showsHorizontalScrollIndicator = NO;
    [self.bgView addSubview:self.homeCollectionV];
    
    self.editingView = [[UIView alloc]initWithFrame:CGRectMake(10, self.bgView.frame.origin.y+self.bgView.frame.size.height+10, SCREEN_WIDTH-20, 50)];
    [self addSubview:self.editingView];
    self.editingView.backgroundColor = [UIColor whiteColor];
    UIButton *moveOutButton = [[UIButton alloc]initWithFrame:CGRectMake((self.editingView.frame.size.width/2-46), 0, 46, 40)];
    [moveOutButton setTitle:@"移出组" forState:UIControlStateNormal];
    [moveOutButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    moveOutButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [moveOutButton addTarget:self action:@selector(moveOutClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.editingView addSubview:moveOutButton];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake((self.editingView.frame.size.width/2), 0, 46, 40)];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.editingView addSubview:deleteButton];
    
    
    //注册单元格
    [self.homeCollectionV registerNib:[UINib nibWithNibName:reusableCell
                                                     bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:reusableCell];
    self.deleteArray = [NSMutableArray array];
    if (!editing) {
      BOOL ishave = NO;
      for (CGApps *app in self.entity.apps) {
        if (app.isAdd == YES) {
          ishave = YES;
        }
      }
      if (ishave ==NO) {
        CGApps *addApp = [[CGApps alloc]init];
        addApp.icon = @"tiyangengduo";
        addApp.isAdd = YES;
        [self.entity.apps addObject:addApp];
        [self.homeCollectionV reloadData];
      }
      self.editingView.hidden = YES;
      self.titleTextField.userInteractionEnabled = NO;
//      self.titleTextField.backgroundColor = [UIColor whiteColor];
      self.titleTextField.borderStyle = UITextBorderStyleNone;
    }else{
      self.titleTextField.userInteractionEnabled = YES;
//      self.titleTextField.backgroundColor = CTCommonViewControllerBg;
      self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
      self.closeButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 70, 30, 30)];
      [self addSubview:self.closeButton];
      [self.closeButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
      [self.closeButton addTarget:self action:@selector(removeMySelf) forControlEvents:UIControlEventTouchUpInside];
      self.editingView.hidden = NO;
    }
  }
  return self;
}

-(void)reloadDataWithEntity:(CGLightExpEntity *)entity{
  self.entity = entity;
  if (!self.editing) {
    self.editingView.hidden = YES;
    self.titleTextField.userInteractionEnabled = NO;
    //      self.titleTextField.backgroundColor = [UIColor whiteColor];
    self.titleTextField.borderStyle = UITextBorderStyleNone;
    for (CGApps *app in self.entity.apps) {
      if (app.isAdd == YES) {
        [self.homeCollectionV reloadData];
        return;
      }
    }
    CGApps *addApp = [[CGApps alloc]init];
    addApp.icon = @"tiyangengduo";
    addApp.isAdd = YES;
    [self.entity.apps addObject:addApp];
  }else{
    self.titleTextField.userInteractionEnabled = YES;
    //      self.titleTextField.backgroundColor = CTCommonViewControllerBg;
    self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.closeButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 70, 30, 30)];
    [self addSubview:self.closeButton];
    [self.closeButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(removeMySelf) forControlEvents:UIControlEventTouchUpInside];
    self.editingView.hidden = NO;
  }
  [self.homeCollectionV reloadData];
}

-(void)moveOutClick:(UIButton *)sender{
  if (self.deleteArray.count<=0) {
    [[CTToast makeText:@"请选择移出的体验！"]show:[UIApplication sharedApplication].keyWindow];
    return;
  }
  LightExpBiz *biz = [[LightExpBiz alloc]init];
  [biz.component startBlockAnimation];
  NSMutableArray *idArray = [NSMutableArray array];
  for (CGApps *app in self.deleteArray) {
    [idArray addObject:app.mid];
  }
  [sender setUserInteractionEnabled:NO];
  __weak typeof(self) weakSelf = self;
  [biz discoverExpMyGroupAddWithids:idArray gid:nil op:NO success:^{
    [biz.component stopBlockAnimation];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:weakSelf.entity.apps];
    [tmpArray removeObjectsInArray:weakSelf.deleteArray];
    weakSelf.entity.apps = tmpArray;
    removeBlock(weakSelf.deleteArray);
    weakSelf.deleteArray = [NSMutableArray array];
    [weakSelf.homeCollectionV reloadData];
    [sender setUserInteractionEnabled:YES];
  } fail:^(NSError *error) {
    [sender setUserInteractionEnabled:YES];
    [biz.component stopBlockAnimation];
  }];
}

-(void)deleteClick:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
  if (self.deleteArray.count<=0) {
    [[CTToast makeText:@"请选择删除的体验！"]show:[UIApplication sharedApplication].keyWindow];
    return;
  }
  NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.entity.apps];
  NSMutableArray *idArray = [NSMutableArray array];
  for (CGApps *app in self.deleteArray) {
    [idArray addObject:app.mid];
  }
  [sender setUserInteractionEnabled:NO];
  LightExpBiz *biz = [[LightExpBiz alloc]init];
  [biz.component startBlockAnimation];
  [biz discoverExpMyDeleteWithID:idArray success:^() {
    [tmpArray removeObjectsInArray:weakSelf.deleteArray];
    weakSelf.entity.apps = tmpArray;
    NSArray *dictArray = [CGApps mj_keyValuesArrayWithObjectArray:tmpArray];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [LightExpDao updateLightExpByMid:weakSelf.entity.mid appsJsonStr:jsonString];
    [weakSelf.homeCollectionV reloadData];
    weakSelf.deleteArray = [NSMutableArray array];
    delBlock(weakSelf.entity.apps);
    [biz.component stopBlockAnimation];
    [sender setUserInteractionEnabled:YES];
  } fail:^(NSError *error) {
    [sender setUserInteractionEnabled:YES];
    [biz.component stopBlockAnimation];
  }];
}

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
  self.entity.apps = [newDataArray mutableCopy];
  NSArray *dictArray = [CGApps mj_keyValuesArrayWithObjectArray:self.entity.apps];
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  [LightExpDao updateLightExpByMid:self.entity.mid appsJsonStr:jsonString];
  rankBlock(self.entity.apps);
}

- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
  return  self.entity.apps;
}

//- (CGFloat) collectionView:(UICollectionView *)collectionView
//                    layout:(UICollectionViewLayout *)collectionViewLayout
//minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//  return ((SCREEN_WIDTH-20)-65*3)/4-2;
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.entity.apps.count;
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableCell forIndexPath:indexPath];
    
    cell.delegate = self;
    CGApps *app = [self.entity.apps objectAtIndex:indexPath.item];
  if (app.isAdd) {
    cell.headerIV.image = [UIImage imageNamed:app.icon];
  }else{
    [cell.headerIV sd_setImageWithURL:[NSURL URLWithString:app.icon] placeholderImage:[UIImage imageNamed:@"morentu"]];
  }
  cell.indexPath = indexPath;
  cell.selectButton.selected = NO;
  for (int i=0; i<self.deleteArray.count; i++) {
    if ([[self.deleteArray objectAtIndex:i] isKindOfClass:[CGApps class]]) {
      CGApps *app1 = [self.deleteArray objectAtIndex:i];
      if ([app.mid isEqualToString:app1.mid]) {
        cell.selectButton.selected = YES;
      }
    }
  }
    cell.isExpIV.hidden = app.isExp == YES?NO:YES;
    cell.titleLabel.text = app.pName;
    cell.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    if (cell.hidden) {  //防止hide属性的cell的重用导致部分cell消失
      cell.hidden = NO;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.homeCollectionV.editing==NO) {
    CGApps *app = [self.entity.apps objectAtIndex:indexPath.item];
    if (app.isAdd) {
      addGroupBlock(self.entity.gid);
    }else{
     appClickBlock(app);
    }
    [self closeMySelf];
  }else{
    if (self.homeCollectionV.editing) {
      SubCollectionViewCell *cell = (SubCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath ];
      if (cell.selectButton.selected) {
        cell.selectButton.selected = NO;
        CGApps *app = [self.entity.apps objectAtIndex:cell.indexPath.item];
        [self.deleteArray removeObject:app];
      }else{
        cell.selectButton.selected = YES;
        CGApps *app = [self.entity.apps objectAtIndex:cell.indexPath.item];
        [self.deleteArray addObject:app];
      }
    }
  }
}

//长按进入编辑状态回调
- (void)dragCellCollectionViewEditing:(XWDragCellCollectionView *)collectionView{
  editingBlock(self.homeCollectionV.editing);
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.entity.apps.count-1 inSection:0];
  [self.entity.apps removeLastObject];
  [self.homeCollectionV deleteItemsAtIndexPaths:@[indexPath]];
  self.editing = self.homeCollectionV.editing;
  self.titleTextField.userInteractionEnabled = YES;
//  self.titleTextField.backgroundColor = CTCommonViewControllerBg;
  self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
  self.closeButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 70, 30, 30)];
  [self addSubview:self.closeButton];
  [self.closeButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
  [self.closeButton addTarget:self action:@selector(removeMySelf) forControlEvents:UIControlEventTouchUpInside];
  self.editingView.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __weak typeof(self) weakSelf = self;
  if (textField.text.length>0) {
    LightExpBiz *biz = [[LightExpBiz alloc]init];
    [biz discoverExpMyGroupRenameWithGid:self.entity.gid name:textField.text success:^{
      weakSelf.entity.gName = textField.text;
    } fail:^(NSError *error) {
      
    }];
    changeNameBlock(textField.text);
    [textField resignFirstResponder];
    return YES;
  }
  return NO;
}


- (void)modelCellButton:(SubCollectionViewCell *)cell  //删除响应方法
{
  if (cell.selectButton.selected) {
      CGApps *app = [self.entity.apps objectAtIndex:cell.indexPath.item];
      [self.deleteArray addObject:app];
  }else{
      CGApps *app = [self.entity.apps objectAtIndex:cell.indexPath.item];
      [self.deleteArray removeObject:app];
  }
//  self.deleteIndexPath = [self.homeCollectionV indexPathForCell:cell];
//  UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",@"移出该组", nil];
//  alert.tag = 1000;
//  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (alertView.tag == 1000) {
    if (buttonIndex == 1) {
//      NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.entity.apps];
//      CGApps *app = [self.entity.apps objectAtIndex:self.deleteIndexPath.item];
//      LightExpBiz *biz = [[LightExpBiz alloc]init];
//      [tmpArray removeObjectAtIndex:self.deleteIndexPath.item];
//      self.entity.apps = tmpArray;
//      [self.homeCollectionV deleteItemsAtIndexPaths:@[self.deleteIndexPath]];
//      delBlock(self.entity.apps);
//      [biz discoverExpMyDeleteWithID:app.mid success:^{
//      } fail:^(NSError *error) {
//        
//      }];
    }else if (buttonIndex == 2){
//      CGApps *app = [self.entity.apps objectAtIndex:self.deleteIndexPath.item];
//      LightExpBiz *biz = [[LightExpBiz alloc]init];
//      [biz.component startBlockAnimation];
//      NSArray *idArray = @[app.pid];
//      [biz discoverExpMyGroupAddWithids:idArray gid:self.entity.gid op:NO success:^{
//        [biz.component stopBlockAnimation];
//        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.entity.apps];
//        [tmpArray removeObjectAtIndex:self.deleteIndexPath.item];
//        self.entity.apps = tmpArray;
//        removeBlock(tmpArray);
//        self.deleteArray = [NSMutableArray array]
//        [self.homeCollectionV deleteItemsAtIndexPaths:@[self.deleteIndexPath]];
//      } fail:^(NSError *error) {
//        [biz.component stopBlockAnimation];
//      }];
    }
  }
  else if (alertView.tag == 1001){
      __weak typeof(self) weakSelf = self;
      if (buttonIndex == 1) {
        LightExpBiz *biz = [[LightExpBiz alloc]init];
        [biz.component startBlockAnimation];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:self.entity.mid, nil];
        [biz discoverExpMyDeleteWithID:array success:^() {
          NSMutableArray *array = [NSMutableArray arrayWithObject:weakSelf.entity];
          [LightExpDao deleteLightExpWithUserID:array];
          [weakSelf closeMySelf];
          removeGroupBlock(weakSelf.entity);
          [biz.component stopBlockAnimation];
        } fail:^(NSError *error) {
          [biz.component stopBlockAnimation];
        }];
      }
  }
}

- (void)closeMySelf{
  if (!self.homeCollectionV.editing) {
    [self.entity.apps removeLastObject];
  }
  self.closeButton.hidden = YES;
    __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.3 animations:^{
    weakSelf.bgView.alpha = 0;
    weakSelf.bgButton.alpha = 0;
    weakSelf.editingView.alpha = 0;
  } completion:^(BOOL finished) {
    [weakSelf removeFromSuperview];
  }];
  cancelBlock(YES);
}

- (void)removeMySelf{
  UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"组里面有产品是否删除组" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
  alert.tag = 1001;
  [alert show];
}

-(void)showInView:(UIView *)view{
    __weak typeof(self) weakSelf = self;
  [view addSubview:self];
  self.closeButton.hidden = NO;
  [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.85
        initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
          weakSelf.bgView.alpha = 1;
          weakSelf.bgButton.alpha = 1;
        }completion:^(BOOL finished) {
          if (weakSelf.editing) {
           [weakSelf.homeCollectionV xw_enterEditingModel];
          }
  }];
}
@end
