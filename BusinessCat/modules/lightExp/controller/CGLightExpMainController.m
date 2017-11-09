//
//  CGLightExpMainController.m
//  CGSays
//
//  Created by zhu on 2016/11/30.
//  Copyright © 2016年 cgsyas. All rights reserved.

#import "CGLightExpMainController.h"
#import "XWDragCellCollectionView.h"
#import "SubCollectionViewCell.h"
#import "SubMoreCollectionViewCell.h"
#import "CGLightExpPushView.h"
#import "LightExpBiz.h"
#import "DiscoverPushView.h"
#import "CGUserTextViewController.h"
#import "CGLightExpEntity.h"
#import "WKWebViewController.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import "CGAddIntoGroupViewController.h"
#import "CGMainLoginViewController.h"
#import "CGUserDao.h"
#import "CTRootViewController.h"
#import "CGFristOpenView.h"
#import "CGUserFireViewController.h"
#import "CGHeadlineGlobalSearchViewController.h"
#import "LightExpDao.h"

@interface CGLightExpMainController ()<UICollectionViewDelegate,UICollectionViewDataSource,XWDragCellCollectionViewDelegate,XWDragCellCollectionViewDataSource,SubCollectionViewCellDelegate,SubMoreCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *appsView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *moveGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *combineButton;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomSV;
@property (nonatomic, strong) XWDragCellCollectionView *homeCollectionV;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *buttomData;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (nonatomic, strong) CGLightExpPushView *pushView;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;
@property (weak, nonatomic) IBOutlet UIView *nilBGView;
@property (weak, nonatomic) IBOutlet UIButton *creatButton;
@property (nonatomic, strong) NSMutableArray *groupArray;
@property (nonatomic, strong) LightExpBiz *biz;

@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) NSMutableArray *moveArray;
@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, assign) BOOL isOpenGroup;
@property (nonatomic, assign) BOOL isSort;
@property (nonatomic, copy) NSString *selectGroupID;
@end

@implementation CGLightExpMainController


-(void)viewDidDisappear:(BOOL)animated{
    [self.biz.component stopBlockAnimation];
  self.isClick = YES;
}

- (void)viewDidLoad {
    self.title = @"体验";
  [super viewDidLoad];
    [self hideCustomBackBtn];
  self.isOpenGroup = 0;
  self.biz = [[LightExpBiz alloc]init];
  [self setCollection];
  [self getNaviButton];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update:) name:NOTIFICATION_JOINPRODUCT object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getLocalityData) name:NOTIFICATION_UPDATLIGHTEXP object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSccess) name:NOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:NOTIFICATION_LOGOUT object:nil];
}

- (void)loginSccess{
  [self getData];
}

- (void)logout{
  self.nilBGView.hidden = NO;
  self.homeCollectionV.hidden = YES;
  self.editButton.hidden = YES;
  self.deleteButton.hidden = YES;
  self.creatButton.hidden = YES;
  self.moveGroupButton.hidden = YES;
  self.combineButton.hidden = YES;
  self.editButton.selected = NO;
  self.data = [NSMutableArray array];
  self.groupArray = [NSMutableArray array];
  [self.homeCollectionV reloadData];
}

- (void)update:(NSNotification*) notification{
  if ([[notification object] isKindOfClass:[CGApps class]]) {
    CGApps *app = [notification object];
    [self.data insertObject:app atIndex:0];
    [self.homeCollectionV reloadData];
    [LightExpDao saveLightExpAppToDB:app];
  }else if([[notification object] isKindOfClass:[CGLightExpEntity class]]){
    CGLightExpEntity *app = [notification object];
    [self.data insertObject:app atIndex:0];
    [self.homeCollectionV reloadData];
    [LightExpDao saveLightExpEntityToDB:app];
  }else if ([[notification object] isKindOfClass:[NSDictionary class]]){
    NSDictionary *dic = [notification object];
    NSString *gid = dic[@"gid"];
    CGApps *comment = dic[@"apps"];
    //CGApps *comment = [CGApps mj_objectWithKeyValues:apps];
    for (int i =0; i<self.data.count; i++) {
      if ([self.data[i] isKindOfClass:[CGLightExpEntity class]]) {
        CGLightExpEntity *entity = self.data[i];
        if ([entity.gid isEqualToString:gid]) {
          [entity.apps addObject:comment];
          [self.homeCollectionV reloadData];
          NSArray *dictArray = [CGApps mj_keyValuesArrayWithObjectArray:entity.apps];
          NSError *error;
          NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
          NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
          [LightExpDao updateLightExpByMid:entity.mid appsJsonStr:jsonString];
          break;
        }
      }
    }
  }else{
    [self getData];
  }
  if (self.data.count<=0) {
    self.nilBGView.hidden = NO;
    self.homeCollectionV.hidden = YES;
    self.editButton.hidden = YES;
    self.deleteButton.hidden = YES;
    self.creatButton.hidden = YES;
    self.moveGroupButton.hidden = YES;
    self.combineButton.hidden = YES;
    self.editButton.selected = NO;
  }else{
    self.nilBGView.hidden = YES;
    self.homeCollectionV.hidden = NO;
    self.editButton.hidden = NO;
  }
}
//初始化搜索按钮和添加按钮
- (void)getNaviButton{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 30, 24, 24)];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"common_add_white"] forState:UIControlStateNormal];
    [self.navi addSubview:rightBtn];
    
//    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-69, 30, 24, 24)];
//    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"common_search__white_icon"] forState:UIControlStateNormal];
//    [self.navi addSubview:searchBtn];
}

- (IBAction)createClick:(UIButton *)sender {
  //添加组
  __weak typeof(self) weakSelf = self;
  CGUserTextViewController *vc = [[CGUserTextViewController alloc]initWithBlock:^(NSString *text,NSString *textID, UserTextType type) {
    __strong typeof(weakSelf) swself = weakSelf;
    [swself.biz.component startBlockAnimation];
    [swself.biz discoverExpAddGroupWithName:text success:^(CGLightExpEntity *entity) {
      [swself.biz.component stopBlockAnimation];
      [weakSelf.data insertObject:entity atIndex:0];
      [weakSelf.homeCollectionV reloadData];
      [LightExpDao saveLightExpEntityToDB:entity];
    } fail:^(NSError *error) {
      [swself.biz.component stopBlockAnimation];
    }];
  }];
  vc.textType = UserTextTypeAddGroup;
  [self.navigationController pushViewController:vc animated:YES];
}


- (void)getData{
  __weak typeof(self) weakSelf = self;
    [self.biz discoverExpMyExperience:^(NSMutableArray *result, NSMutableArray *groupArray) {
        if (result.count<=0) {
            weakSelf.nilBGView.hidden = NO;
            weakSelf.homeCollectionV.hidden = YES;
            weakSelf.editButton.hidden = YES;
            weakSelf.deleteButton.hidden = YES;
            weakSelf.creatButton.hidden = YES;
            weakSelf.moveGroupButton.hidden = YES;
            weakSelf.combineButton.hidden = YES;
            weakSelf.editButton.selected = NO;
        }else{
            weakSelf.nilBGView.hidden = YES;
            weakSelf.homeCollectionV.hidden = NO;
            weakSelf.editButton.hidden = NO;
        }
        weakSelf.data = result;
        weakSelf.groupArray = groupArray;
      if (weakSelf.isOpenGroup) {
        for (CGLightExpEntity *entity in groupArray) {
          if ([weakSelf.selectGroupID isEqualToString:entity.gid]) {
            [weakSelf.pushView reloadDataWithEntity:entity];
            break;
          }
        }
      }
        [weakSelf.homeCollectionV reloadData];
    } fail:^(NSError *error) {
    }];
}

- (void)getLocalityData{
  __weak typeof(self) weakSelf = self;
    [LightExpDao queryInfoDataFromDBSuccess:^(NSMutableArray *result, NSMutableArray *groupArray) {
        weakSelf.data = result;
        weakSelf.groupArray = groupArray;
        [weakSelf.homeCollectionV reloadData];
        if (weakSelf.data.count<=0) {
            weakSelf.nilBGView.hidden = NO;
            weakSelf.homeCollectionV.hidden = YES;
            weakSelf.editButton.hidden = YES;
            weakSelf.deleteButton.hidden = YES;
            weakSelf.creatButton.hidden = YES;
            weakSelf.moveGroupButton.hidden = YES;
            weakSelf.combineButton.hidden = YES;
            weakSelf.editButton.selected = NO;
        }else{
            weakSelf.nilBGView.hidden = YES;
            weakSelf.homeCollectionV.hidden = NO;
            weakSelf.editButton.hidden = NO;
        }
      [weakSelf getData];
    } fail:^(NSError *error) {
        [weakSelf getData];
    }];
}

- (void)rightBtnAction:(UIButton *)sender{
//    __weak typeof(self) weakSelf = self;
//    if (self.isClick) {
//        self.isClick = NO;
//        [WKWebViewController setPath:@"setCurrentPath" code:@"library/ProductList?action=exp" success:^(id response) {
//        } fail:^{
//        }];
//    }
  CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
  vc.type = 8;
  vc.action = @"joinExp";
  vc.searchType = 2;
  vc.attentionType = @"查看全部产品>";
  [self.navigationController pushViewController:vc animated:YES];
  
}

- (void)searchBtnAction:(UIButton *)sender{
    CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
    vc.type = 8;
    vc.action = @"joinExp";
    vc.searchType = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

//初始化我的体验CollectionView
- (void)setCollection{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(65, 80);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.homeCollectionV = [[XWDragCellCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40-44) collectionViewLayout:flowLayout];
    self.homeCollectionV.backgroundColor = [UIColor clearColor];
    self.homeCollectionV.tag = 100;
    self.homeCollectionV.delegate = self;
    self.homeCollectionV.dataSource = self;
    self.homeCollectionV.showsVerticalScrollIndicator = NO;
    self.homeCollectionV.showsHorizontalScrollIndicator = NO;
    [self.appsView addSubview:self.homeCollectionV];
    
    //注册单元格
    [self.homeCollectionV registerNib:[UINib nibWithNibName:reusableCell
                                                     bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:reusableCell];
    [self.homeCollectionV registerNib:[UINib nibWithNibName:reusMoreableCell
                                                     bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:reusMoreableCell];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    self.data = [newDataArray mutableCopy];
    [self getDataSort];
}

- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
    return  self.data;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.data.count;
}

//- (CGFloat) collectionView:(UICollectionView *)collectionView
//                    layout:(UICollectionViewLayout *)collectionViewLayout
//minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return (SCREEN_WIDTH-65*5)/6-2;
//}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.data objectAtIndex:indexPath.item] isKindOfClass:[CGLightExpEntity class]]) {
        SubMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusMoreableCell forIndexPath:indexPath];
        CGLightExpEntity *entity = [self.data objectAtIndex:indexPath.item];
        NSInteger count = entity.apps.count<=4?entity.apps.count:4;
        for (int i=0; i<count; i++) {
            CGApps *app = entity.apps[i];
            UIImageView *iv = [cell.icons objectAtIndex:i];
            [iv sd_setImageWithURL:[NSURL URLWithString:app.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
        }
        for (NSInteger i = count; i<4; i++) {
            UIImageView *iv = [cell.icons objectAtIndex:i];
            iv.image = nil;
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.titleLabel.text = entity.gName;
        if (cell.hidden) {  //防止hide属性的cell的重用导致部分cell消失
            cell.hidden = NO;
        }
        cell.selectButton.selected = NO;
        if (self.homeCollectionV.editing) {
            cell.selectButton.hidden = NO;
        }else{
            cell.selectButton.hidden = YES;
        }
        for (int i=0; i<self.deleteArray.count; i++) {
            if ([[self.deleteArray objectAtIndex:i] isKindOfClass:[CGLightExpEntity class]]) {
                CGLightExpEntity *entity1 = [self.deleteArray objectAtIndex:i];
                if ([entity.mid isEqualToString:entity1.mid]) {
                    cell.selectButton.selected = YES;
                }
            }
        }
        //    cell.selectButton.selected = NO;
        return cell;
    }else{
        SubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableCell forIndexPath:indexPath];
        cell.delegate = self;
        CGApps *app = [self.data objectAtIndex:indexPath.item];
        [cell.headerIV sd_setImageWithURL:[NSURL URLWithString:app.icon] placeholderImage:[UIImage imageNamed:@"morentuzhengfangxing"]];
        cell.isExpIV.hidden = app.isExp == YES?NO:YES;
        cell.titleLabel.text = app.pName;
        cell.indexPath = indexPath;
        if (self.homeCollectionV.editing) {
            cell.selectButton.hidden = NO;
        }else{
            cell.selectButton.hidden = YES;
        }
        cell.selectButton.selected = NO;
        for (int i=0; i<self.deleteArray.count; i++) {
            if ([[self.deleteArray objectAtIndex:i] isKindOfClass:[CGApps class]]) {
                CGApps *app1 = [self.deleteArray objectAtIndex:i];
                if ([app.mid isEqualToString:app1.mid]) {
                    cell.selectButton.selected = YES;
                }
            }
        }
        if (cell.hidden) {  //防止hide属性的cell的重用导致部分cell消失
            cell.hidden = NO;
        }
        
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if ([[self.data objectAtIndex:indexPath.item] isKindOfClass:[CGApps class]]) {
        if (self.homeCollectionV.editing) {
            SubCollectionViewCell *cell = (SubCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath ];
            if (cell.selectButton.selected) {
                cell.selectButton.selected = NO;
                CGApps *app = [self.data objectAtIndex:cell.indexPath.item];
                [self.moveArray removeObject:app];
                [self.deleteArray removeObject:app];
            }else{
                cell.selectButton.selected = YES;
                CGApps *app = [self.data objectAtIndex:cell.indexPath.item];
                [self.moveArray addObject:app];
                [self.deleteArray addObject:app];
            }
        }else{
            CGApps *app = [self.data objectAtIndex:indexPath.item];
          NSString *code;
          if (app.isExp) {
            code = [NSString stringWithFormat:@"details/experienceDetails?id=%@",app.pid];
          }else{
            code = [NSString stringWithFormat:@"details/productDetails?id=%@",app.pid];
          }
            if (self.isClick) {
                self.isClick = NO;
                [WKWebViewController setPath:@"setCurrentPath" code:code success:^(id response) {
                } fail:^{
                  weakSelf.isClick = YES;
                }];
                
            }
        }
    }
    
    if ([[self.data objectAtIndex:indexPath.item] isKindOfClass:[CGLightExpEntity class]]) {
        self.isOpenGroup = 1;
        SubMoreCollectionViewCell *cell = (SubMoreCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        CGLightExpEntity *entity = [self.data objectAtIndex:indexPath.item];
        self.selectGroupID = entity.gid;
        __weak typeof(self) weakSelf = self;
        self.pushView = [[CGLightExpPushView alloc]initWithEntity:[self.data objectAtIndex:indexPath.item] editing:self.homeCollectionV.editing block:^(NSArray *array) {
            entity.apps = [array mutableCopy];
            [weakSelf.homeCollectionV reloadData];
        } sortBlock:^(NSMutableArray *array) {
            NSInteger count = entity.apps.count>=4?4:(entity.apps.count);
            for (int i=0; i<count; i++) {
                CGApps *app = entity.apps[i];
                UIImageView *iv = [cell.icons objectAtIndex:i];
                [iv sd_setImageWithURL:[NSURL URLWithString:app.icon] placeholderImage:[UIImage imageNamed:@"morentu"]];
                
            }
            [weakSelf getDataSort];
        } remove:^(NSMutableArray *array) {
            [weakSelf getData];
        } removeGroup:^(CGLightExpEntity *reMoveEntity) {
            [weakSelf getData];
            
        } appClick:^(CGApps *app) {
          NSString *code;
          if (app.isExp) {
            code = [NSString stringWithFormat:@"details/experienceDetails?id=%@",app.pid];
          }else{
            code = [NSString stringWithFormat:@"details/productDetails?id=%@",app.pid];
          }
            if (weakSelf.isClick) {
                weakSelf.isClick = NO;
                [WKWebViewController setPath:@"setCurrentPath" code:code success:^(id response) {
                } fail:^{
                  weakSelf.isClick = YES;
                }];
            }
        } changeEditing:^(BOOL editing) {
            [weakSelf.homeCollectionV xw_enterEditingModel];
            weakSelf.deleteButton.hidden = NO;
            weakSelf.creatButton.hidden = NO;
            weakSelf.moveGroupButton.hidden = NO;
            weakSelf.combineButton.hidden = NO;
            weakSelf.editButton.selected = editing;
            weakSelf.moveArray = [NSMutableArray array];
            weakSelf.deleteArray = [NSMutableArray array];
        } changeName:^(NSString *name) {
            SubMoreCollectionViewCell *cell = (SubMoreCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.titleLabel.text = name;
        }addGroup:^(NSString *groupId) {
          /*
            NSString *code = [NSString stringWithFormat:@"productList?action=exp&groupId=%@",groupId];
            if (weakSelf.isClick) {
                weakSelf.isClick = NO;
                [WKWebViewController setPath:@"setCurrentPath" code:code success:^(id response) {
                } fail:^{
                  weakSelf.isClick = YES;
                }];
            }
           */
          self.isOpenGroup = 1;
          CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
          vc.type = 8;
          vc.action = @"joinExp";
          vc.searchType = 2;
          vc.groupId = groupId;
          [weakSelf.navigationController pushViewController:vc animated:YES];
        } cancel:^(BOOL isCancel) {
          self.isOpenGroup = 0;
        }];
        [self.pushView showInView:[UIApplication sharedApplication].keyWindow];
    }
}

//长按进入编辑状态回调
- (void)dragCellCollectionViewEditing:(XWDragCellCollectionView *)collectionView{
    self.editButton.selected = self.homeCollectionV.editing;
    self.moveGroupButton.hidden = NO;
    self.combineButton.hidden = NO;
    self.deleteButton.hidden = NO;
    self.creatButton.hidden = NO;
    self.moveArray = [NSMutableArray array];
    self.deleteArray = [NSMutableArray array];
}

//选择/取消选中cell
- (void)modelCellButton:(SubCollectionViewCell *)cell
{
    if (cell.selectButton.selected) {
        //选中
        if ([[self.data objectAtIndex:cell.indexPath.item] isKindOfClass:[CGLightExpEntity class]]) {
            CGLightExpEntity *entity = [self.data objectAtIndex:cell.indexPath.item];
            [self.deleteArray addObject:entity];
            
        }else{
            CGApps *app = [self.data objectAtIndex:cell.indexPath.item];
            [self.moveArray addObject:app];
            [self.deleteArray addObject:app];
        }
    }else{
        //未选中
        if ([[self.data objectAtIndex:cell.indexPath.item] isKindOfClass:[CGLightExpEntity class]]) {
            CGLightExpEntity *entity = [self.data objectAtIndex:cell.indexPath.item];
            [self.deleteArray removeObject:entity];
            
        }else{
            CGApps *app = [self.data objectAtIndex:cell.indexPath.item];
            [self.moveArray removeObject:app];
            [self.deleteArray removeObject:app];
        }
        
    }
    //  self.deleteIndexPath = [self.homeCollectionV indexPathForCell:cell];
    //  UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",@"移进组", nil];
    //  [alert show];
}

- (void)didMoveGroupCellWith:(CGLightExpEntity *)entity{
    for (int i=0; i<self.data.count; i++) {
        if ([self.data[i] isKindOfClass:[CGLightExpEntity class]]) {
            CGLightExpEntity *selectEntity = self.data[i];
            if ([entity.mid isEqualToString:selectEntity.mid]) {
                [self.data replaceObjectAtIndex:i withObject:entity];
                SubMoreCollectionViewCell * cell = (SubMoreCollectionViewCell *)[self.homeCollectionV
                                                                                 cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                
                NSInteger count = entity.apps.count<=4?entity.apps.count:4;
                for (int i=0; i<count; i++) {
                    CGApps *app = entity.apps[i];
                    UIImageView *iv = [cell.icons objectAtIndex:i];
                    [iv sd_setImageWithURL:[NSURL URLWithString:app.icon] placeholderImage:[UIImage imageNamed:@"headline_list_default_icon"]];
                }
                for (NSInteger i = count; i<9; i++) {
                    UIImageView *iv = [cell.icons objectAtIndex:i];
                    iv.image = nil;
                }
                return;
            }
        }
    }
}

//初始化最近用过ScrollView
- (void)getLatelyView{
    for(UIView *view in [self.bottomSV subviews])
    {
        [view removeFromSuperview];
    }
    for (int i = 0; i<self.buttomData.count; i++) {
        CGApps *app = self.buttomData[i];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10+i*(95), 5, 70, 85)];
        [self.bottomSV addSubview:bgView];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
        btn.layer.cornerRadius = 14;
        btn.layer.masksToBounds = YES;
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:app.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headline_list_default_icon"]];
        [bgView addSubview:btn];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 67, 70, 18)];
        label.text = app.pName;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [CTCommonUtil convert16BinaryColor:@"#333333"];
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
    }
    [self.bottomSV setContentSize:CGSizeMake(self.buttomData.count*95+10, 0)];
}

- (void)getDataSort{
    NSMutableArray *sortArray = [NSMutableArray array];
    for (int i=0; i<self.data.count; i++) {
        if ([self.data[i] isKindOfClass:[CGLightExpEntity class]]) {
            CGLightExpEntity *comment = self.data[i];
            NSMutableArray *appsArray = [NSMutableArray array];
            for (CGApps *app in comment.apps) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:app.mid,@"mid", nil];
                [appsArray addObject:dic];
            }
            NSDictionary *sortDic = [NSDictionary dictionaryWithObjectsAndKeys:comment.mid,@"mid",appsArray,@"apps", nil];
            [sortArray addObject:sortDic];
        }else if ([self.data[i] isKindOfClass:[CGApps class]]){
            CGApps *comment = self.data[i];
            NSDictionary *sortDic = [NSDictionary dictionaryWithObjectsAndKeys:comment.mid,@"mid", nil];
            [sortArray addObject:sortDic];
        }
    }
    [self.biz discoverExpMySortWithApps:sortArray success:^{
        self.isSort = YES;
    } fail:^(NSError *error) {
        
    }];
    
}
- (IBAction)addLightExp:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
//    CGUserDao *dao = [[CGUserDao alloc]init];
//    CGUserEntity *userInfo = [dao getLoginedUserFromLocal];
//    if (userInfo.isLogin == 0) {
//        [self login];
//    }else{
        if (self.isClick) {
            self.isClick = NO;
            [WKWebViewController setPath:@"setCurrentPath" code:@"library/ProductList?action=exp" success:^(id response) {
            } fail:^{
              weakSelf.isClick = YES;
            }];
        }
//    }
}

- (void)login{
    CGMainLoginViewController *controller = [[CGMainLoginViewController alloc]init];
//    [self presentViewController:controller animated:YES completion:nil];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isClick = YES;
  //  CTRootViewController *vc = [self.navigationController.childViewControllers lastObject];
 // NSLog(@"%@",[vc.childViewControllers lastObject]);
 //   if ([[vc.childViewControllers lastObject] isKindOfClass:[self class]]) {
        if (self.isOpenGroup == 1) {
            SubMoreCollectionViewCell *cell = (SubMoreCollectionViewCell *)[self.homeCollectionV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.isOpenGroup inSection:0]];
            CGLightExpEntity *selectEntity;
            int select = 0;
            __weak typeof(self) weakSelf = self;
            for (int i=0; i<self.data.count; i++) {
                if ([self.data[i] isKindOfClass:[CGLightExpEntity class]]) {
                    CGLightExpEntity *entity = self.data[i];
                    if ([self.selectGroupID isEqualToString:entity.gid]) {
                        selectEntity = entity;
                        select = i;
                        break;
                    }
                }
            }
            self.pushView = [[CGLightExpPushView alloc]initWithEntity:selectEntity editing:self.homeCollectionV.editing block:^(NSArray *array) {
                selectEntity.apps = [array mutableCopy];
                [weakSelf.homeCollectionV reloadData];
            } sortBlock:^(NSMutableArray *array) {
                NSInteger count = selectEntity.apps.count>=4?4:(selectEntity.apps.count);
                for (int i=0; i<count; i++) {
                    CGApps *app = selectEntity.apps[i];
                    UIImageView *iv = [cell.icons objectAtIndex:i];
                    [iv sd_setImageWithURL:[NSURL URLWithString:app.icon] placeholderImage:[UIImage imageNamed:@"morentu"]];
                    
                }
                [weakSelf getDataSort];
            } remove:^(NSMutableArray *array) {
                [weakSelf getData];
            } removeGroup:^(CGLightExpEntity *reMoveEntity) {
                [weakSelf getData];
                
            } appClick:^(CGApps *app) {
                NSString *code = [NSString stringWithFormat:@"discover/productDetails?id=%@&tabIndex=%ld",app.pid,(long)app.isExp];
                if (weakSelf.isClick) {
                    weakSelf.isClick = NO;
                    [WKWebViewController setPath:@"setCurrentPath" code:code success:^(id response) {
                    } fail:^{
                      weakSelf.isClick = YES;
                    }];
                }
            } changeEditing:^(BOOL editing) {
                [weakSelf.homeCollectionV xw_enterEditingModel];
                weakSelf.deleteButton.hidden = NO;
                weakSelf.creatButton.hidden = NO;
                weakSelf.moveGroupButton.hidden = NO;
                weakSelf.combineButton.hidden = NO;
                weakSelf.editButton.selected = editing;
                weakSelf.moveArray = [NSMutableArray array];
                weakSelf.deleteArray = [NSMutableArray array];
            } changeName:^(NSString *name) {
                SubMoreCollectionViewCell *cell = (SubMoreCollectionViewCell *)[self.homeCollectionV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:select inSection:0]];
                cell.titleLabel.text = name;
            }addGroup:^(NSString *groupId) {
              /*
                NSString *code = [NSString stringWithFormat:@"productList?action=exp&groupId=%@",groupId];
                if (weakSelf.isClick) {
                    weakSelf.isClick = NO;
                    [WKWebViewController setPath:@"setCurrentPath" code:code success:^(id response) {
                    } fail:^{
                      weakSelf.isClick = YES;
                    }];
                }
               */
              self.isOpenGroup = 1;
              CGHeadlineGlobalSearchViewController *vc = [[CGHeadlineGlobalSearchViewController alloc]init];
              vc.type = 8;
              vc.action = @"joinExp";
              vc.searchType = 2;
              vc.groupId = groupId;
              [weakSelf.navigationController pushViewController:vc animated:YES];
            } cancel:^(BOOL isCancel) {
              self.isOpenGroup = 0;
            }];
            [self.pushView showInView:[UIApplication sharedApplication].keyWindow];
        }
//    }
}

//移入组点击事件
- (IBAction)moveGroupClick:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (self.moveArray.count<=0) {
        [[CTToast makeText:@"请选择移动的产品！"]show:[UIApplication sharedApplication].keyWindow];
        return;
    }
    //移进组
    CGAddIntoGroupViewController *vc = [[CGAddIntoGroupViewController alloc]initWithArray:self.groupArray block:^(CGLightExpEntity *entity) {
        NSMutableArray *idArray = [NSMutableArray array];
        for (CGApps *app in self.moveArray) {
            [idArray addObject:app.mid];
        }
        [self.biz.component startBlockAnimation];
        [self.biz discoverExpMyGroupAddWithids:idArray gid:entity.gid op:YES success:^{
            [weakSelf.biz.component stopBlockAnimation];
            [weakSelf getData];
            weakSelf.moveArray = [NSMutableArray array];
            weakSelf.deleteArray = [NSMutableArray array];
        } fail:^(NSError *error) {
            [weakSelf.biz.component stopBlockAnimation];
        }];
  } addGroupBlock:^(CGLightExpEntity *entity) {
    [self.data insertObject:entity atIndex:0];
    [self.homeCollectionV reloadData];
    [LightExpDao saveLightExpEntityToDB:entity];
  }];
  [self.navigationController pushViewController:vc animated:YES];
}

//删除点击事件
- (IBAction)deleteClick:(UIButton *)sender {
    if (self.deleteArray.count<=0) {
        [[CTToast makeText:@"请选择删除的产品！"]show:[UIApplication sharedApplication].keyWindow];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定删除！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    [alert show];
    
}

//合并点击
- (IBAction)combineClick:(UIButton *)sender {
    if (self.moveArray.count<=0) {
        [[CTToast makeText:@"请选择合并的产品！"]show:[UIApplication sharedApplication].keyWindow];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"合并" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alert.tag = 1000;
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"请输入组名";
    [alert show];
}

#pragma mark - 点击代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    __weak typeof(self) weakSelf = self;
    if (buttonIndex == 1) {
        if (alertView.tag == 1001) {
            NSMutableArray *idArray = [NSMutableArray array];
            for (CGApps *app in self.deleteArray) {
                [idArray addObject:app.mid];
            }
            [self.deleteButton setUserInteractionEnabled:NO];
            LightExpBiz *biz = [[LightExpBiz alloc]init];
            [biz.component startBlockAnimation];
            [biz discoverExpMyDeleteWithID:idArray success:^() {
                [weakSelf.data removeObjectsInArray:weakSelf.deleteArray];
                [weakSelf.groupArray removeObjectsInArray:weakSelf.deleteArray];
                [LightExpDao deleteLightExpWithUserID:weakSelf.deleteArray];
                weakSelf.deleteArray = [NSMutableArray array];
                weakSelf.moveArray = [NSMutableArray array];
                if (weakSelf.data.count<=0) {
                    weakSelf.nilBGView.hidden = NO;
                    weakSelf.homeCollectionV.hidden = YES;
                    weakSelf.editButton.hidden = YES;
                    weakSelf.deleteButton.hidden = YES;
                    weakSelf.creatButton.hidden = YES;
                    weakSelf.moveGroupButton.hidden = YES;
                    weakSelf.combineButton.hidden = YES;
                    weakSelf.editButton.selected = NO;
                    [weakSelf.homeCollectionV xw_stopEditingModel];
                }else{
                    weakSelf.nilBGView.hidden = YES;
                    weakSelf.homeCollectionV.hidden = NO;
                    weakSelf.editButton.hidden = NO;
                }
                //        self.data = result;
                //        self.groupArray = groupArray;
                [weakSelf.homeCollectionV reloadData];
                [biz.component stopBlockAnimation];
                [weakSelf.deleteButton setUserInteractionEnabled:YES];
            } fail:^(NSError *error) {
                [weakSelf.deleteButton setUserInteractionEnabled:YES];
                [biz.component stopBlockAnimation];
            }];
        }else if(alertView.tag == 1000){
      UITextField *text = [alertView textFieldAtIndex:0];
      if (text.text.length<=0) {
        [[CTToast makeText:@"组名不能为空！"]show:[UIApplication sharedApplication].keyWindow];
        return;
      }
      [self.biz.component startBlockAnimation];
      [self.biz discoverExpAddGroupWithName:text.text success:^(CGLightExpEntity *entity) {
        NSMutableArray *idArray = [NSMutableArray array];
        for (CGApps *app in weakSelf.moveArray) {
          [idArray addObject:app.mid];
        }
        [weakSelf.biz discoverExpMyGroupAddWithids:idArray gid:entity.gid op:YES success:^{
          [weakSelf getData];
          weakSelf.moveArray = [NSMutableArray array];
          weakSelf.deleteArray = [NSMutableArray array];
          [weakSelf.biz.component stopBlockAnimation];
        } fail:^(NSError *error) {
          [weakSelf.biz.component stopBlockAnimation];
        }];
      } fail:^(NSError *error) {
        [weakSelf.biz.component stopBlockAnimation];
      }];
    }
  }
}

//编辑按钮点击事件
- (IBAction)click:(UIButton *)sender {
  self.moveArray = [NSMutableArray array];
  self.deleteArray = [NSMutableArray array];
  if (sender.selected == NO) {
    [self.homeCollectionV xw_enterEditingModel];
    self.deleteButton.hidden = NO;
    self.creatButton.hidden = NO;
    self.moveGroupButton.hidden = NO;
    self.combineButton.hidden = NO;
  }else{
    [self.homeCollectionV xw_stopEditingModel];
    self.deleteButton.hidden = YES;
    self.creatButton.hidden = YES;
    self.moveGroupButton.hidden = YES;
    self.combineButton.hidden = YES;
    if (self.isSort) {
     [self getData];
      self.isSort = NO;
    }
  }
  sender.selected = !sender.selected;
}
@end
